import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();

  void scheduleWeeklyNotification() {}
}

class _NotificationPageState extends State<NotificationPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();



  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> scheduleWeeklyNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'weekly_notification_channel',
    'Weekly Notification',
    importance: Importance.max,
    priority: Priority.high,
  );


  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.zonedSchedule(
  0, // Notification ID
  'Room Update Reminder',
  'Don\'t forget to update room occupancy!',
  // _nextInstanceOfMonday(),
  _nextInstanceOfTwoMinutes(),
  androidPlatformChannelSpecifics as NotificationDetails,
  // androidScheduleMode: AndroidAlarmManagerSchedule.alarmManager,
  uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
);

}

//   TZDateTime _nextInstanceOfMonday() {
//   final now = tz.TZDateTime.now(tz.local);
//   final nextMonday = tz.TZDateTime(
//     tz.local,
//     now.year,
//     now.month,
//     now.day,
//     10, // Set the time to 10:00 AM (adjust as needed)
//   );

//   return nextMonday.add(
//     Duration(days: (DateTime.monday - nextMonday.weekday + 7) % 7),
//   );
// }
TZDateTime _nextInstanceOfTwoMinutes() {
  return tz.TZDateTime.now(tz.local).add(const Duration(minutes: 2));
}


  @override
  Widget build(BuildContext context) {
    return Container(); // You can customize this page if needed
  }
}
