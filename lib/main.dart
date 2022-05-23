import 'package:capsule/components/capsule_themes.dart';
import 'package:capsule/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: CapsuleThemes.lightTheme,
      home: const HomePage(),
      // 기기 폰트 사이즈에 의존하지 않고, 내가 받던 그 사이즈 그대로 설정
      builder: (context, child) => MediaQuery(
        child: child!,
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      ),
    );
  }
}
