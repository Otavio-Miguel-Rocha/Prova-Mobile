class WeatherModel {
  final double temperature;
  final double latitude;
  final double longitude;

  WeatherModel({
    required this.temperature,
    required this.latitude,
    required this.longitude,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final current = json['current'];
    return WeatherModel(
      temperature: current['temperature_2m']?.toDouble() ?? 0.0,
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
    );
  }
}