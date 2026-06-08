import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/models/app_user.dart';
import '../../../core/services/app_repository.dart';
import '../../../core/services/google_auth_service.dart';
import '../../../shared/widgets/common_widgets.dart';
import '../controllers/auth_controller.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 2, vsync: this);

  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController(text: '123456');

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cityController = TextEditingController(text: 'Самара');
  final _passwordController = TextEditingController(text: '123456');
  final _innController = TextEditingController();
  final _documentController = TextEditingController(text: 'demo-doc.pdf');

  UserRole _selectedRole = UserRole.customer;
  CustomerType _selectedCustomerType = CustomerType.company;

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _passwordController.dispose();
    _innController.dispose();
    _documentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    return AppPageScaffold(
      title: 'Регистрация и вход',
      child: Column(
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Один аккаунт для сайта и Android-приложения',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'После авторизации вы получаете JWT token. Заказчик может создавать заказы, специалист — отправлять отклики и вести анкету.',
                ),
                const SizedBox(height: 18),
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Вход'),
                    Tab(text: 'Регистрация'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (auth.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SectionCard(
                child: Text(
                  auth.error!,
                  style: const TextStyle(color: Color(0xFF9D3E23)),
                ),
              ),
            ),
          SizedBox(
            height: 760,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLoginTab(context, auth),
                _buildRegisterTab(context, auth),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginTab(BuildContext context, AuthController auth) {
    return SectionCard(
      child: Form(
        key: _loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Вход по email и паролю', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 18),
            const FieldLabel('Email'),
            TextFormField(
              controller: _loginEmailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Введите email';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            const FieldLabel('Пароль'),
            TextFormField(
              controller: _loginPasswordController,
              obscureText: true,
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'Пароль должен быть не короче 6 символов';
                }
                return null;
              },
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: auth.isBusy ? null : () => _submitLogin(context, auth),
              child: Text(auth.isBusy ? 'Выполняем вход...' : 'Войти'),
            ),
            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: auth.isBusy ? null : () => _showGoogleSheet(context, auth),
              child: const Text('Войти через Google'),
            ),
            const SizedBox(height: 18),
            Text(
              'Тестовые данные demo-режима:\nЗаказчик: customer@test.ru / 123456\nСпециалист: specialist@test.ru / 123456',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterTab(BuildContext context, AuthController auth) {
    final isCustomer = _selectedRole == UserRole.customer;

    return SectionCard(
      child: Form(
        key: _registerFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Создание аккаунта', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 18),
            const FieldLabel('Имя'),
            TextFormField(
              controller: _nameController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Введите имя';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            const FieldLabel('Email'),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Введите email';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            const FieldLabel('Город'),
            TextFormField(
              controller: _cityController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Введите город';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            const FieldLabel('Пароль'),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'Пароль должен быть не короче 6 символов';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Роль',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: UserRole.values
                  .where((role) => role != UserRole.guest)
                  .map(
                    (role) => ChoiceChip(
                      label: Text(role.label),
                      selected: _selectedRole == role,
                      onSelected: (_) {
                        setState(() {
                          _selectedRole = role;
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
            if (isCustomer) ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<CustomerType>(
                value: _selectedCustomerType,
                decoration: const InputDecoration(
                  labelText: 'Тип заказчика',
                ),
                items: CustomerType.values
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCustomerType = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 14),
              const FieldLabel('ИНН'),
              TextFormField(
                controller: _innController,
                validator: (value) {
                  if (isCustomer && (value == null || value.trim().isEmpty)) {
                    return 'Введите ИНН';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              const FieldLabel('Документ подтверждения'),
              TextFormField(
                controller: _documentController,
                validator: (value) {
                  if (isCustomer && (value == null || value.trim().isEmpty)) {
                    return 'Укажите тестовый документ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Text(
                'Для учебной демонстрации используйте только тестовые данные и тестовые файлы.',
              ),
            ],
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: auth.isBusy ? null : () => _submitRegister(context, auth),
              child: Text(auth.isBusy ? 'Создаём аккаунт...' : 'Зарегистрироваться'),
            ),
            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: auth.isBusy ? null : () => _showGoogleSheet(context, auth),
              child: const Text('Регистрация через Google'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitLogin(BuildContext context, AuthController auth) async {
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }
    final ok = await auth.login(
      email: _loginEmailController.text.trim(),
      password: _loginPasswordController.text.trim(),
    );
    if (ok && mounted) {
      context.go('/');
    }
  }

  Future<void> _submitRegister(BuildContext context, AuthController auth) async {
    if (!_registerFormKey.currentState!.validate()) {
      return;
    }

    final ok = await auth.register(
      RegisterRequest(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        city: _cityController.text.trim(),
        role: _selectedRole,
        customerType:
            _selectedRole == UserRole.customer ? _selectedCustomerType : null,
        inn: _selectedRole == UserRole.customer ? _innController.text.trim() : null,
        verificationDocumentUrl: _selectedRole == UserRole.customer
            ? _documentController.text.trim()
            : null,
      ),
    );

    if (ok && mounted) {
      context.go('/');
    }
  }

  Future<void> _showGoogleSheet(BuildContext context, AuthController auth) async {
    final nameController = TextEditingController(text: _nameController.text);
    final emailController = TextEditingController(text: _emailController.text);
    final cityController = TextEditingController(
      text: _cityController.text.isEmpty ? 'Самара' : _cityController.text,
    );
    final innController = TextEditingController(text: _innController.text);
    final docController = TextEditingController(
      text: _documentController.text.isEmpty ? 'demo-doc.pdf' : _documentController.text,
    );
    var role = _selectedRole;
    var customerType = _selectedCustomerType;
    final formKey = GlobalKey<FormState>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: const Color(0xFFFFFCF7),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            12,
            20,
            MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          child: StatefulBuilder(
            builder: (sheetContext, setModalState) {
              return Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Google-вход',
                        style: Theme.of(sheetContext).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'В demo-режиме данные ниже используются как тестовый Google-профиль.',
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Имя'),
                        validator: (value) =>
                            value == null || value.trim().isEmpty ? 'Введите имя' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (value) => value == null || value.trim().isEmpty
                            ? 'Введите email'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: cityController,
                        decoration: const InputDecoration(labelText: 'Город'),
                        validator: (value) => value == null || value.trim().isEmpty
                            ? 'Введите город'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        children: UserRole.values
                            .where((item) => item != UserRole.guest)
                            .map(
                              (item) => ChoiceChip(
                                label: Text(item.label),
                                selected: role == item,
                                onSelected: (_) {
                                  setModalState(() {
                                    role = item;
                                  });
                                },
                              ),
                            )
                            .toList(),
                      ),
                      if (role == UserRole.customer) ...[
                        const SizedBox(height: 12),
                        DropdownButtonFormField<CustomerType>(
                          value: customerType,
                          decoration: const InputDecoration(
                            labelText: 'Тип заказчика',
                          ),
                          items: CustomerType.values
                              .map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type.label),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setModalState(() {
                                customerType = value;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: innController,
                          decoration: const InputDecoration(labelText: 'ИНН'),
                          validator: (value) => value == null || value.trim().isEmpty
                              ? 'Введите ИНН'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: docController,
                          decoration: const InputDecoration(
                            labelText: 'Тестовый документ',
                          ),
                          validator: (value) => value == null || value.trim().isEmpty
                              ? 'Укажите тестовый документ'
                              : null,
                        ),
                      ],
                      const SizedBox(height: 18),
                      ElevatedButton(
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          final ok = await auth.continueWithGoogle(
                            profile: GoogleSignInProfile(
                              name: nameController.text.trim(),
                              email: emailController.text.trim(),
                              city: cityController.text.trim(),
                            ),
                            role: role,
                            customerType:
                                role == UserRole.customer ? customerType : null,
                            inn: role == UserRole.customer
                                ? innController.text.trim()
                                : null,
                            verificationDocumentUrl: role == UserRole.customer
                                ? docController.text.trim()
                                : null,
                          );
                          if (!mounted) {
                            return;
                          }
                          Navigator.of(sheetContext).pop();
                          if (ok && context.mounted) {
                            context.go('/');
                          }
                        },
                        child: Text(
                          auth.isBusy ? 'Подключаем...' : 'Продолжить',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
