import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../main.dart';

class AddMedicineService with ChangeNotifier {
  AddMedicineService(int updateMedicineId) {
    // 업데이트 일 경우에는 즉, 음식 수정버튼을 눌러서 업데이트 할 때
    // _alarms 값이 아닌, 내가 예약 했었던 알림값으로 출력
    final isUpdate = updateMedicineId != -1;
    if (isUpdate) {
      final updateAlarms = medicineRepository.medicineBox.values
          .singleWhere((medicine) => medicine.id == updateMedicineId)
          .alarms;

      _alarms.clear(); // 안에 있는 값들 초기화
      _alarms.addAll(updateAlarms);
    }
  }
  final _alarms = <String>{
    '12:00',
  };

  Set<String> get alarms => _alarms;

  void addNowAlarm() {
    final now = DateTime.now(); // 현재 시간 출력
    final nowTime = DateFormat('HH:mm').format(now); // 18:6 -> 18:06 으로 출력
    // _alarms.add('${now.hour}:${now.minute}');
    _alarms.add(nowTime);

    // setState를 해던것처럼 화면 변화가 일어남
    notifyListeners();
  }

  void removeAlarm(String alarmTime) {
    _alarms.remove(alarmTime);

    notifyListeners();
  }

  // String 이전시간과, DateTime 새로변경될 값 으로 전달받음
  void setAlarm({required String prevTime, required DateTime setTime}) {
    _alarms.remove(prevTime); // 기존 값은 삭제
    final setTimeStr = DateFormat('HH:mm').format(setTime);
    _alarms.add(setTimeStr); // 새로운값 추가

    notifyListeners();
  }
}
