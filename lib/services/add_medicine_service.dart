import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class AddMedicineService with ChangeNotifier {
  final _alarms = <String>{
    '08:00',
    '13:00',
    '19:00',
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
