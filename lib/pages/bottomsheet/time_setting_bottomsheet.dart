import 'package:capsule/components/capsule_colors.dart';
import 'package:capsule/components/capsule_constants.dart';
import 'package:capsule/components/capsule_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeSettingBottomSheet extends StatelessWidget {
  const TimeSettingBottomSheet({
    Key? key,
    required this.initialTime,
    this.submitTitle = '선택', // 값이 없으면 디폴트로 '선택'
    this.bottomWidget,
  }) : super(key: key);

  final String initialTime;
  final Widget? bottomWidget;
  final String submitTitle;

  @override
  Widget build(BuildContext context) {
    // String time값을 갖고있고, 반환되는건 DateTime
    final initialTimeData = DateFormat('HH:mm').parse(initialTime);
    final now = DateTime.now();
    final initialDateTime = DateTime(now.year, now.month, now.day,
        initialTimeData.hour, initialTimeData.minute);
    DateTime setDateTime = initialDateTime;

    return BottomSheetBody(
      children: [
        SizedBox(
          height: 200,
          // CupertinoDatePicker는 높이를 지정해줘야함
          child: CupertinoDatePicker(
            onDateTimeChanged: (dateTime) {
              setDateTime = dateTime;
            },
            mode: CupertinoDatePickerMode.time, // 시간만 선택하게 설정
            initialDateTime: initialDateTime, // TimePicker를 누르면, 그 시간으로 포커싱
          ),
        ),
        const SizedBox(height: smallSpace),
        // bottomWidget이 null이 아니면
        if (bottomWidget != null) bottomWidget!,
        const SizedBox(height: smallSpace),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: submitButtonHeight,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
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
                  onPressed: () =>
                      Navigator.pop(context, setDateTime), // setDateTime을 넘겨줌
                  style: ElevatedButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.subtitle1,
                  ),
                  child: Text(submitTitle),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
