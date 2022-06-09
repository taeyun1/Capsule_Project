import 'package:capsule/components/capsule_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryEmty extends StatelessWidget {
  const HistoryEmty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text('먹은 흔적이 없습니다 . .'),
            const SizedBox(height: smallSpace),
            Text(
              '음식 추가 후 먹었다고 알려주세요!',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: largeSpace),
            const Align(
              alignment: Alignment(-0.6, 0),
              child: Icon(CupertinoIcons.arrow_down),
            ),
            // const Icon(CupertinoIcons.arrow_down),
            const SizedBox(height: regulerSpace),
          ],
        ),
      ),
    );
  }
}
