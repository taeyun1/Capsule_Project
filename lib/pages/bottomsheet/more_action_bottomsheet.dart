import 'package:capsule/components/capsule_widgets.dart';
import 'package:flutter/material.dart';

class MoreActionBottomSheet extends StatelessWidget {
  const MoreActionBottomSheet({
    Key? key,
    required this.onPressedModify,
    required this.onPressedDeleteOnlyMedicine,
    required this.onPressedDeleteAll,
  }) : super(key: key);

  final VoidCallback onPressedModify;
  final VoidCallback onPressedDeleteOnlyMedicine;
  final VoidCallback onPressedDeleteAll;

  @override
  Widget build(BuildContext context) {
    // BottomSheetBody : 메서드로 분리
    return BottomSheetBody(
      children: [
        TextButton(
          onPressed: onPressedModify,
          child: const Text('음식 정보 수정'),
        ),
        TextButton(
          style: TextButton.styleFrom(primary: Colors.red),
          onPressed: onPressedDeleteOnlyMedicine,
          child: const Text('음식 정보 삭제'),
        ),
        TextButton(
          style: TextButton.styleFrom(primary: Colors.red),
          onPressed: onPressedDeleteAll,
          child: const Text('음식 정보 및 기록 삭제'),
        ),
      ],
    );
  }
}
