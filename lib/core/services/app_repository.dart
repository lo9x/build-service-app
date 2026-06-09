import 'dart:async';

import 'package:dio/dio.dart';

import '../../config/app_config.dart';
import '../models/app_user.dart';
import '../models/auth_session.dart';
import '../models/build_order.dart';
import '../models/order_response.dart';
import '../models/specialist_profile.dart';
import '../network/api_exception.dart';

class RegisterRequest {
  const RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.city,
    required this.role,
    this.customerType,
    this.inn,
    this.verificationDocumentUrl,
  });

  final String name;
  final String email;
  final String password;
  final String city;
  final UserRole role;
  final CustomerType? customerType;
  final String? inn;
  final String? verificationDocumentUrl;
}

class GoogleAuthRequest {
  const GoogleAuthRequest({
    required this.googleIdToken,
    required this.name,
    required this.email,
    required this.city,
    required this.role,
    this.customerType,
    this.inn,
    this.verificationDocumentUrl,
  });

  final String googleIdToken;
  final String name;
  final String email;
  final String city;
  final UserRole role;
  final CustomerType? customerType;
  final String? inn;
  final String? verificationDocumentUrl;
}

class CreateOrderRequest {
  const CreateOrderRequest({
    required this.title,
    required this.description,
    required this.category,
    required this.city,
    required this.budget,
  });

  final String title;
  final String description;
  final String category;
  final String city;
  final double budget;
}

class CreateResponseRequest {
  const CreateResponseRequest({
    required this.orderId,
    required this.message,
    required this.price,
  });

  final String orderId;
  final String message;
  final double price;
}

class UpsertSpecialistRequest {
  const UpsertSpecialistRequest({
    required this.profession,
    required this.experience,
    required this.description,
    required this.priceFrom,
  });

  final String profession;
  final int experience;
  final String description;
  final double priceFrom;
}

abstract class AppRepository {
  Future<AuthSession> login({
    required String email,
    required String password,
  });

  Future<AuthSession> register(RegisterRequest request);

  Future<AuthSession> signInWithGoogle(GoogleAuthRequest request);

  Future<List<SpecialistProfile>> getSpecialists({
    String? city,
    String? profession,
  });

  Future<SpecialistProfile> getSpecialistById(String id);

  Future<SpecialistProfile> upsertSpecialistProfile({
    required String token,
    required UpsertSpecialistRequest request,
  });

  Future<List<BuildOrder>> getOrders({
    String? city,
    String? category,
  });

  Future<BuildOrder> getOrderById(String id);

  Future<BuildOrder> createOrder({
    required String token,
    required CreateOrderRequest request,
  });

  Future<OrderResponse> createResponse({
    required String token,
    required CreateResponseRequest request,
  });

  Future<List<OrderResponse>> getResponsesForOrder({
    required String orderId,
    String? token,
  });
}

class AppRepositoryFactory {
  static AppRepository create() {
    if (AppConfig.useMockApi) {
      return MockAppRepository();
    }

    return RestAppRepository();
  }
}

class RestAppRepository implements AppRepository {
  RestAppRepository()
      : _dio = Dio(
          BaseOptions(
            baseUrl: AppConfig.apiBaseUrl,
            connectTimeout: const Duration(seconds: 12),
            receiveTimeout: const Duration(seconds: 12),
            headers: {'Content-Type': 'application/json'},
          ),
        );

