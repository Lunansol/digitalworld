import 'package:flutter/material.dart';
import 'src/navigation/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Firebase 초기화 필요 없음
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
      initialRoute: '/login_page',
      routes: getRoutes(), // getRoutes 함수 사용
    );
  }
}