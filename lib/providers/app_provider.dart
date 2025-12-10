import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event_model.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';

class AppProvider with ChangeNotifier {
  final DatabaseService _dbService;
  final NotificationService _notifService;

  bool _isSystemActive = false;
  bool _isCriticalMode = false;
  List<EventModel> _history = [];

  bool get isSystemActive => _isSystemActive;
  bool get isCriticalMode => _isCriticalMode;
  List<EventModel> get history => _history;

  // CONSTRUTOR ALTERADO: Aceita serviços opcionais
  AppProvider({DatabaseService? dbService, NotificationService? notifService})
    : _dbService = dbService ?? DatabaseService(),
      _notifService = notifService ?? NotificationService() {
    _initialize();
  }

  void _initialize() async {
    try {
      await _loadPreferences();
      await _loadHistory();
      await _notifService.init();
    } catch (e) {
      print("Erro na inicialização (ignorar se estiver rodando testes): $e");
    }
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isCriticalMode = prefs.getBool('critical_mode') ?? false;
    _isSystemActive = prefs.getBool('system_active') ?? true;
    notifyListeners();
  }

  void toggleSystem(bool value) async {
    _isSystemActive = value;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('system_active', value);

    _logEvent(value ? "Sistema Ativado" : "Sistema Desativado");
    notifyListeners();
  }

  void toggleCriticalMode(bool value) async {
    _isCriticalMode = value;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('critical_mode', value);
    notifyListeners();
  }

  Future<void> triggerPanic() async {
    if (!_isSystemActive) return;
    await _notifService.showNotification(
      title: "ALERTA DE PÂNICO",
      body: "Uma situação de emergência foi reportada.",
      isCritical: _isCriticalMode,
    );

    await _logEvent("Botão Pânico Acionado");
  }

  Future<void> _logEvent(String type) async {
    final event = EventModel(type: type, timestamp: DateTime.now());
    await _dbService.insertEvent(event);
    await _loadHistory();
  }

  Future<void> _loadHistory() async {
    _history = await _dbService.getEvents();
    notifyListeners();
  }
}
