import 'package:hive/hive.dart';

part 'medicine_history.g.dart';

// 2번째 모델이니까 typeId는 2
@HiveType(typeId: 2)
class MedicineHistory extends HiveObject {
  MedicineHistory({
    required this.medicineId,
    required this.alarmTime,
    required this.takeTime,
  });

  @HiveField(0)
  final int medicineId;

  @HiveField(1)
  final String alarmTime;

  @HiveField(2)
  final DateTime takeTime;

  @override
  String toString() {
    return '{medicineId $medicineId, alarmTime: $alarmTime, takeTime: $takeTime}';
  }
}
