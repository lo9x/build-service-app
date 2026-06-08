import 'package:flutter/foundation.dart';

import '../../../core/models/build_order.dart';
import '../../../core/models/order_response.dart';
import '../../../core/services/app_repository.dart';

class OrdersController extends ChangeNotifier {
  OrdersController({required AppRepository repository}) : _repository = repository;

  final AppRepository _repository;

  List<BuildOrder> _items = [];
  bool _isLoading = false;
  String? _error;
  String _cityFilter = '';
  String _categoryFilter = '';

  List<BuildOrder> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get cityFilter => _cityFilter;
  String get categoryFilter => _categoryFilter;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _items = await _repository.getOrders(
        city: _cityFilter,
        category: _categoryFilter,
      );
    } catch (error) {
      _error = error.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<BuildOrder?> loadById(String id) async {
    try {
      return await _repository.getOrderById(id);
    } catch (error) {
      _error = error.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return null;
    }
  }

  Future<List<OrderResponse>> loadResponses({
    required String orderId,
    String? token,
  }) async {
    try {
      return await _repository.getResponsesForOrder(orderId: orderId, token: token);
    } catch (error) {
      _error = error.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return [];
    }
  }

  Future<BuildOrder?> createOrder({
    required String token,
    required CreateOrderRequest request,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final order = await _repository.createOrder(token: token, request: request);
      _items.insert(0, order);
      return order;
    } catch (error) {
      _error = error.toString().replaceFirst('Exception: ', '');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<OrderResponse?> createResponse({
    required String token,
    required CreateResponseRequest request,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      return await _repository.createResponse(token: token, request: request);
    } catch (error) {
      _error = error.toString().replaceFirst('Exception: ', '');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateFilters({
    required String city,
    required String category,
  }) {
    _cityFilter = city;
    _categoryFilter = category;
  }
}
