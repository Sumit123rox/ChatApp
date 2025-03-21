import 'package:chat_app/config/theme/app_theme.dart';
import 'package:chat_app/data/services/service.locator.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/presentation/screens/auth/login_page.dart';
import 'package:chat_app/router/app_rounter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white, // Background color of the status bar
      statusBarIconBrightness: Brightness.dark, // Dark icons for Android
      statusBarBrightness: Brightness.light, // Light background for iOS
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      navigatorKey: locator<AppRouter>().navigatorKey,
      home: LoginPage(),
    );
  }
}
