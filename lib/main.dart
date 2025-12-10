import 'package:app_emergencia/screens/dashboard_screen.dart';
import 'package:app_emergencia/screens/history_screen.dart';
import 'package:app_emergencia/screens/settings_screen.dart';
import 'package:app_emergencia/screens/weather_screen.dart';
import 'package:app_emergencia/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; 

import 'providers/weather_provider.dart';
import 'providers/app_provider.dart';
import 'models/event_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: const EmergencyApp(),
    ),
  );
}

class EmergencyApp extends StatelessWidget {
  const EmergencyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitoramento Pessoal',
      theme: ThemeData(primarySwatch: Colors.red, useMaterial3: true),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  final NotificationService _notifService = NotificationService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("App retomado: Cancelando alertas sonoros.");
      _notifService.cancelAllNotifications();
    }
  }

  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const HistoryScreen(),
    const WeatherScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Monitor'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Histórico'),
          NavigationDestination(icon: Icon(Icons.cloud), label: 'Clima'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Ajustes'),
        ],
      ),
    );
  }
}