  final Dio _dio;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: {'email': email, 'password': password},
      );
      return _parseSession(response.data);
    } on DioException catch (error) {
      throw ApiException(_extractError(error, 'Не удалось выполнить вход.'));
    }
  }

  @override
  Future<AuthSession> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        '/api/auth/register',
        data: {
          'name': request.name,
          'email': request.email,
          'password': request.password,
          'city': request.city,
          'role': userRoleToString(request.role),
          'customerType': customerTypeToString(request.customerType),
          'inn': request.inn,
          'verificationDocumentUrl': request.verificationDocumentUrl,
        },
      );
      return _parseSession(response.data);
    } on DioException catch (error) {
      throw ApiException(
        _extractError(error, 'Не удалось зарегистрировать пользователя.'),
      );
    }
  }

  @override
  Future<AuthSession> signInWithGoogle(GoogleAuthRequest request) async {
    try {
      final response = await _dio.post(
        '/api/auth/google',
        data: {
          'googleToken': request.googleIdToken,
          'name': request.name,
          'email': request.email,
          'city': request.city,
          'role': userRoleToString(request.role),
          'customerType': customerTypeToString(request.customerType),
          'inn': request.inn,
          'verificationDocumentUrl': request.verificationDocumentUrl,
        },
      );
      return _parseSession(response.data);
    } on DioException catch (error) {
      throw ApiException(
        _extractError(error, 'Не удалось выполнить вход через Google.'),
      );
    }
  }

  @override
  Future<List<SpecialistProfile>> getSpecialists({
    String? city,
    String? profession,
  }) async {
    try {
      final response = await _dio.get(
        '/api/specialists',
        queryParameters: {
          if (city != null && city.isNotEmpty) 'city': city,
          if (profession != null && profession.isNotEmpty)
            'profession': profession,
        },
      );
      return _extractList(response.data)
          .map((item) => SpecialistProfile.fromJson(item))
          .toList();
    } on DioException catch (error) {
      throw ApiException(
        _extractError(error, 'Не удалось загрузить специалистов.'),
      );
    }
  }

  @override
  Future<SpecialistProfile> getSpecialistById(String id) async {
    try {
      final response = await _dio.get('/api/specialists/$id');
      return SpecialistProfile.fromJson(_extractMap(response.data));
    } on DioException catch (error) {
      throw ApiException(
        _extractError(error, 'Не удалось загрузить профиль специалиста.'),
      );
    }
  }

  @override
  Future<SpecialistProfile> upsertSpecialistProfile({
    required String token,
    required UpsertSpecialistRequest request,
  }) async {
    try {
      final ownProfile = await getSpecialists();
      final current = ownProfile.firstWhere(
        (item) => item.user.id == _extractUserId(token),
        orElse: () => SpecialistProfile(
          id: '',
          userId: _extractUserId(token),
          profession: '',
          experience: 0,
          description: '',
          priceFrom: 0,
          user: AppUser(
            id: _extractUserId(token),
            name: '',
            email: '',
            role: UserRole.specialist,
            city: '',
          ),
        ),
      );

      final payload = {
        'profession': request.profession,
        'experience': request.experience,
        'description': request.description,
        'priceFrom': request.priceFrom,
      };

      final response = current.id.isEmpty
          ? await _dio.post(
              '/api/specialists',
              data: payload,
              options: Options(headers: _authHeaders(token)),
            )
          : await _dio.put(
              '/api/specialists/${current.id}',
              data: payload,
              options: Options(headers: _authHeaders(token)),
            );

      return SpecialistProfile.fromJson(_extractMap(response.data));
    } on DioException catch (error) {
      throw ApiException(
        _extractError(error, 'Не удалось сохранить анкету специалиста.'),
      );
    }
  }

  @override
  Future<List<BuildOrder>> getOrders({
    String? city,
    String? category,
  }) async {
    try {
      final response = await _dio.get(
        '/api/orders',
        queryParameters: {
          if (city != null && city.isNotEmpty) 'city': city,
          if (category != null && category.isNotEmpty) 'category': category,
        },
      );
      return _extractList(response.data)
          .map((item) => BuildOrder.fromJson(item))
          .toList();
    } on DioException catch (error) {
      throw ApiException(_extractError(error, 'Не удалось загрузить заказы.'));
    }
  }

  @override
  Future<BuildOrder> getOrderById(String id) async {
    try {
      final response = await _dio.get('/api/orders/$id');
      return BuildOrder.fromJson(_extractMap(response.data));
    } on DioException catch (error) {
      throw ApiException(
        _extractError(error, 'Не удалось загрузить страницу заказа.'),
      );
    }
  }

  @override
  Future<BuildOrder> createOrder({
    required String token,
    required CreateOrderRequest request,
  }) async {
    try {
      final response = await _dio.post(
        '/api/orders',
        data: {
          'title': request.title,
          'description': request.description,
          'category': request.category,
          'city': request.city,
          'budget': request.budget,
        },
        options: Options(headers: _authHeaders(token)),
      );
      return BuildOrder.fromJson(_extractMap(response.data));
    } on DioException catch (error) {
      throw ApiException(_extractError(error, 'Не удалось создать заказ.'));
    }
  }

  @override
  Future<OrderResponse> createResponse({
    required String token,
    required CreateResponseRequest request,
  }) async {
    try {
      final response = await _dio.post(
        '/api/responses',
        data: {
          'orderId': request.orderId,
          'message': request.message,
          'price': request.price,
        },
        options: Options(headers: _authHeaders(token)),
      );
      return OrderResponse.fromJson(_extractMap(response.data));
    } on DioException catch (error) {
      throw ApiException(_extractError(error, 'Не удалось отправить отклик.'));
    }
  }

  @override
  Future<List<OrderResponse>> getResponsesForOrder({
    required String orderId,
    String? token,
  }) async {
    try {
      final response = await _dio.get(
        '/api/responses/order/$orderId',
        options: Options(
          headers: token == null ? null : _authHeaders(token),
        ),
      );
      return _extractList(response.data)
          .map((item) => OrderResponse.fromJson(item))
          .toList();
    } on DioException catch (error) {
      throw ApiException(_extractError(error, 'Не удалось загрузить отклики.'));
    }
  }

  AuthSession _parseSession(dynamic data) {
    final map = _extractMap(data);
    return AuthSession(
      token: (map['token'] ?? '').toString(),
      user: AppUser.fromJson(_extractMap(map['user'])),
    );
  }

  Map<String, dynamic> _extractMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      if (value['data'] is Map<String, dynamic>) {
        return value['data'] as Map<String, dynamic>;
      }
      return value;
    }

    throw const ApiException('Ответ сервера имеет неверный формат.');
  }

  List<Map<String, dynamic>> _extractList(dynamic value) {
    final source = value is Map<String, dynamic> && value['data'] is List
        ? value['data']
        : value;

    if (source is List) {
      return source
          .whereType<Map>()
          .map((item) => item.cast<String, dynamic>())
          .toList();
    }

    throw const ApiException('Ответ сервера имеет неверный формат списка.');
  }

  Map<String, String> _authHeaders(String token) {
    return {'Authorization': 'Bearer $token'};
  }

  String _extractError(DioException error, String fallback) {
    final data = error.response?.data;
    if (data is Map<String, dynamic> && data['message'] != null) {
      return data['message'].toString();
    }
    return fallback;
  }

  String _extractUserId(String token) {
    return token.split('-').last;
  }
}

