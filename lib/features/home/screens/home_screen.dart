import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../config/app_config.dart';
import '../../../features/auth/controllers/auth_controller.dart';
import '../../../shared/widgets/common_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7F1E9), Color(0xFFECE2D6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Build Service',
                      style: theme.textTheme.headlineMedium,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/profile'),
                    child: Text(auth.isAuthenticated ? 'Профиль' : 'Войти'),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: const Color(0xFF202624),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        AppConfig.useMockApi
                            ? 'Демо-режим · mock API'
                            : 'Подключено к backend API',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Поиск строительных специалистов и заказов в одном приложении.',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      auth.isAuthenticated
                          ? 'Сценарии подстраиваются под вашу роль: заказчик создаёт заказ, специалист откликается и ведёт анкету.'
                          : 'Гость может просматривать каталоги, а после входа открываются заказы, отклики и личный кабинет.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ElevatedButton(
                          onPressed: () => context.push('/specialists'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF202624),
                            minimumSize: const Size(160, 56),
                          ),
                          child: const Text('Специалисты'),
                        ),
                        OutlinedButton(
                          onPressed: () => context.push('/orders'),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white24),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(160, 56),
                          ),
                          child: const Text('Заказы'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: const [
                  SizedBox(
                    width: 160,
                    child: StatPill(label: 'Основные роли', value: '2'),
                  ),
                  SizedBox(
                    width: 160,
                    child: StatPill(label: 'Ключевые сценарии', value: '6+'),
                  ),
                  SizedBox(
                    width: 160,
                    child: StatPill(label: 'Единый backend', value: 'REST'),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Что можно сделать', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 16),
                    const _HomeActionTile(
                      title: 'Каталог специалистов',
                      subtitle:
                          'Просмотр карточек с профессией, городом, опытом и стартовой ценой.',
                      route: '/specialists',
                    ),
                    const SizedBox(height: 12),
                    const _HomeActionTile(
                      title: 'Каталог заказов',
                      subtitle:
                          'Список открытых заказов с бюджетом и детальной страницей.',
                      route: '/orders',
                    ),
                    if (auth.isCustomer) ...[
                      const SizedBox(height: 12),
                      const _HomeActionTile(
                        title: 'Создать заказ',
                        subtitle:
                            'Форма для заказчика с названием, категорией, городом и бюджетом.',
                        route: '/orders/create',
                      ),
                    ],
                    if (auth.isAuthenticated) ...[
                      const SizedBox(height: 12),
                      const _HomeActionTile(
                        title: 'Личный профиль',
                        subtitle:
                            'Информация о текущем пользователе, ИНН, статус проверки и анкета специалиста.',
                        route: '/profile',
                      ),
                    ],
                    if (!auth.isAuthenticated) ...[
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => context.push('/auth'),
                        child: const Text('Регистрация и вход'),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeActionTile extends StatelessWidget {
  const _HomeActionTile({
    required this.title,
    required this.subtitle,
    required this.route,
  });

  final String title;
  final String subtitle;
  final String route;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(route),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFD7C4AF)),
          color: Colors.white.withOpacity(0.65),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(subtitle),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.arrow_forward_rounded),
          ],
        ),
      ),
    );
  }
}
