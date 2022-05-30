import 'package:capsule/components/capsule_colors.dart';
import 'package:capsule/components/capsule_constants.dart';
import 'package:capsule/pages/add_medicine/add_medicine_page.dart';
import 'package:capsule/pages/history/history_page.dart';
import 'package:capsule/pages/today/today_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pages = [
    const TodayPage(),
    const HistoryPage(),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: pagePadding,
        child: SafeArea(child: _pages[_currentIndex]),
      ),

      // ======== 플러팅 버튼 설정 ========
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddMedicine,
        child: const Icon(CupertinoIcons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // ======== 하단 NavBar 설정 ========
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  BottomAppBar _buildBottomAppBar() {
    return BottomAppBar(
      // elevation: 0,
      child: Container(
        height: kBottomNavigationBarHeight, // bottom navar의 기본 높이지정
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CupertinoButton(
              onPressed: () => _onCurrentPage(0),
              child: Icon(
                CupertinoIcons.check_mark,
                color: _currentIndex == 0
                    ? CapsuleColors.primaryColor
                    : Colors.grey[400],
              ),
            ),
            CupertinoButton(
              onPressed: () => _onCurrentPage(1),
              child: Icon(
                CupertinoIcons.text_badge_checkmark,
                color: _currentIndex == 1
                    ? CapsuleColors.primaryColor
                    : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 버튼 누를 시 페이지 변경
  void _onCurrentPage(int pageIndex) {
    setState(() {
      _currentIndex = pageIndex;
    });
  }

  // AddPage로 이동
  void _onAddMedicine() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddMedicinePage()),
    );
  }
}
