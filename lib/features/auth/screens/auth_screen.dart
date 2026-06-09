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

class _AuthScreenState extends State<AuthScreen> {
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

  bool _isLoginMode = true;
  UserRole _selectedRole = UserRole.customer;
  CustomerType _selectedCustomerType = CustomerType.company;

  @override
  void dispose() {
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
      subtitle: 'Один аккаунт для сайта и Android-приложения',
      child: Column(
        children: [
          HeroPanel(
            eyebrow: 'Авторизация',
            title: 'Подключите роль и покажите рабочий сценарий за 2 минуты.',
            description: 'Экран подходит для демонстрации куратору: сначала вход под тестовым аккаунтом, затем регистрация под нужной ролью и переход в основной сценарий.',
            actions: [
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _isLoginMode = true;
                  });
                },
                child: const Text('Вход'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoginMode = false;
                  });
                },
                child: const Text('Регистрация'),
              ),
            ],
            footer: const Text(
              'После авторизации приложение получает JWT token. Заказчик создаёт заказы, специалист редактирует анкету и отправляет отклики.',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          const SizedBox(height: 16),
          if (auth.error != null) ...[
            SectionCard(
              child: Text(
                auth.error!,
                style: const TextStyle(color: Color(0xFFC66A3D), fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 16),
          ],
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: _isLoginMode
                ? KeyedSubtree(
                    key: const ValueKey('login_mode'),
                    child: _buildLoginCard(context, auth),
                  )
                : KeyedSubtree(
                    key: const ValueKey('register_mode'),
                    child: _buildRegisterCard(context, auth),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard(BuildContext context, AuthController auth) {
    return SectionCard(
      child: Form(
        key: _loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeading(
              title: 'Быстрый вход',
              description: 'Используйте тестовые аккаунты или покажите отдельный сценарий через Google.',
            ),
            const SizedBox(height: 18),
            const FieldLabel('Email'),
            TextFormField(
              controller: _loginEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'customer@test.ru'),
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
              decoration: const InputDecoration(hintText: 'Минимум 6 символов'),
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'Пароль должен быть не короче 6 символов';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: auth.isBusy ? null : () => _submitLogin(context, auth),
              child: Text(auth.isBusy ? 'Выполняем вход...' : 'Войти'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: auth.isBusy ? null : () => _showGoogleSheet(context, auth),
              child: const Text('Продолжить через Google'),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFD8CCBC)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Тестовые аккаунты',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 8),
                  Text('Заказчик: customer@test.ru / 123456'),
                  Text('Специалист: specialist@test.ru / 123456'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterCard(BuildContext context, AuthController auth) {
    final isCustomer = _selectedRole == UserRole.customer;

    return SectionCard(
      child: Form(
        key: _registerFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeading(
              title: 'Создание аккаунта',
              description: 'Сначала выберите роль, затем заполните поля и при необходимости данные заказчика.',
            ),
            const SizedBox(height: 18),
            const FieldLabel('Имя'),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Ильяс'),
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
              decoration: const InputDecoration(hintText: 'example@mail.ru'),
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
              decoration: const InputDecoration(hintText: 'Самара'),
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
              decoration: const InputDecoration(hintText: 'Не короче 6 символов'),
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'Пароль должен быть не короче 6 символов';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            Text(
              'Роль пользователя',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            RoleToggle(
              items: const ['Заказчик', 'Специалист'],
              selected: _selectedRole == UserRole.customer ? 'Заказчик' : 'Специалист',
              onSelected: (value) {
                setState(() {
                  _selectedRole =
                      value == 'Заказчик' ? UserRole.customer : UserRole.specialist;
                });
              },
            ),
            if (isCustomer) ...[
              const SizedBox(height: 18),
              DropdownButtonFormField<CustomerType>(
                initialValue: _selectedCustomerType,
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
                decoration: const InputDecoration(hintText: 'Например, 6317001234'),
                validator: (value) {
                  if (isCustomer && (value == null || value.trim().isEmpty)) {
                    return 'Введите ИНН';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              const FieldLabel('Тестовый документ'),
              TextFormField(
                controller: _documentController,
                decoration: const InputDecoration(hintText: 'demo-doc.pdf'),
                validator: (value) {
                  if (isCustomer && (value == null || value.trim().isEmpty)) {
                    return 'Укажите тестовый документ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              const Text(
                'Для учебной демонстрации используйте только тестовые данные и тестовые файлы.',
              ),
            ],
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: auth.isBusy ? null : () => _submitRegister(context, auth),
              child: Text(auth.isBusy ? 'Создаём аккаунт...' : 'Зарегистрироваться'),
            ),
            const SizedBox(height: 12),
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
    if (ok && context.mounted) {
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

    if (ok && context.mounted) {
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
      backgroundColor: const Color(0xFFFFFCF6),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            8,
            20,
            MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          child: StatefulBuilder(
            builder: (context, setSheetState) {
              return Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeading(
                        title: 'Google-вход',
                        description: 'В demo-режиме эта форма имитирует первый вход через Google.',
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
                        validator: (value) =>
                            value == null || value.trim().isEmpty ? 'Введите email' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: cityController,
                        decoration: const InputDecoration(labelText: 'Город'),
                        validator: (value) =>
                            value == null || value.trim().isEmpty ? 'Введите город' : null,
                      ),
                      const SizedBox(height: 18),
                      RoleToggle(
                        items: const ['Заказчик', 'Специалист'],
                        selected: role == UserRole.customer ? 'Заказчик' : 'Специалист',
                        onSelected: (value) {
                          setSheetState(() {
                            role = value == 'Заказчик'
                                ? UserRole.customer
                                : UserRole.specialist;
                          });
                        },
                      ),
                      if (role == UserRole.customer) ...[
                        const SizedBox(height: 14),
                        DropdownButtonFormField<CustomerType>(
                          initialValue: customerType,
                          decoration: const InputDecoration(labelText: 'Тип заказчика'),
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
                              setSheetState(() {
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
                          decoration: const InputDecoration(labelText: 'Тестовый документ'),
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
                            customerType: role == UserRole.customer ? customerType : null,
                            inn: role == UserRole.customer ? innController.text.trim() : null,
                            verificationDocumentUrl:
                                role == UserRole.customer ? docController.text.trim() : null,
                          );
                          if (!sheetContext.mounted) {
                            return;
                          }
                          Navigator.of(sheetContext).pop();
                          if (ok && context.mounted) {
                            context.go('/');
                          }
                        },
                        child: Text(auth.isBusy ? 'Подключаем...' : 'Продолжить'),
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
