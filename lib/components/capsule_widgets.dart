import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'capsule_constants.dart';

class BottomSheetBody extends StatelessWidget {
  const BottomSheetBody({Key? key, required this.children}) : super(key: key);

  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min, // 최소 사이즈로 맞춰줌
          children: children,
        ),
      ),
    );
  }
}

void showPermissionDenied(BuildContext context, {required String permission}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 2),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$permission 권한이 없습니다.'),
          const TextButton(
            onPressed: openAppSettings, // 앱 설청으로 이동
            child: Text('설정창으로 이동'),
          )
        ],
      ),
    ),
  );
}
