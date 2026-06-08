import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/services/app_repository.dart';
import '../../../features/auth/controllers/auth_controller.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../controllers/orders_controller.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  late final OrdersController _controller;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _cityController = TextEditingController(text: 'Самара');
  final _budgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = OrdersController(repository: context.read<AppRepository>());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _cityController.dispose();
    _budgetController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthController>();

    return AppPageScaffold(
      title: 'Создание заказа',
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
                    'Новый строительный заказ',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Название'),
                    validator: (value) =>
                        value == null || value.trim().isEmpty ? 'Введите название' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descriptionController,
                    minLines: 4,
                    maxLines: 6,
                    decoration: const InputDecoration(labelText: 'Описание'),
                    validator: (value) =>
                        value == null || value.trim().isEmpty ? 'Введите описание' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _categoryController,
                    decoration: const InputDecoration(labelText: 'Категория'),
                    validator: (value) =>
                        value == null || value.trim().isEmpty ? 'Введите категорию' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(labelText: 'Город'),
                    validator: (value) =>
                        value == null || value.trim().isEmpty ? 'Введите город' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _budgetController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Бюджет'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Введите бюджет';
                      }
                      if (double.tryParse(value.replaceAll(',', '.')) == null) {
                        return 'Введите корректную сумму';
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
                            final order = await _controller.createOrder(
                              token: auth.token!,
                              request: CreateOrderRequest(
                                title: _titleController.text.trim(),
                                description: _descriptionController.text.trim(),
                                category: _categoryController.text.trim(),
                                city: _cityController.text.trim(),
                                budget: double.parse(
                                  _budgetController.text.replaceAll(',', '.'),
                                ),
                              ),
                            );
                            if (order != null && mounted) {
                              context.go('/orders/${order.id}');
                            }
                          },
                    child: Text(
                      _controller.isLoading ? 'Создаём...' : 'Опубликовать заказ',
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
