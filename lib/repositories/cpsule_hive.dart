import 'package:capsule/models/medicine.dart';
import 'package:capsule/models/medicine_history.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CapsuleHive {
  Future<void> initializeHive() async {
    await Hive.initFlutter();

    Hive.registerAdapter<Medicine>(MedicineAdapter());
    Hive.registerAdapter<MedicineHistory>(MedicineHistoryAdapter());

    await Hive.openBox<Medicine>(CapsuleHiveBox.medicine);
    await Hive.openBox<MedicineHistory>(CapsuleHiveBox.medicineHistory);
  }
}

class CapsuleHiveBox {
  static const String medicine = 'medicine';
  static const String medicineHistory = 'medicine_history';
}
