import 'dart:io';

import 'package:capsule/components/capsule_constants.dart';
import 'package:capsule/components/capsule_page_route.dart';
import 'package:capsule/main.dart';
import 'package:capsule/models/medicine_alarm.dart';
import 'package:capsule/models/medicine_history.dart';
import 'package:capsule/pages/bottomsheet/time_setting_bottomsheet.dart';
import 'package:capsule/pages/today/today_empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/medicine.dart';
import 'today_take_title.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '오늘 먹을 예정',
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(height: regulerSpace),
        Expanded(
          // ListView.separated는 아이템 사이에 구분할때 어떤한 위젯을 그려줄지 사용
          child: ValueListenableBuilder(
            valueListenable: medicineRepository.medicineBox.listenable(),
            builder: _builderMedicineListView,
          ),
        ),
      ],
    );
  }

  Widget _builderMedicineListView(context, Box<Medicine> box, _) {
    final medicines = box.values.toList();
    final medicineAlarms = <MedicineAlarm>[]; // View를 위해 만들어진 모델

    if (medicines.isEmpty) {
      return const TodayEmty();
    }

    for (var medicine in medicines) {
      for (var alarm in medicine.alarms) {
        medicineAlarms.add(
          MedicineAlarm(
            medicine.id,
            medicine.name,
            medicine.imagePath,
            alarm,
            medicine.key,
          ),
        );
      }
    }

    return Column(
      children: [
        const Divider(height: 1, thickness: 1.0),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: regulerSpace),
            itemCount: medicineAlarms.length,
            itemBuilder: (context, index) {
              return _buildListTile(medicineAlarms[index]);
            },
            separatorBuilder: (context, index) {
              return const Divider(height: regulerSpace, thickness: 1.0);
              // return const SizedBox(height: regulerSpace);
            },
          ),
        ),
        const Divider(height: 1, thickness: 1.0),
      ],
    );
  }

  Widget _buildListTile(MedicineAlarm medicineAlarm) {
    return ValueListenableBuilder(
        valueListenable: historyRepository.historyBox.listenable(),
        builder: (context, Box<MedicineHistory> historyBox, _) {
          if (historyBox.values.isEmpty) {
            return BeforeTakeTile(
              medicineAlarm: medicineAlarm,
            );
          }
          // historyRepository.deleteHistory(19);

          final todayTakeHistory = historyBox.values.singleWhere(
            (history) =>
                // 내가 먹은 이력중에 이 약의 해당하는 id가 있거나
                history.medicineId == medicineAlarm.id &&
                // history.medicineKey값이 medicineAlarm.key값 과 동일 하다면
                history.medicineKey == medicineAlarm.key &&
                // 내가 먹은 이력중에 alarmTime, 이 약 id에 해당하고 이 이시간에 있으면?
                history.alarmTime == medicineAlarm.alarmTime &&
                isToday(history.takeTime, DateTime.now()),
            orElse: () => MedicineHistory(
              // 둘다 없으면 orElse 반환
              medicineId: -1,
              alarmTime: '',
              takeTime: DateTime.now(),
              medicineKey: -1,
            ),
          );

          // 복용안했으면?  BeforeTakeTile 화면 출력
          if (todayTakeHistory.medicineId == -1 &&
              todayTakeHistory.alarmTime == '') {
            return BeforeTakeTile(
              medicineAlarm: medicineAlarm,
            );
          }

          // 복용 했으면?  AfterTakeTile 화면 출력
          return AfterTakeTile(
            medicineAlarm: medicineAlarm,
            history: todayTakeHistory,
          );
        });
  }
}

//  년, 월,일이 같은지 체크
bool isToday(DateTime source, DateTime destination) {
  return source.year == destination.year &&
      source.month == destination.month &&
      source.day == destination.day;
}
