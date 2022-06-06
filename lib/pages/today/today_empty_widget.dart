import 'package:capsule/components/capsule_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodayEmty extends StatelessWidget {
  const TodayEmty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text('추가된 음식이 없습니다.'),
            const SizedBox(height: smallSpace),
            Text(
              '음식을 추가해주세요.',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: smallSpace),
            const Icon(CupertinoIcons.arrow_down),
            const SizedBox(height: largeSpace),
          ],
        ),
      ),
    );
  }
}
