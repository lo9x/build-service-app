import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/models/app_user.dart';
import '../../../core/models/specialist_profile.dart';
import '../../../core/services/app_repository.dart';
import '../../../features/auth/controllers/auth_controller.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../../specialists/controllers/specialists_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final SpecialistsController _controller;
  final _professionController = TextEditingController();
  final _experienceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  SpecialistProfile? _profile;
  bool _loadingProfile = false;

  @override
  void initState() {
    super.initState();
    _controller = SpecialistsController(repository: context.read<AppRepository>());
    _loadSpecialistProfile();
  }

  Future<void> _loadSpecialistProfile() async {
    final auth = context.read<AuthController>();
    if (!auth.isSpecialist) {
      return;
    }
    setState(() {
      _loadingProfile = true;
    });
    await _controller.load();
    final current = _controller.items.cast<SpecialistProfile?>().firstWhere(
          (item) => item?.userId == auth.user?.id,
          orElse: () => null,
        );
    if (!mounted) {
      return;
    }
    setState(() {
      _profile = current;
      _professionController.text = current?.profession ?? '';
      _experienceController.text =
          current == null ? '' : current.experience.toString();
      _descriptionController.text = current?.description ?? '';
      _priceController.text =
          current == null ? '' : current.priceFrom.toStringAsFixed(0);
      _loadingProfile = false;
    });
  }

  @override
  void dispose() {
    _professionController.dispose();
    _experienceController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final user = auth.user!;

    return AppPageScaffold(
      title: 'Мой профиль',
      subtitle: 'Данные текущего пользователя и роль в системе',
      child: Column(
        children: [
          HeroPanel(
            eyebrow: user.role.label,
            title: user.name,
            description: user.isCustomer
                ? 'Профиль заказчика с ИНН, типом деятельности и статусом проверки.'
                : 'Профиль специалиста с редактируемой анкетой и базовыми данными аккаунта.',
            dark: false,
            footer: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                MetaChip(label: user.city, icon: Icons.location_on_outlined),
                MetaChip(label: user.email, icon: Icons.mail_outline_rounded),
                if (user.isCustomer && user.customerType != null)
                  MetaChip(label: user.customerType!.label, icon: Icons.business_outlined),
                if (user.isCustomer)
                  MetaChip(
                    label: user.verificationStatus.label,
                    icon: Icons.verified_user_outlined,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading(
                  title: 'Данные аккаунта',
                  description: 'Этот блок удобно показывать на защите как подтверждение ролевой модели.',
                ),
                const SizedBox(height: 16),
                Text('Email: ${user.email}'),
                if (user.isCustomer) ...[
                  const SizedBox(height: 8),
                  Text('ИНН: ${user.inn ?? 'Не указан'}'),
                  const SizedBox(height: 8),
                  Text('Документ: ${user.verificationDocumentUrl ?? 'Не указан'}'),
                ],
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await auth.logout();
                    if (context.mounted) {
                      context.go('/auth');
                    }
                  },
                  child: const Text('Выйти из аккаунта'),
                ),
              ],
            ),
          ),
          if (auth.isSpecialist) ...[
            const SizedBox(height: 16),
            SectionCard(
              child: _loadingProfile
                  ? const LoadingBlock(label: 'Загрузка анкеты...')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeading(
                          title: 'Анкета специалиста',
                          description: 'Редактирование профессии, опыта, описания и стартовой цены.',
                        ),
                        const SizedBox(height: 18),
                        TextField(
                          controller: _professionController,
                          decoration: const InputDecoration(
                            labelText: 'Профессия',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _experienceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Опыт работы (лет)',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _descriptionController,
                          minLines: 4,
                          maxLines: 6,
                          decoration: const InputDecoration(
                            labelText: 'Описание',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Цена от',
                          ),
                        ),
                        if (_controller.error != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            _controller.error!,
                            style: const TextStyle(
                              color: Color(0xFFC66A3D),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                        const SizedBox(height: 18),
                        ElevatedButton(
                          onPressed: _controller.isLoading
                              ? null
                              : () async {
                                  final saved = await _controller.saveProfile(
                                    token: auth.token!,
                                    request: UpsertSpecialistRequest(
                                      profession: _professionController.text.trim(),
                                      experience:
                                          int.tryParse(_experienceController.text) ?? 0,
                                      description: _descriptionController.text.trim(),
                                      priceFrom: double.tryParse(
                                            _priceController.text.replaceAll(',', '.'),
                                          ) ??
                                          0,
                                    ),
                                  );
                                  if (saved != null && context.mounted) {
                                    setState(() {
                                      _profile = saved;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Анкета сохранена'),
                                      ),
                                    );
                                  }
                                },
                          child: Text(
                            _profile == null ? 'Создать анкету' : 'Сохранить изменения',
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ],
      ),
    );
  }
}
