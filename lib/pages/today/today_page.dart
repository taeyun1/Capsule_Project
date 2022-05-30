import 'dart:io';

import 'package:capsule/components/capsule_constants.dart';
import 'package:capsule/components/capsule_page_route.dart';
import 'package:capsule/main.dart';
import 'package:capsule/models/medicine_alarm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/medicine.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '오늘 복용할 약은?',
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

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: regulerSpace),
      itemCount: medicineAlarms.length,
      itemBuilder: (context, index) {
        return MedicineListTile(
          medicineAlarm: medicineAlarms[index],
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(height: regulerSpace, thickness: 1.0);
        // return const SizedBox(height: regulerSpace);
      },
    );
  }
}

class MedicineListTile extends StatelessWidget {
  const MedicineListTile({
    Key? key,
    required this.medicineAlarm,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;
    return Container(
      child: Row(
        children: [
          // CupertinoButton은 자체적으로 패딩을 가지고 있음.
          CupertinoButton(
            padding: EdgeInsets.zero,
            // 이미지 누를시 크게보이게, 이미지 없으면 클릭 X
            onPressed: medicineAlarm.imagePath == null
                ? null
                : () {
                    Navigator.push(
                      context,
                      FadePageRoute(
                        page: ImageDetailPage(medicineAlarm: medicineAlarm),
                      ),
                    );
                  },
            child: CircleAvatar(
              radius: 40,
              // IOS 14이상부터는 디버그 모드가 유지되고있지않고, 어플리케이션 디렉토리가 영구적이지 않아, 계속 바뀌어 나타나는 이슈(배포하면 imagePath이슈 이상없음)
              foregroundImage: medicineAlarm.imagePath == null
                  ? null
                  : FileImage(File(medicineAlarm.imagePath!)),
            ),
          ),
          const SizedBox(width: smallSpace),
          const Divider(height: 1, thickness: 1.0), // Divider : 구분선
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🕑 ${medicineAlarm.alarmTime}', style: textStyle),
                const SizedBox(height: 6),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('${medicineAlarm.name}, ', style: textStyle),
                    TileActionButton(
                      onTap: () {},
                      title: '지금',
                    ),
                    Text('l', style: textStyle),
                    TileActionButton(
                      onTap: () {},
                      title: '아까 ',
                    ),
                    Text('먹었어요', style: textStyle),
                  ],
                )
              ],
            ),
          ),
          CupertinoButton(
            onPressed: () {
              medicineRepository.deleteMedicine(medicineAlarm.key);
            },
            child: const Icon(CupertinoIcons.ellipsis_vertical),
          ),
        ],
      ),
    );
  }
}

class ImageDetailPage extends StatelessWidget {
  const ImageDetailPage({
    Key? key,
    required this.medicineAlarm,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
      ),
      body: Center(
        child: Image.file(
          File(medicineAlarm.imagePath!),
        ),
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
