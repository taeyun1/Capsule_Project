import 'dart:developer';

import 'package:capsule/models/medicine_history.dart';
import 'package:capsule/repositories/cpsule_hive.dart';
import 'package:hive/hive.dart';

import 'package:capsule/models/medicine.dart';

class MedicineHistoryRepository {
  Box<MedicineHistory>? _historyBox;

  Box<MedicineHistory> get historyBox {
    // _medicineBox가 null이면 Hive.box<Medicine>(CapsuleHiveBox.medicine);를 수행하여, null값이 안되도록 값을 넣어줌
    _historyBox ??= Hive.box<MedicineHistory>(CapsuleHiveBox.medicineHistory);
    return _historyBox!;
  }

  void addHistory(MedicineHistory history) async {
    int key = await historyBox.add(history);

    log('[addHistory] add (key:$key) $history');
    log('result ${historyBox.values.toList()}');
  }

  void deleteHistory(int key) async {
    await historyBox.delete(key);

    log('[deleteHistory] delete (key:$key)');
    log('result ${historyBox.values.toList()}');
  }

  void updateHistory({
    required int key,
    required MedicineHistory history,
  }) async {
    await historyBox.put(key, history);

    log('[updateHistory] update (key:$key) $history');
    log('result ${historyBox.values.toList()}');
  }

  void deleteAllHistory(Iterable<int> keys) async {
    await historyBox.deleteAll(keys);

    log('[deleteHistory] delete (key:$keys)');
    log('result ${historyBox.values.toList()}');
  }
}
