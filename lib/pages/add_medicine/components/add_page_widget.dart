import 'package:flutter/material.dart';

import '../../../components/capsule_constants.dart';

class AddPageBody extends StatelessWidget {
  const AddPageBody({Key? key, required this.children}) : super(key: key);
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      // SingleChildScrollView : 스크롤이 가능한 영역이 되면, 그 영역만 스크롤 가능
      child: Padding(
        padding: pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

class BottomSubmitButton extends StatelessWidget {
  const BottomSubmitButton(
      {Key? key, required this.onPressed, required this.text})
      : super(key: key);

  final VoidCallback? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: submitButtonBoxPadding,
        child: SizedBox(
          height: submitButtonHeight,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              textStyle: Theme.of(context).textTheme.subtitle1,
            ),
            child: Text(text),
          ),
        ),
      ),
    );
  }
}
