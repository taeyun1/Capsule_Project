import 'package:capsule/components/capsule_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddMedicinePage extends StatefulWidget {
  const AddMedicinePage({Key? key}) : super(key: key);

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '어떤 약이에요?',
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(height: largeSpace),
              Center(
                child: CircleAvatar(
                  radius: 40,
                  child: CupertinoButton(
                    onPressed: () {},
                    child: const Icon(
                      CupertinoIcons.photo_camera_solid,
                      // Icons.camera_alt,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: largeSpace + regulerSpace),
              Text(
                '약 이름',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              TextFormField(
                controller: _nameController,
                maxLength: 20,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done, // 작성 후 완료버튼 형태로 생성
                style: Theme.of(context).textTheme.bodyText1, // 텍스트 입력 시 스타일 설정
                decoration: InputDecoration(
                  hintText: '복용할 약 이름을 기입해주세요.',
                  hintStyle: Theme.of(context).textTheme.bodyText2,
                  contentPadding: textFieldContentPadding, // input안에 좌,우 패딩
                ),
              ),
            ],
          ),
        ),
      ),
      // 하단 NavBar
      // SafeArea로 감싸면, IOS가 하단영역을 차지하는게 있으면, 그걸 제외하고 띄어서 그려줌 (IOS는 X이상에만 적용됨)
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: submitButtonBoxPadding,
          child: SizedBox(
            height: submitButtonHeight,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                textStyle: Theme.of(context).textTheme.subtitle1,
              ),
              child: Text('다음'),
            ),
          ),
        ),
      ),
    );
  }
}
