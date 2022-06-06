import 'package:capsule/components/capsule_themes.dart';
import 'package:capsule/pages/home_page.dart';
import 'package:capsule/repositories/cpsule_hive.dart';
import 'package:capsule/repositories/medicine_history_repository.dart';
import 'package:capsule/repositories/medicine_repository.dart';
import 'package:capsule/services/capsule_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

final notification = CapsuleNotificationService();
final hive = CapsuleHive();
final medicineRepository = MedicineRepository();
final historyRepository = MedicineHistoryRepository();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  await notification.initializeTimeZone();
  await notification.initializeNotification();

  await hive.initializeHive(); // 기다리고 다음코드 실행

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
