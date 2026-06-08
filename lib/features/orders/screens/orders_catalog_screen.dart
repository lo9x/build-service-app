import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/services/app_repository.dart';
import '../../../features/auth/controllers/auth_controller.dart';
import '../../../shared/formatters.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../controllers/orders_controller.dart';

class OrdersCatalogScreen extends StatefulWidget {
  const OrdersCatalogScreen({super.key});

  @override
  State<OrdersCatalogScreen> createState() => _OrdersCatalogScreenState();
}

class _OrdersCatalogScreenState extends State<OrdersCatalogScreen> {
  late final OrdersController _controller;
  final _cityController = TextEditingController();
  final _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = OrdersController(repository: context.read<AppRepository>());
    _controller.load();
  }

  @override
  void dispose() {
    _cityController.dispose();
    _categoryController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    return AppPageScaffold(
      title: 'Каталог заказов',
      actions: [
        if (auth.isCustomer)
          TextButton(
            onPressed: () => context.push('/orders/create'),
            child: const Text('Создать'),
          ),
      ],
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Column(
            children: [
              SectionCard(
                child: Column(
                  children: [
                    TextField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'Фильтр по городу',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                        labelText: 'Фильтр по категории',
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _controller.updateFilters(
                          city: _cityController.text.trim(),
                          category: _categoryController.text.trim(),
                        );
                        _controller.load();
                      },
                      child: const Text('Применить фильтр'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (_controller.isLoading)
                const LoadingBlock(label: 'Загрузка заказов...')
              else if (_controller.error != null)
                ErrorBlock(
                  message: _controller.error!,
                  onRetry: _controller.load,
                )
              else if (_controller.items.isEmpty)
                const EmptyBlock(
                  title: 'Заказы не найдены',
                  message: 'Попробуйте изменить фильтры или создайте новый заказ.',
                )
              else
                ..._controller.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              MetaChip(label: item.category),
                              MetaChip(label: item.city),
                              MetaChip(label: moneyFormat.format(item.budget)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(item.description),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context.push('/orders/${item.id}'),
                            child: const Text('Открыть заказ'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
