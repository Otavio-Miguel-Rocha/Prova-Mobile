import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _service = WeatherService();

  WeatherModel? _weather;
  bool _isLoading = false;
  String? _errorMessage;

  WeatherModel? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadWeather() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); 

    try {
      _weather = await _service.fetchCurrentWeather();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); 
    }
  }
}