import 'dart:io';
// import 'package:capsule/pages/add_medicine/add_medicine_page.dart';
import 'package:capsule/components/capsule_colors.dart';
import 'package:capsule/components/capsule_constants.dart';
import 'package:capsule/components/capsule_widgets.dart';
import 'package:capsule/main.dart';
import 'package:capsule/models/medicine.dart';
import 'package:capsule/pages/bottomsheet/time_setting_bottomsheet.dart';
import 'package:capsule/services/add_medicine_service.dart';
import 'package:capsule/services/capsule_file_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import 'components/add_page_widget.dart';

class AddAlarmPage extends StatelessWidget {
  AddAlarmPage(
      {Key? key, required this.medicineImage, required this.medicineName})
      : super(key: key);

  final File? medicineImage;
  final String medicineName;

  final service = AddMedicineService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AddPageBody(
        children: [
          Text(
            '매일 복약 잊지 말아요!',
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(height: largeSpace),
          Expanded(
            child: AnimatedBuilder(
              // ** AnimatedBuilder통해 notifyListeners()가 호출되면, builder를 통해 매번 새로 그려짐
              animation: service,
              builder: (context, _) {
                return ListView(
                  children: alarmWidgets,
                  // children: const [
                  //   AlarmBox(),
                  //   AlarmBox(),
                  //   AddAlarmBoxButton(),
                  // ],
                );
              },
            ),
          ),
        ],
      ),
      // 완료버튼 누를 시
      bottomNavigationBar: BottomSubmitButton(
        onPressed: () async {
          bool result = false;
          // 1. 알람 추가
          for (var alarm in service.alarms) {
            result = await notification.addNotifcication(
              medicineId: medicineRepository.newId,
              alarmTimeStr: alarm,
              title: '$alarm 약 먹을 시간이에요!',
              body: '$medicineName 복약했다고 알려주세요!',
            );
          }

          if (!result) {
            return showPermissionDenied(context, permission: '알람');
          }

          // 2. 이미지 저장 (local dir : 갤러리 저장이 아닌, 앱 내의 하나의 파일로써 저장)
          // null이 아닐때만 dir에 저장
          String? imageFilePath;
          if (medicineImage != null) {
            // null이 아닐땐 이미지가 무조건 있으므로 medicineImage! 느낌표 붙여줌
            imageFilePath = await saveImageToLocalDirectory(medicineImage!);
          }

          // 3. medicine model 추가 (hive를 사용해서, 사진, 약이름, 알람 리스트들을 모델 객체화 해서 local DB에 저장)
          final medicine = Medicine(
            id: medicineRepository.newId,
            name: medicineName,
            imagePath: imageFilePath,
            alarms: service.alarms.toList(),
          );
          medicineRepository.addMedicine(medicine);

          // Navigator.pop(context);
          // 창을 다 끄고 초기화면 홈으로 이동
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        text: '완료',
      ),
    );
  }

  List<Widget> get alarmWidgets {
    final children = <Widget>[];
    children.addAll(
      service.alarms.map(
        (alarmTime) => AlarmBox(
          time: alarmTime,
          service: service,
        ),
      ),
    ); // map은 새 list반환, alarms에 영향이 안감

    /// 복용시간 추가 버튼 누를 시 실행
    children.add(AddAlarmBoxButton(service: service));
    return children;
  }
}

class AlarmBox extends StatelessWidget {
  const AlarmBox({
    Key? key,
    required this.time,
    required this.service,
  }) : super(key: key);

  final String time;

  // final VoidCallback? onPressedMinus;
  final AddMedicineService service;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: IconButton(
            // 마이너스 함수 처리하는것을 여기 안에서 처리하지 않고, 밖 AddAlarmPage에서 처리하게끔 설정
            onPressed: () {
              service.removeAlarm(time);
            },
            icon: const Icon(CupertinoIcons.minus_circle),
          ),
        ),
        Expanded(
          flex: 5,
          child: TextButton(
            style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.subtitle2),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return TimeSettingBottomSheet(
                    initialTime: time,
                  );
                },
              ).then((value) {
                if (value == null || value is! DateTime) return;
                service.setAlarm(
                  prevTime: time,
                  setTime: value,
                  // _setDateTime이 있으면 넣어주고, 없으면 기존값
                );
              });
            },
            child: Text(time),
          ),
        ),
      ],
    );
  }
}

// ↓이거 쓴거는 : StatelessWidget가 상태값을 갖지 않고 변경하지 않는다고 선언했는데, _setDateTime 이 값이 final이 아니라 내부에서 계속 변경될 수 있는 아이라서 처리
// ignore: must_be_immutable

class AddAlarmBoxButton extends StatelessWidget {
  const AddAlarmBoxButton({
    Key? key,
    required this.service,
  }) : super(key: key);

  // final VoidCallback? onPressedAdd;
  final AddMedicineService service;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
          textStyle: Theme.of(context).textTheme.subtitle1),
      onPressed: service.addNowAlarm,
      child: Row(
        children: const [
          Expanded(
            flex: 1,
            child: Icon(
              CupertinoIcons.plus_circle_fill,
            ),
          ),
          Expanded(
            flex: 5,
            child: Center(child: Text('복용시간 추가')),
          ),
        ],
      ),
    );
  }
}
