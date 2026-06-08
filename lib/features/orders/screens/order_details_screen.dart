import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/models/build_order.dart';
import '../../../core/models/order_response.dart';
import '../../../core/services/app_repository.dart';
import '../../../features/auth/controllers/auth_controller.dart';
import '../../../shared/formatters.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../controllers/orders_controller.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({
    super.key,
    required this.orderId,
  });

  final String orderId;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late final OrdersController _controller;
  BuildOrder? _order;
  List<OrderResponse> _responses = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = OrdersController(repository: context.read<AppRepository>());
    _load();
  }

  Future<void> _load() async {
    final auth = context.read<AuthController>();
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final order = await _controller.loadById(widget.orderId);
    List<OrderResponse> responses = [];

    if (order != null &&
        auth.isAuthenticated &&
        auth.user?.id == order.customerId) {
      responses = await _controller.loadResponses(
        orderId: widget.orderId,
        token: auth.token,
      );
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _order = order;
      _responses = responses;
      _error = _controller.error;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    if (_isLoading) {
      return const Scaffold(body: SafeArea(child: LoadingBlock()));
    }

    return AppPageScaffold(
      title: 'Страница заказа',
      actions: [
        if (auth.isSpecialist)
          TextButton(
            onPressed: () => context.push('/orders/${widget.orderId}/respond'),
            child: const Text('Откликнуться'),
          ),
      ],
      child: _error != null || _order == null
          ? ErrorBlock(
              message: _error ?? 'Заказ не найден.',
              onRetry: _load,
            )
          : Column(
              children: [
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _order!.title,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          MetaChip(label: _order!.category),
                          MetaChip(label: _order!.city),
                          MetaChip(label: moneyFormat.format(_order!.budget)),
                          MetaChip(label: 'Статус: ${_order!.status}'),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(_order!.description),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (auth.isSpecialist)
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Отклик специалиста',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Отправьте сообщение и свою цену. Заказчик увидит отклик на этой странице.',
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () =>
                              context.push('/orders/${widget.orderId}/respond'),
                          child: const Text('Отправить отклик'),
                        ),
                      ],
                    ),
                  ),
                if (auth.isAuthenticated && auth.user?.id == _order!.customerId) ...[
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Отклики специалистов',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        if (_responses.isEmpty)
                          const Text('Откликов пока нет.')
                        else
                          ..._responses.map(
                            (response) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.65),
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: const Color(0xFFD7C4AF),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      response.specialistName ?? 'Специалист',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(fontWeight: FontWeight.w800),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Предложение: ${moneyFormat.format(response.price)}',
                                    ),
                                    const SizedBox(height: 8),
                                    Text(response.message),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ] else if (!auth.isAuthenticated)
                  const EmptyBlock(
                    title: 'Войдите, чтобы продолжить',
                    message:
                        'Гость может смотреть карточку заказа, а для отклика или создания заказа нужна авторизация.',
                  ),
              ],
            ),
    );
  }
}
