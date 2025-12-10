import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';

class WeatherService {
  
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Serviços de localização estão desativados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permissão de localização negada.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Permissões de localização permanentemente negadas.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<WeatherModel> fetchCurrentWeather() async {
    try {
      final position = await _getCurrentLocation();
      
      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=${position.latitude}&longitude=${position.longitude}&current=temperature_2m'
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        throw Exception('Falha ao carregar dados da API: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}