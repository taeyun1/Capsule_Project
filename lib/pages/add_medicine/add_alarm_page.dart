import 'dart:io';
// import 'package:capsule/pages/add_medicine/add_medicine_page.dart';
import 'package:capsule/components/capsule_colors.dart';
import 'package:capsule/components/capsule_constants.dart';
import 'package:capsule/components/capsule_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'components/add_page_widget.dart';

class AddAlarmPage extends StatefulWidget {
  const AddAlarmPage(
      {Key? key, required this.medicineImage, required this.medicineName})
      : super(key: key);

  final File? medicineImage;
  final String medicineName;

  @override
  State<AddAlarmPage> createState() => _AddAlarmPageState();
}

class _AddAlarmPageState extends State<AddAlarmPage> {
  final _alarms = <String>{
    '08:00',
    '13:00',
    '19:00',
  };

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
            child: ListView(
              children: alarmWidgets,
              // children: const [
              //   AlarmBox(),
              //   AlarmBox(),
              //   AddAlarmBoxButton(),
              // ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomSubmitButton(
        onPressed: () {},
        text: '완료',
      ),
    );
  }

  List<Widget> get alarmWidgets {
    final children = <Widget>[];
    children.addAll(
      _alarms.map((alarmTime) => AlarmBox(
          time: alarmTime,
          onPressedMinus: () {
            setState(() {
              _alarms.remove(alarmTime);
            });
          })),
    ); // map은 새 list반환, alarms에 영향이 안감

    /// 복용시간 추가 버튼 누를 시 실행
    children.add(AddAlarmBoxButton(
      onPressedAdd: () {
        final now = DateTime.now(); // 현재 시간 출력
        final nowTime = DateFormat('HH:mm').format(now); // 18:6 -> 18:06 으로 출력
        setState(() {
          // _alarms.add('${now.hour}:${now.minute}');
          _alarms.add(nowTime);
        });
      },
    ));
    return children;
  }
}

class AlarmBox extends StatelessWidget {
  const AlarmBox({
    Key? key,
    required this.time,
    required this.onPressedMinus,
  }) : super(key: key);

  final String time;

  final VoidCallback? onPressedMinus;

  @override
  Widget build(BuildContext context) {
    // String time값을 갖고있고, 반환되는건 DateTime
    final initTime = DateFormat('HH:mm').parse(time);

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: IconButton(
            // 마이너스 함수 처리하는것을 여기 안에서 처리하지 않고, 밖 AddAlarmPage에서 처리하게끔 설정
            onPressed: onPressedMinus,
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
                  return TimePickerBottomSheet(
                    initialDateTime: initTime,
                  );
                },
              );
            },
            child: Text(time),
          ),
        ),
      ],
    );
  }
}

class TimePickerBottomSheet extends StatelessWidget {
  const TimePickerBottomSheet({
    Key? key,
    required this.initialDateTime,
  }) : super(key: key);

  final DateTime initialDateTime;

  @override
  Widget build(BuildContext context) {
    return BottomSheetBody(
      children: [
        SizedBox(
          height: 200,
          // CupertinoDatePicker는 높이를 지정해줘야함
          child: CupertinoDatePicker(
            onDateTimeChanged: (dateTime) {},
            mode: CupertinoDatePickerMode.time, // 시간만 선택하게 설정
            initialDateTime: initialDateTime, // TimePicker를 누르면, 그 시간으로 포커싱
          ),
        ),
        const SizedBox(height: regulerSpace),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: submitButtonHeight,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.subtitle1,
                    primary: Colors.white,
                    onPrimary: CapsuleColors.primaryColor,
                  ),
                  child: const Text('취소'),
                ),
              ),
            ),
            const SizedBox(width: smallSpace),
            Expanded(
              child: SizedBox(
                height: submitButtonHeight,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.subtitle1,
                  ),
                  child: const Text('선택'),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class AddAlarmBoxButton extends StatelessWidget {
  const AddAlarmBoxButton({
    Key? key,
    required this.onPressedAdd,
  }) : super(key: key);

  final VoidCallback? onPressedAdd;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
          textStyle: Theme.of(context).textTheme.subtitle1),
      onPressed: onPressedAdd,
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
