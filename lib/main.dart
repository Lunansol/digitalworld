import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/services/firebase_options.dart';
import 'src/navigation/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      name: 'Digital World',
      options:
      DefaultFirebaseOptions.currentPlatform, // 이 설정을 사용하여 Firebase 초기화
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
      title: 'Tutorial',
      theme: ThemeData(primarySwatch: Colors.red),
      initialRoute: '/',
      routes: getRoutes(), // getRoutes 함수 사용
    );
  }
}