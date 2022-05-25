import 'package:flutter/material.dart';

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