class MockAppRepository implements AppRepository {
  MockAppRepository() {
    _seed();
  }

  final List<AppUser> _users = [];
  final Map<String, String> _passwords = {};
  final List<SpecialistProfile> _specialists = [];
  final List<BuildOrder> _orders = [];
  final List<OrderResponse> _responses = [];
  bool _seeded = false;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    await _delay();
    final user = _users.cast<AppUser?>().firstWhere(
          (item) => item?.email.toLowerCase() == email.toLowerCase(),
          orElse: () => null,
        );
    if (user == null || _passwords[user.email] != password) {
      throw const ApiException('Неверный email или пароль.');
    }
    return AuthSession(token: _tokenFor(user.id), user: user);
  }

  @override
  Future<AuthSession> register(RegisterRequest request) async {
    await _delay();
    if (_users.any((item) => item.email.toLowerCase() == request.email.toLowerCase())) {
      throw const ApiException('Пользователь с таким email уже существует.');
    }

    final user = AppUser(
      id: 'user_${_users.length + 1}',
      name: request.name,
      email: request.email,
      role: request.role,
      city: request.city,
      customerType: request.customerType,
      inn: request.inn,
      verificationDocumentUrl: request.verificationDocumentUrl,
      verificationStatus: request.role == UserRole.customer
          ? VerificationStatus.pending
          : VerificationStatus.notRequired,
    );
    _users.add(user);
    _passwords[user.email] = request.password;

    if (user.isSpecialist) {
      _specialists.add(
        SpecialistProfile(
          id: 'spec_${_specialists.length + 1}',
          userId: user.id,
          profession: 'Специалист широкого профиля',
          experience: 1,
          description: 'Готов взять первый заказ и показать качество работы.',
          priceFrom: 3500,
          user: user,
        ),
      );
    }

    return AuthSession(token: _tokenFor(user.id), user: user);
  }

  @override
  Future<AuthSession> signInWithGoogle(GoogleAuthRequest request) async {
    await _delay();

    final existing = _users.cast<AppUser?>().firstWhere(
          (item) => item?.email.toLowerCase() == request.email.toLowerCase(),
          orElse: () => null,
        );

    if (existing != null) {
      return AuthSession(token: _tokenFor(existing.id), user: existing);
    }

    final user = AppUser(
      id: 'user_${_users.length + 1}',
      name: request.name,
      email: request.email,
      role: request.role,
      city: request.city,
      customerType: request.customerType,
      inn: request.inn,
      verificationDocumentUrl: request.verificationDocumentUrl,
      verificationStatus: request.role == UserRole.customer
          ? VerificationStatus.pending
          : VerificationStatus.notRequired,
    );
    _users.add(user);
    _passwords[user.email] = 'google-account';

    if (user.isSpecialist) {
      _specialists.add(
        SpecialistProfile(
          id: 'spec_${_specialists.length + 1}',
          userId: user.id,
          profession: 'Специалист после Google-регистрации',
          experience: 2,
          description: 'Анкета создана автоматически после входа через Google.',
          priceFrom: 5000,
          user: user,
        ),
      );
    }

    return AuthSession(token: _tokenFor(user.id), user: user);
  }

  @override
  Future<List<SpecialistProfile>> getSpecialists({
    String? city,
    String? profession,
  }) async {
    await _delay();
    return _specialists.where((item) {
      final cityOk = city == null ||
          city.isEmpty ||
          item.user.city.toLowerCase().contains(city.toLowerCase());
      final professionOk = profession == null ||
          profession.isEmpty ||
          item.profession.toLowerCase().contains(profession.toLowerCase());
      return cityOk && professionOk;
    }).toList();
  }

  @override
  Future<SpecialistProfile> getSpecialistById(String id) async {
    await _delay();
    return _specialists.firstWhere(
      (item) => item.id == id,
      orElse: () => throw const ApiException('Специалист не найден.'),
    );
  }

  @override
  Future<SpecialistProfile> upsertSpecialistProfile({
    required String token,
    required UpsertSpecialistRequest request,
  }) async {
    await _delay();
    final user = _requireUser(token);
    if (!user.isSpecialist) {
      throw const ApiException('Только специалист может редактировать анкету.');
    }

    final index = _specialists.indexWhere((item) => item.userId == user.id);
    final profile = SpecialistProfile(
      id: index == -1 ? 'spec_${_specialists.length + 1}' : _specialists[index].id,
      userId: user.id,
      profession: request.profession,
      experience: request.experience,
      description: request.description,
      priceFrom: request.priceFrom,
      user: user,
    );

    if (index == -1) {
      _specialists.add(profile);
    } else {
      _specialists[index] = profile;
    }

    return profile;
  }

  @override
  Future<List<BuildOrder>> getOrders({
    String? city,
    String? category,
  }) async {
    await _delay();
    return _orders.where((item) {
      final cityOk = city == null ||
          city.isEmpty ||
          item.city.toLowerCase().contains(city.toLowerCase());
      final categoryOk = category == null ||
          category.isEmpty ||
          item.category.toLowerCase().contains(category.toLowerCase());
      return cityOk && categoryOk;
    }).toList();
  }

  @override
  Future<BuildOrder> getOrderById(String id) async {
    await _delay();
    return _orders.firstWhere(
      (item) => item.id == id,
      orElse: () => throw const ApiException('Заказ не найден.'),
    );
  }

  @override
  Future<BuildOrder> createOrder({
    required String token,
    required CreateOrderRequest request,
  }) async {
    await _delay();
    final user = _requireUser(token);
    if (!user.isCustomer) {
      throw const ApiException('Создавать заказ может только заказчик.');
    }

    final order = BuildOrder(
      id: 'order_${_orders.length + 1}',
      title: request.title,
      description: request.description,
      budget: request.budget,
      city: request.city,
      category: request.category,
      customerId: user.id,
      status: 'open',
      customerName: user.name,
    );
    _orders.insert(0, order);
    return order;
  }

  @override
  Future<OrderResponse> createResponse({
    required String token,
    required CreateResponseRequest request,
  }) async {
    await _delay();
    final user = _requireUser(token);
    if (!user.isSpecialist) {
      throw const ApiException('Отклик может отправить только специалист.');
    }

    final profile = _specialists.cast<SpecialistProfile?>().firstWhere(
          (item) => item?.userId == user.id,
          orElse: () => null,
        );
    if (profile == null) {
      throw const ApiException('Сначала заполните анкету специалиста.');
    }

    final exists = _responses.any(
      (item) => item.orderId == request.orderId && item.specialistId == profile.id,
    );
    if (exists) {
      throw const ApiException('Вы уже отправили отклик на этот заказ.');
    }

    final response = OrderResponse(
      id: 'resp_${_responses.length + 1}',
      orderId: request.orderId,
      specialistId: profile.id,
      message: request.message,
      price: request.price,
      status: 'new',
      specialistName: user.name,
    );
    _responses.insert(0, response);
    return response;
  }

  @override
  Future<List<OrderResponse>> getResponsesForOrder({
    required String orderId,
    String? token,
  }) async {
    await _delay();
    return _responses.where((item) => item.orderId == orderId).toList();
  }

  void _seed() {
    if (_seeded) {
      return;
    }
    _seeded = true;

    const customer = AppUser(
      id: 'user_1',
      name: 'Мария Воронова',
      email: 'customer@test.ru',
      role: UserRole.customer,
      city: 'Самара',
      customerType: CustomerType.company,
      inn: '6317001234',
      verificationDocumentUrl: 'demo-company-card.pdf',
      verificationStatus: VerificationStatus.approved,
    );

    const specialistUser = AppUser(
      id: 'user_2',
      name: 'Илья Сергеев',
      email: 'specialist@test.ru',
      role: UserRole.specialist,
      city: 'Тольятти',
    );

    const specialistUserTwo = AppUser(
      id: 'user_3',
      name: 'Никита Абрамов',
      email: 'nikita@test.ru',
      role: UserRole.specialist,
      city: 'Самара',
    );

    _users.addAll([customer, specialistUser, specialistUserTwo]);
    _passwords[customer.email] = '123456';
    _passwords[specialistUser.email] = '123456';
    _passwords[specialistUserTwo.email] = '123456';

    _specialists.addAll([
      SpecialistProfile(
        id: 'spec_1',
        userId: specialistUser.id,
        profession: 'Отделочник',
        experience: 7,
        description:
            'Выполняю чистовую отделку квартир и коммерческих пространств под ключ.',
        priceFrom: 6500,
        user: specialistUser,
      ),
      SpecialistProfile(
        id: 'spec_2',
        userId: specialistUserTwo.id,
        profession: 'Электромонтажник',
        experience: 5,
        description:
            'Собираю щиты, делаю разводку и аккуратно закрываю документацию по работам.',
        priceFrom: 5400,
        user: specialistUserTwo,
      ),
    ]);

    _orders.addAll([
      BuildOrder(
        id: 'order_1',
        title: 'Косметический ремонт кухни',
        description:
            'Нужно выровнять стены, покрасить и установить фартук. Материалы частично уже закуплены.',
        budget: 85000,
        city: 'Самара',
        category: 'Отделка',
        customerId: customer.id,
        status: 'open',
        customerName: customer.name,
      ),
      BuildOrder(
        id: 'order_2',
        title: 'Замена электрики в офисе',
        description:
            'Требуется обновить проводку, перенести розетки и собрать новый щит на 12 модулей.',
        budget: 120000,
        city: 'Тольятти',
        category: 'Электрика',
        customerId: customer.id,
        status: 'open',
        customerName: customer.name,
      ),
    ]);

    _responses.add(
      const OrderResponse(
        id: 'resp_1',
        orderId: 'order_1',
        specialistId: 'spec_1',
        message: 'Могу приступить в понедельник, работаю по договору.',
        price: 79000,
        status: 'new',
        specialistName: 'Илья Сергеев',
      ),
    );
  }

  Future<void> _delay() {
    return Future<void>.delayed(const Duration(milliseconds: 350));
  }

  AppUser _requireUser(String token) {
    final userId = token.replaceFirst('mock-jwt-', '');
    return _users.firstWhere(
      (item) => item.id == userId,
      orElse: () => throw const ApiException('Сессия не найдена.'),
    );
  }

  String _tokenFor(String userId) => 'mock-jwt-$userId';
}
