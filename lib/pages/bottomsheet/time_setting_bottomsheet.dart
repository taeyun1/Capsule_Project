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
  }) : super(key: key);

  final String initialTime;

  @override
  Widget build(BuildContext context) {
    // String time값을 갖고있고, 반환되는건 DateTime
    final initialDateTime = DateFormat('HH:mm').parse(initialTime);
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
        const SizedBox(height: regulerSpace),
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
