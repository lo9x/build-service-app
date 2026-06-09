import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/specialist_profile.dart';
import '../../../core/services/app_repository.dart';
import '../../../shared/formatters.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../controllers/specialists_controller.dart';

class SpecialistDetailsScreen extends StatefulWidget {
  const SpecialistDetailsScreen({
    super.key,
    required this.specialistId,
  });

  final String specialistId;

  @override
  State<SpecialistDetailsScreen> createState() => _SpecialistDetailsScreenState();
}

class _SpecialistDetailsScreenState extends State<SpecialistDetailsScreen> {
  late final SpecialistsController _controller;
  SpecialistProfile? _specialist;
  String? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = SpecialistsController(repository: context.read<AppRepository>());
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final specialist = await _controller.loadById(widget.specialistId);
    if (!mounted) {
      return;
    }
    setState(() {
      _specialist = specialist;
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
    return AppPageScaffold(
      title: 'Профиль специалиста',
      subtitle: 'Карточка исполнителя из каталога',
      child: _isLoading
          ? const LoadingBlock()
          : _error != null || _specialist == null
              ? ErrorBlock(
                  message: _error ?? 'Специалист не найден.',
                  onRetry: _load,
                )
              : Column(
                  children: [
                    HeroPanel(
                      eyebrow: _specialist!.profession,
                      title: _specialist!.user.name,
                      description: _specialist!.description,
                      dark: false,
                      footer: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          MetaChip(
                            label: _specialist!.user.city,
                            icon: Icons.location_on_outlined,
                          ),
                          MetaChip(
                            label: '${_specialist!.experience} лет опыта',
                            icon: Icons.work_outline,
                          ),
                          MetaChip(
                            label: 'от ${moneyFormat.format(_specialist!.priceFrom)}',
                            icon: Icons.payments_outlined,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionHeading(
                            title: 'Как показать этот экран',
                            description: 'Используйте его на защите, чтобы продемонстрировать просмотр анкеты специалиста из общего каталога.',
                          ),
                          SizedBox(height: 14),
                          Text(
                            'В MVP заказ создаётся отдельно, а специалист отправляет отклик со страницы заказа. Поэтому здесь акцент сделан на доверии к исполнителю: опыт, профессия, город и стартовая цена.',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
