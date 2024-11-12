import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'View/screens/o1_home.dart';
import 'generated/theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppThemes.lightTheme, // Apply custom theme
      home: HomePage (),
      debugShowCheckedModeBanner: false,
    );
  }
}
