import 'dart:io';

import 'package:capsule/components/capsule_page_route.dart';
import 'package:capsule/models/medicine_alarm.dart';
import 'package:capsule/models/medicine_history.dart';
import 'package:capsule/pages/bottomsheet/more_action_bottomsheet.dart';
import 'package:capsule/pages/bottomsheet/time_setting_bottomsheet.dart';
import 'package:capsule/pages/today/today_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/capsule_constants.dart';
import '../../main.dart';
import 'image_detail_page.dart';

class BeforeTakeTile extends StatelessWidget {
  const BeforeTakeTile({
    Key? key,
    required this.medicineAlarm,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;
    return Row(
      children: [
        // CupertinoButton은 자체적으로 패딩을 가지고 있음.
        MedicineImageButton(
          imagePath: medicineAlarm.imagePath,
        ),
        const SizedBox(width: smallSpace),
        const Divider(height: 1, thickness: 1.0), // Divider : 구분선
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildTileBody(textStyle, context),
          ),
        ),
        _MoreButton(medicineAlarm: medicineAlarm),
      ],
    );
  }

  List<Widget> _buildTileBody(TextStyle? textStyle, BuildContext context) {
    return [
      Text('🕑 ${medicineAlarm.alarmTime}', style: textStyle),
      const SizedBox(height: 6),
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('${medicineAlarm.name}, ', style: textStyle),
          TileActionButton(
            onTap: () {
              historyRepository.addHistory(MedicineHistory(
                medicineId: medicineAlarm.id,
                medicineKey: medicineAlarm.key,
                alarmTime: medicineAlarm.alarmTime,
                takeTime: DateTime.now(),
                imagePath: medicineAlarm.imagePath,
                name: medicineAlarm.name,
              ));
            },
            title: '지금',
          ),
          Text('l', style: textStyle),
          TileActionButton(
            onTap: () => _onPreviousTake(context),
            title: '아까 ',
          ),
          Text('먹었어요!', style: textStyle),
        ],
      )
    ];
  }

  void _onPreviousTake(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => TimeSettingBottomSheet(
        initialTime: medicineAlarm.alarmTime,
      ),
    ).then((takeDateTime) {
      // takeDateTime이 null이거나, DateTime타입이 아닐경우 다음 코드 수행 X
      if (takeDateTime == null || takeDateTime is! DateTime) {
        return;
      }

      historyRepository.addHistory(MedicineHistory(
        medicineId: medicineAlarm.id,
        alarmTime: medicineAlarm.alarmTime,
        takeTime: takeDateTime,
        medicineKey: medicineAlarm.key,
        imagePath: medicineAlarm.imagePath,
        name: medicineAlarm.name,
      ));
    });
  }
}

