import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:typed_data'; 
import 'dart:io';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();
    
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings, 
      iOS: iosSettings
    );

    await _notificationsPlugin.initialize(initSettings);

    if (Platform.isAndroid) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  Future<void> showNotification({
    required String title,
    required String body,
    bool isCritical = false,
  }) async {
    
    final Int64List vibrationPattern = Int64List.fromList([0, 1000, 500, 1000, 500, 1000]);

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      isCritical ? 'critical_channel_v3' : 'normal_channel_v3',
      isCritical ? 'ALERTA DE PÂNICO' : 'Notificações Gerais',
      channelDescription: 'Canal para alertas de emergência',
      
      importance: Importance.max,
      priority: Priority.max,
      
      playSound: true,

      enableVibration: true,
      vibrationPattern: vibrationPattern,

      additionalFlags: Int32List.fromList(<int>[4]), 
      fullScreenIntent: true, 
      category: AndroidNotificationCategory.alarm,
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );

    NotificationDetails details = NotificationDetails(android: androidDetails);

    try {
      await _notificationsPlugin.show(
        999, 
        title,
        body,
        details,
      );
    } catch (e) {
      print("Erro ao disparar notificação: $e");
    }
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}