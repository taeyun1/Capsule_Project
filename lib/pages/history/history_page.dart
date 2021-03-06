import 'package:capsule/components/capsule_constants.dart';
import 'package:capsule/models/medicine.dart';
import 'package:capsule/pages/today/history_empty_widget.dart';
import 'package:capsule/pages/today/today_take_title.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../models/medicine_history.dart';
import '../../models/medicine.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '내가 먹은 흔적들 . .',
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(height: regulerSpace),
        const Divider(height: 1, thickness: 1.0), // 실선
        Expanded(
            child: ValueListenableBuilder(
                valueListenable: historyRepository.historyBox.listenable(),
                builder: _buildListView)),
      ],
    );
  }

  Widget _buildListView(context, Box<MedicineHistory> historyBox, _) {
    final histories =
        historyBox.values.toList().reversed.toList(); // reversed => 역순
    // final histories = [];

    // 히스토리에 기록이 없을 시 빈 페이지 전환
    if (histories.isEmpty) {
      return const HistoryEmty();
    }
    return ListView.builder(
        itemCount: histories.length,
        itemBuilder: (context, index) {
          final history = histories[index];
          return _TimeTile(history: history);
        });
  }
}

class _TimeTile extends StatelessWidget {
  const _TimeTile({
    Key? key,
    required this.history,
  }) : super(key: key);

  final MedicineHistory history;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            DateFormat('yyyy\nMM.dd E', 'ko_KR').format(history.takeTime),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  height: 1.6,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
          ),
        ),
        const SizedBox(width: smallSpace),
        Stack(
          alignment: const Alignment(0.0, -0.3),
          children: const [
            SizedBox(
              height: 130,
              // VerticalDivider : 세로 구분선
              child: VerticalDivider(
                width: 1,
                thickness: 1,
              ),
            ),
            CircleAvatar(
              radius: 4,
              child: CircleAvatar(
                radius: 3,
                backgroundColor: Colors.white,
              ),
            )
          ],
        ),
        Expanded(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // if (medicine.imagePath != null)

              Visibility(
                visible: medicine.imagePath != null, // 이미지가 있으면
                child: MedicineImageButton(imagePath: medicine.imagePath), // 출력
              ),
              const SizedBox(width: smallSpace),
              Text(
                DateFormat('a hh:mm', 'ko_KR').format(history.takeTime) +
                    '\n' +
                    medicine.name,
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      height: 1.6,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Medicine get medicine {
    return medicineRepository.medicineBox.values.singleWhere(
      (element) =>
          element.id == history.medicineId &&
          element.key == history.medicineKey,
      orElse: () => Medicine(
        alarms: [],
        id: -1,
        imagePath: history.imagePath,
        name: history.name, //'삭제된 기록 입니다.',
      ),
    );
  }
}
