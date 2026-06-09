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
      subtitle: 'Открытые строительные задачи для специалистов',
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
              HeroPanel(
                eyebrow: auth.isCustomer ? 'Сценарий заказчика' : 'Сценарий специалиста',
                title: 'Заказы собраны в одном каталоге.',
                description: auth.isCustomer
                    ? 'Создавайте новые заявки и показывайте куратору, как заказчик публикует задачу и получает отклики.'
                    : 'Специалист видит открытые заказы, фильтрует их по городу и категории и выбирает подходящие объекты.',
                dark: false,
                actions: auth.isCustomer
                    ? [
                        ElevatedButton(
                          onPressed: () => context.push('/orders/create'),
                          child: const Text('Создать заказ'),
                        ),
                      ]
                    : const [],
              ),
              const SizedBox(height: 16),
              FilterPanel(
                title: 'Фильтры',
                description: 'Можно быстро показать отбор по городу или категории.',
                child: Column(
                  children: [
                    TextField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'Город',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                        labelText: 'Категория',
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
                  message: 'Измените фильтры или создайте новый заказ в роли заказчика.',
                )
              else
                ..._controller.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CatalogCard(
                      title: item.title,
                      subtitle: item.description,
                      onTap: () => context.push('/orders/${item.id}'),
                      meta: [
                        MetaChip(label: item.category, icon: Icons.category_outlined),
                        MetaChip(label: item.city, icon: Icons.location_on_outlined),
                        MetaChip(
                          label: moneyFormat.format(item.budget),
                          icon: Icons.payments_outlined,
                        ),
                      ],
                      footer: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Заказчик: ${item.customerName ?? 'не указан'}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          const SizedBox(width: 12),
                          TextButton(
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
