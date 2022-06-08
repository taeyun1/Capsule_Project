import 'package:capsule/components/capsule_widgets.dart';
import 'package:flutter/material.dart';

class PickImageBottomSheet extends StatelessWidget {
  const PickImageBottomSheet(
      {Key? key, required this.onPressedCamera, required this.onPressedGallery})
      : super(key: key);

  final VoidCallback onPressedCamera;
  final VoidCallback onPressedGallery;

  @override
  Widget build(BuildContext context) {
    // BottomSheetBody : 메서드로 분리
    return BottomSheetBody(
      children: [
        TextButton(
          onPressed: onPressedCamera,
          child: const Text('카메라로 촬영'),
        ),
        TextButton(
          onPressed: onPressedGallery,
          child: const Text('앨범에서 가져오기'),
        ),
      ],
    );
  }
}