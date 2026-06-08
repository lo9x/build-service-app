import 'package:flutter/foundation.dart';

import '../../../core/models/specialist_profile.dart';
import '../../../core/services/app_repository.dart';

class SpecialistsController extends ChangeNotifier {
  SpecialistsController({required AppRepository repository})
      : _repository = repository;

  final AppRepository _repository;

  List<SpecialistProfile> _items = [];
  bool _isLoading = false;
  String? _error;
  String _cityFilter = '';
  String _professionFilter = '';

  List<SpecialistProfile> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get cityFilter => _cityFilter;
  String get professionFilter => _professionFilter;

  Future<void> load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _items = await _repository.getSpecialists(
        city: _cityFilter,
        profession: _professionFilter,
      );
    } catch (error) {
      _error = error.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<SpecialistProfile?> loadById(String id) async {
    try {
      return await _repository.getSpecialistById(id);
    } catch (error) {
      _error = error.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return null;
    }
  }

  Future<SpecialistProfile?> saveProfile({
    required String token,
    required UpsertSpecialistRequest request,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await _repository.upsertSpecialistProfile(
        token: token,
        request: request,
      );
      final index = _items.indexWhere((item) => item.id == result.id);
      if (index == -1) {
        _items.insert(0, result);
      } else {
        _items[index] = result;
      }
      return result;
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
    required String profession,
  }) {
    _cityFilter = city;
    _professionFilter = profession;
  }
}
