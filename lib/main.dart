//main.dart

import 'package:bookmie/Custom_classes/auth_service.dart';
import 'package:bookmie/Custom_classes/notification_uitls.dart';
import 'package:bookmie/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Custom_classes/theme_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService().init(); 
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const String _title = 'Bookmie';

  @override
  Widget build(BuildContext context) {
    NotificationService().initNotifications();
    NotificationService().scheduleWeeklyNotification();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: Provider.of<ThemeProvider>(context).themeData,
      // ThemeData(
      //   fontFamily: GoogleFonts.merriweatherSans().fontFamily,
      color: const MaterialColor(
        0xFFF59B15,
        <int, Color>{
          50: Color(0xFFFFF7F7),
          100: Color(0xFFFFE8E8),
          200: Color(0xFFFFD9D9),
          300: Color(0xFFFFCACA),
          400: Color(0xFFFFB8B8),
          500: Color(0xFFF59B15),
          600: Color(0xFFF49212),
          700: Color(0xFFF38B0F),
          800: Color(0xFFF2840C),
          900: Color(0xFFF17D09),
        },
      ),

      home:const SplashScreen(),
      
    );
  }
}