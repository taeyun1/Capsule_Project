import 'package:capsule/components/capsule_constants.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'History',
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(height: smallSpace),
        Text(
          '(준비중)',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }
}