class AfterTakeTile extends StatelessWidget {
  const AfterTakeTile({
    Key? key,
    required this.medicineAlarm,
    required this.history,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;
  final MedicineHistory history;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;
    return Row(
      children: [
        // CupertinoButton은 자체적으로 패딩을 가지고 있음.
        // Stack은 이미지를 겹겹이 쌓는것.
        // 복욕완료시 체크 표시
        Stack(
          children: [
            MedicineImageButton(
              imagePath: medicineAlarm.imagePath,
            ),
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.green.withOpacity(0.7),
              child: const Icon(
                CupertinoIcons.check_mark,
                color: Colors.white,
              ),
            )
          ],
        ),
        const SizedBox(width: smallSpace),
        const Divider(height: 1, thickness: 1.0), // Divider : 구분선
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildTileBody(textStyle, context),
          ),
        ),
        _MoreButton(medicineAlarm: medicineAlarm),
      ],
    );
  }

  List<Widget> _buildTileBody(TextStyle? textStyle, BuildContext context) {
    return [
      Text.rich(
        TextSpan(
          text: '✔${medicineAlarm.alarmTime} →',
          style: textStyle,
          children: [
            TextSpan(
              text: takeTimeStr,
              style: textStyle?.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      const SizedBox(height: 6),
      Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('${medicineAlarm.name}, ', style: textStyle),
          TileActionButton(
            onTap: () => _onTap(context),
            title: DateFormat('HH시 mm분에 ')
                .format(history.takeTime), // DateTime => String으로 변환
          ),
          Text('먹었어요!', style: textStyle),
        ],
      )
    ];
  }

  String get takeTimeStr => DateFormat('HH:mm').format(history.takeTime);

  void _onTap(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => TimeSettingBottomSheet(
        initialTime: takeTimeStr,
        submitTitle: '수정',
        bottomWidget: TextButton(
          onPressed: () {
            historyRepository.deleteHistory(history.key);
            Navigator.pop(context);
          },
          child: Text(
            '먹은 시간을 지우고 싶어요.',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
      ),
    ).then((takeDateTime) {
      // takeDateTime이 null이거나, DateTime타입이 아닐경우 다음 코드 수행 X
      if (takeDateTime == null || takeDateTime is! DateTime) {
        return;
      }

      // 00시 00분에 버튼 눌렀을때 수정
      historyRepository.updateHistory(
        key: history.key,
        history: MedicineHistory(
          medicineId: medicineAlarm.id,
          alarmTime: medicineAlarm.alarmTime,
          takeTime: takeDateTime,
          medicineKey: medicineAlarm.key,
          imagePath: medicineAlarm.imagePath,
          name: medicineAlarm.name,
        ),
      );
    });
  }
}

class _MoreButton extends StatelessWidget {
  const _MoreButton({
    Key? key,
    required this.medicineAlarm,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        // medicineRepository.deleteMedicine(medicineAlarm.key);
        showModalBottomSheet(
          context: context,
          builder: (context) => MoreActionBottomSheet(
            onPressedModify: () {},
            onPressedDeleteOnlyMedicine: () {
              // 1. 알림 삭제
              notification.deleteMultipleAlarm(alarmIds);
              // 2. hive medicine 데이터 삭제
              medicineRepository.deleteMedicine(medicineAlarm.key);
              // 3. pop
              Navigator.pop(context);
            },
            onPressedDeleteAll: () {
              // 1. 알림 삭제
              notification.deleteMultipleAlarm(alarmIds);
              // 2. hive history 데이터 삭제 ()
              historyRepository.deleteAllHistory(keys);
              // 3. hive medicine 데이터 삭제
              medicineRepository.deleteMedicine(medicineAlarm.key);
              // 3. pop
              Navigator.pop(context);
            },
          ),
        );
      },
      child: const Icon(CupertinoIcons.ellipsis_vertical),
    );
  }

  // alarmIds를 반환할 수 있는 getter 생성
  List<String> get alarmIds {
    final medicine = medicineRepository.medicineBox.values
        .singleWhere((element) => element.id == medicineAlarm.id);
    final alarmIds = medicine.alarms
        .map((alarmStr) => notification.alarmId(medicineAlarm.id, alarmStr))
        .toList();
    return alarmIds;
  }

  Iterable<int> get keys {
    final histories = historyRepository.historyBox.values.where((history) =>
        history.medicineId == medicineAlarm.id &&
        history.medicineKey == medicineAlarm.key);
    final keys = histories.map((e) => e.key as int);
    return keys;
  }
}

class MedicineImageButton extends StatelessWidget {
  const MedicineImageButton({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      // 이미지 누를시 크게보이게, 이미지 없으면 클릭 X
      onPressed: imagePath == null
          ? null
          : () {
              Navigator.push(
                context,
                FadePageRoute(
                  page: ImageDetailPage(imagePath: imagePath!),
                ),
              );
            },
      child: CircleAvatar(
        radius: 40,
        // IOS 14이상부터는 디버그 모드가 유지되고있지않고, 어플리케이션 디렉토리가 영구적이지 않아, 계속 바뀌어 나타나는 이슈(배포하면 imagePath이슈 이상없음)
        foregroundImage: imagePath == null ? null : FileImage(File(imagePath!)),
      ),
    );
  }
}

class TileActionButton extends StatelessWidget {
  const TileActionButton({
    Key? key,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  final VoidCallback onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    final buttonTextStyle = Theme.of(context)
        .textTheme
        .bodyText2
        ?.copyWith(fontWeight: FontWeight.w500);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Text(
          title,
          style: buttonTextStyle,
        ),
      ),
    );
  }
}
