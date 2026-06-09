import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/services/app_repository.dart';
import '../../../shared/formatters.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../controllers/specialists_controller.dart';

class SpecialistsCatalogScreen extends StatefulWidget {
  const SpecialistsCatalogScreen({super.key});

  @override
  State<SpecialistsCatalogScreen> createState() =>
      _SpecialistsCatalogScreenState();
}

class _SpecialistsCatalogScreenState extends State<SpecialistsCatalogScreen> {
  late final SpecialistsController _controller;
  final _cityController = TextEditingController();
  final _professionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = SpecialistsController(repository: context.read<AppRepository>());
    _controller.load();
  }

  @override
  void dispose() {
    _cityController.dispose();
    _professionController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Каталог специалистов',
      subtitle: 'Поиск исполнителей по городу и профессии',
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Column(
            children: [
              const HeroPanel(
                eyebrow: 'Специалисты',
                title: 'Подберите исполнителя под задачу за несколько касаний.',
                description: 'В карточке видны профессия, город, опыт и стартовая цена. Этого достаточно для MVP-демонстрации поиска специалистов.',
                dark: false,
              ),
              const SizedBox(height: 16),
              FilterPanel(
                title: 'Фильтры',
                description: 'Оставьте пустым, если хотите показать общий список.',
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
                      controller: _professionController,
                      decoration: const InputDecoration(
                        labelText: 'Профессия',
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _controller.updateFilters(
                          city: _cityController.text.trim(),
                          profession: _professionController.text.trim(),
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
                const LoadingBlock()
              else if (_controller.error != null)
                ErrorBlock(
                  message: _controller.error!,
                  onRetry: _controller.load,
                )
              else if (_controller.items.isEmpty)
                const EmptyBlock(
                  title: 'Специалисты не найдены',
                  message: 'Измените фильтр по городу или профессии и попробуйте ещё раз.',
                )
              else
                ..._controller.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CatalogCard(
                      title: item.user.name,
                      subtitle: item.description,
                      onTap: () => context.push('/specialists/${item.id}'),
                      meta: [
                        MetaChip(label: item.profession, icon: Icons.badge_outlined),
                        MetaChip(label: item.user.city, icon: Icons.location_on_outlined),
                        MetaChip(label: '${item.experience} лет опыта', icon: Icons.work_outline),
                        MetaChip(
                          label: 'от ${moneyFormat.format(item.priceFrom)}',
                          icon: Icons.payments_outlined,
                        ),
                      ],
                      footer: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Подробнее о специалисте и его опыте',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          const SizedBox(width: 12),
                          TextButton(
                            onPressed: () => context.push('/specialists/${item.id}'),
                            child: const Text('Открыть'),
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
