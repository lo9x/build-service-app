import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/services/app_repository.dart';
import '../../../features/auth/controllers/auth_controller.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../controllers/orders_controller.dart';

class RespondOrderScreen extends StatefulWidget {
  const RespondOrderScreen({
    super.key,
    required this.orderId,
  });

  final String orderId;

  @override
  State<RespondOrderScreen> createState() => _RespondOrderScreenState();
}

class _RespondOrderScreenState extends State<RespondOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  late final OrdersController _controller;
  final _messageController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = OrdersController(repository: context.read<AppRepository>());
  }

  @override
  void dispose() {
    _messageController.dispose();
    _priceController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthController>();

    return AppPageScaffold(
      title: 'Отклик на заказ',
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return SectionCard(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Предложите решение заказчику',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _messageController,
                    minLines: 4,
                    maxLines: 6,
                    decoration: const InputDecoration(labelText: 'Сообщение'),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Введите сообщение'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Предложенная цена',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Введите цену';
                      }
                      if (double.tryParse(value.replaceAll(',', '.')) == null) {
                        return 'Введите корректную цену';
                      }
                      return null;
                    },
                  ),
                  if (_controller.error != null) ...[
                    const SizedBox(height: 14),
                    Text(
                      _controller.error!,
                      style: const TextStyle(color: Color(0xFF9D3E23)),
                    ),
                  ],
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _controller.isLoading
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            final response = await _controller.createResponse(
                              token: auth.token!,
                              request: CreateResponseRequest(
                                orderId: widget.orderId,
                                message: _messageController.text.trim(),
                                price: double.parse(
                                  _priceController.text.replaceAll(',', '.'),
                                ),
                              ),
                            );
                            if (response != null && mounted) {
                              context.go('/orders/${widget.orderId}');
                            }
                          },
                    child: Text(
                      _controller.isLoading ? 'Отправляем...' : 'Отправить отклик',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
