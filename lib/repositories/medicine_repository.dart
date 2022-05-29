import 'dart:developer';

import 'package:capsule/repositories/cpsule_hive.dart';
import 'package:hive/hive.dart';

import 'package:capsule/models/medicine.dart';

class MedicineRepository {
  Box<Medicine>? _medicineBox;

  Box<Medicine> get medicineBox {
    // _medicineBox가 null이면 Hive.box<Medicine>(CapsuleHiveBox.medicine);를 수행하여, null값이 안되도록 값을 넣어줌
    _medicineBox ??= Hive.box<Medicine>(CapsuleHiveBox.medicine);
    return _medicineBox!;
  }

  void addMedicine(Medicine medicine) async {
    int key = await medicineBox.add(medicine);

    log('[addMedicine] add (key:$key) $medicine');
    log('result ${medicineBox.values.toList()}');
  }

  void deleteMedicine(int key) async {
    await medicineBox.delete(key);

    log('[deleteMedicineß] delete (key:$key)');
    log('result ${medicineBox.values.toList()}');
  }

  void updateMedicine({
    required int key,
    required Medicine medicine,
  }) async {
    await medicineBox.put(key, medicine);

    log('[updateMedicine] update (key:$key) $medicine');
    log('result ${medicineBox.values.toList()}');
  }

  int get newId {
    // 예외처리 : medicineBox에 result가 값이 빈값이면? 0반환 값이 있으면 lastId값에 + 1 해줌
    final lastId = medicineBox.values.isEmpty ? 0 : medicineBox.values.last.id;
    return lastId + 1;
  }
}
