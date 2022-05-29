import 'package:capsule/components/capsule_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodayPage extends StatelessWidget {
  TodayPage({Key? key}) : super(key: key);

  final list = [
    '약',
    '약 이름 테스트',
    '약 이름',
    '약이름한둘약이름약이름',
    '약이름한둘약이름약이름약이름한둘약이름약이름',
    '약약',
    '약ㅋㅋㅋㅋ',
  ];

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
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: regulerSpace),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return MedicineListTile(
                name: list[index],
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(height: regulerSpace, thickness: 1.0);
              // return const SizedBox(height: regulerSpace);
            },
          ),
        ),
      ],
    );
  }
}

class MedicineListTile extends StatelessWidget {
  const MedicineListTile({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;
    return Container(
      child: Row(
        children: [
          // CupertinoButton은 자체적으로 패딩을 가지고 있음.
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            child: const CircleAvatar(
              radius: 40,
            ),
          ),
          const SizedBox(width: smallSpace),
          const Divider(height: 1, thickness: 1.0), // Divider : 구분선
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🕑 08:30', style: textStyle),
                const SizedBox(height: 6),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('$name,', style: textStyle),
                    TileActionButton(
                      onTap: () {},
                      title: '지금',
                    ),
                    Text('ㅣ', style: textStyle),
                    TileActionButton(
                      onTap: () {},
                      title: '아까',
                    ),
                    Text('먹었어요', style: textStyle),
                  ],
                )
              ],
            ),
          ),
          CupertinoButton(
            onPressed: () {},
            child: const Icon(CupertinoIcons.ellipsis_vertical),
          ),
        ],
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
