import 'package:flutter_local_notifications/flutter_local_notifications.dart' show AndroidFlutterLocalNotificationsPlugin, AndroidInitializationSettings, AndroidNotificationChannel, AndroidNotificationDetails, FlutterLocalNotificationsPlugin, IOSInitializationSettings, Importance, InitializationSettings, NotificationDetails, UILocalNotificationDateInterpretation;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal() {
    // Initialize plugin for both Android and iOS
    initNotifications();
  }

  void initNotifications() async {
    tz.initializeTimeZones();

    // Declare channel here
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'room_occupancy_reminder', // Channel ID
      'Room Occupancy Reminders', // Channel name
      importance: Importance.high,
    );

    // Use the declared channel variable
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        // iOS: IOSInitializationSettings(),
      ),
    );
  }

  Future<void> scheduleWeeklyNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Update Room Occupancy',
      'Reminder to update room occupancy for the week.',
      _nextInstanceOfWeeklyTime(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'room_occupancy_reminder',
          'Room Occupancy Reminders',
          importance: Importance.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  TZDateTime _nextInstanceOfWeeklyTime() {
    // Adjust this logic to match your desired weekly schedule
    final now = tz.TZDateTime.now(local);
    final scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 12, 54, 0); // 12:54 PM

    if (scheduledDate.isBefore(now)) {
      scheduledDate.add(const Duration(minutes: 2)); // Schedule for next week
    }

    return scheduledDate;
  }
}
