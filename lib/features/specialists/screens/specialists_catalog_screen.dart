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
                      controller: _professionController,
                      decoration: const InputDecoration(
                        labelText: 'Фильтр по профессии',
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
                  message:
                      'Попробуйте изменить город или профессию в фильтре.',
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
                            item.user.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              MetaChip(label: item.profession),
                              MetaChip(label: item.user.city),
                              MetaChip(label: '${item.experience} лет опыта'),
                              MetaChip(
                                label:
                                    'от ${moneyFormat.format(item.priceFrom)}',
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(item.description),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () =>
                                context.push('/specialists/${item.id}'),
                            child: const Text('Подробнее'),
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
