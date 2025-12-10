import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeatherProvider>(context, listen: false).loadWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Clima Local")),
      body: Center(
        child: _buildBody(provider),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: provider.isLoading ? null : () => provider.loadWeather(),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildBody(WeatherProvider provider) {
    if (provider.isLoading) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text("Obtendo localização e clima...")
        ],
      );
    }

    if (provider.errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              "Ocorreu um erro:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              provider.errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => provider.loadWeather(),
              child: const Text("Tentar Novamente"),
            )
          ],
        ),
      );
    }

    if (provider.weather != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wb_sunny, size: 100, color: Colors.orange),
          const SizedBox(height: 20),
          Text(
            "${provider.weather!.temperature}°C",
            style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            "Lat: ${provider.weather!.latitude.toStringAsFixed(2)}, Long: ${provider.weather!.longitude.toStringAsFixed(2)}",
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 30),
          const Card(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Dados fornecidos por Open-Meteo API\n(Validação Acadêmica)",
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          )
        ],
      );
    }

    return const Text("Pressione o botão para carregar.");
  }
}