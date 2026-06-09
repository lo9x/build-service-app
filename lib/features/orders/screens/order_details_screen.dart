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

    if (order != null && auth.isAuthenticated && auth.user?.id == order.customerId) {
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
      return const Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: LoadingBlock(),
          ),
        ),
      );
    }

    return AppPageScaffold(
      title: 'Страница заказа',
      subtitle: 'Подробности проекта и отклики специалистов',
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
                HeroPanel(
                  eyebrow: _order!.category,
                  title: _order!.title,
                  description: _order!.description,
                  dark: false,
                  footer: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      MetaChip(label: _order!.city, icon: Icons.location_on_outlined),
                      MetaChip(
                        label: moneyFormat.format(_order!.budget),
                        icon: Icons.payments_outlined,
                      ),
                      MetaChip(label: 'Статус: ${_order!.status}', icon: Icons.flag_outlined),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (auth.isSpecialist)
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeading(
                          title: 'Отклик специалиста',
                          description: 'Сообщение и предложенная цена отправляются заказчику.',
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.push('/orders/${widget.orderId}/respond'),
                          child: const Text('Отправить отклик'),
                        ),
                      ],
                    ),
                  ),
                if (auth.isAuthenticated && auth.user?.id == _order!.customerId) ...[
                  const SizedBox(height: 16),
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeading(
                          title: 'Отклики специалистов',
                          description: 'Итоговый экран для проверки конца пользовательского сценария.',
                        ),
                        const SizedBox(height: 16),
                        if (_responses.isEmpty)
                          const Text('Откликов пока нет.')
                        else
                          ..._responses.map(
                            (response) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: CatalogCard(
                                title: response.specialistName ?? 'Специалист',
                                subtitle: response.message,
                                onTap: () {},
                                meta: [
                                  MetaChip(
                                    label: moneyFormat.format(response.price),
                                    icon: Icons.payments_outlined,
                                  ),
                                  MetaChip(label: response.status, icon: Icons.schedule_outlined),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ] else if (!auth.isAuthenticated) ...[
                  const SizedBox(height: 16),
                  const EmptyBlock(
                    title: 'Войдите, чтобы продолжить',
                    message: 'Гость может просматривать заказ, но для отклика и создания заказа нужна авторизация.',
                  ),
                ],
              ],
            ),
    );
  }
}
