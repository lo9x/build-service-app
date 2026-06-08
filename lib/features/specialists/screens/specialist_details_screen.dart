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
      child: _isLoading
          ? const LoadingBlock()
          : _error != null || _specialist == null
              ? ErrorBlock(
                  message: _error ?? 'Специалист не найден.',
                  onRetry: _load,
                )
              : SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _specialist!.user.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _specialist!.profession,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          MetaChip(label: _specialist!.user.city, icon: Icons.location_on),
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
                      const SizedBox(height: 20),
                      Text(
                        'О специалисте',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(_specialist!.description),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: const Color(0xFFD7C4AF)),
                        ),
                        child: const Text(
                          'В MVP заказ создаётся отдельно, а специалист отправляет отклик со страницы заказа.',
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
