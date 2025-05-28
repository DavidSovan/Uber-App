import 'package:flutter/material.dart';
import 'package:uber_taxi/models/driver.dart';
import 'package:uber_taxi/auth/services/list_drivers_service.dart';

class DriverProvider with ChangeNotifier {
  List<Driver> _drivers = [];
  DriverRating? _selectedDriverDetail;
  bool _isLoading = false;
  String? _errorMessage;

  List<Driver> get drivers => _drivers;
  DriverRating? get selectedDriverDetail => _selectedDriverDetail;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final ApiService _apiService = ApiService();

  Future<void> fetchDrivers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _drivers = await _apiService.fetchDrivers();
    } catch (e) {
      _errorMessage = 'Failed to load drivers: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDriverRatings(int driverId) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedDriverDetail = null; // Clear previous detail
    notifyListeners();

    try {
      _selectedDriverDetail = await _apiService.fetchDriverRatings(driverId);
    } catch (e) {
      _errorMessage = 'Failed to load driver details: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
