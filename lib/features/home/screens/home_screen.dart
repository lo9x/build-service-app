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

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Build Service',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                TextButton(
                  onPressed: () => context.push(auth.isAuthenticated ? '/profile' : '/auth'),
                  child: Text(auth.isAuthenticated ? 'Профиль' : 'Вход'),
                ),
              ],
            ),
            const SizedBox(height: 18),
            HeroPanel(
              eyebrow: AppConfig.useMockApi ? 'Демо-режим' : 'Подключено к API',
              title: 'Поиск специалистов и заказов в одном приложении.',
              description: auth.isAuthenticated
                  ? 'Сценарии уже подстроены под вашу роль. Заказчик публикует заказ и смотрит отклики, специалист ведёт анкету и находит работу.'
                  : 'Гость просматривает каталоги, а после входа открываются заказы, отклики и личный кабинет. Интерфейс подготовлен для демонстрации куратору.',
              actions: [
                ElevatedButton(
                  onPressed: () => context.push('/specialists'),
                  child: const Text('Найти специалиста'),
                ),
                OutlinedButton(
                  onPressed: () => context.push('/orders'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white38),
                  ),
                  child: const Text('Смотреть заказы'),
                ),
              ],
              footer: const Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: 150,
                    child: StatPill(label: 'Роли MVP', value: '2'),
                  ),
                  SizedBox(
                    width: 150,
                    child: StatPill(label: 'Сценарии', value: '8'),
                  ),
                  SizedBox(
                    width: 150,
                    child: StatPill(label: 'Интеграция', value: 'REST'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const SectionHeading(
              title: 'Что можно показать на защите',
              description: 'Ниже собраны основные сценарии, которые удобно открывать куратору по шагам.',
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 900;
                final cards = [
                  ActionTile(
                    title: 'Каталог специалистов',
                    description: 'Карточки с городом, профессией, опытом и стартовой ценой.',
                    icon: Icons.engineering_rounded,
                    onTap: () => context.push('/specialists'),
                  ),
                  ActionTile(
                    title: 'Каталог заказов',
                    description: 'Открытые заказы, фильтры и подробная страница проекта.',
                    icon: Icons.apartment_rounded,
                    onTap: () => context.push('/orders'),
                  ),
                  ActionTile(
                    title: auth.isCustomer ? 'Создать заказ' : 'Профиль пользователя',
                    description: auth.isCustomer
                        ? 'Заполните форму заказа и сразу покажите рабочий сценарий заказчика.'
                        : 'Откройте личный кабинет и продемонстрируйте настройки текущей роли.',
                    icon: auth.isCustomer ? Icons.add_box_rounded : Icons.person_rounded,
                    onTap: () => context.push(auth.isCustomer ? '/orders/create' : '/profile'),
                  ),
                  ActionTile(
                    title: 'Регистрация и вход',
                    description: 'Экран под обе роли с email-входом и демонстрационным Google-сценарием.',
                    icon: Icons.login_rounded,
                    onTap: () => context.push('/auth'),
                  ),
                ];

                if (compact) {
                  return Column(
                    children: cards
                        .map(
                          (card) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: card,
                          ),
                        )
                        .toList(),
                  );
                }

                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: cards
                      .map(
                        (card) => SizedBox(
                          width: (constraints.maxWidth - 12) / 2,
                          child: card,
                        ),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 22),
            const SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeading(
                    title: 'Логика MVP',
                    description: 'Эти три шага удобно проговаривать во время показа проекта.',
                  ),
                  SizedBox(height: 16),
                  _StoryRow(
                    index: '01',
                    title: 'Заказчик регистрируется и создаёт заказ',
                    text: 'Покажите форму регистрации, затем создание заказа с городом, бюджетом и описанием.',
                  ),
                  SizedBox(height: 12),
                  _StoryRow(
                    index: '02',
                    title: 'Специалист открывает каталог заказов',
                    text: 'Отфильтруйте заказы, откройте детальную страницу и продемонстрируйте карточку заказа.',
                  ),
                  SizedBox(height: 12),
                  _StoryRow(
                    index: '03',
                    title: 'Специалист оставляет отклик, заказчик его видит',
                    text: 'Это основной конец-to-end сценарий, который подтверждает рабочий MVP.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryRow extends StatelessWidget {
  const _StoryRow({
    required this.index,
    required this.title,
    required this.text,
  });

  final String index;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFD8CCBC)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF274C46),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              index,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(text),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
