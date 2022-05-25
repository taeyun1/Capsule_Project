import 'dart:io';

import 'package:capsule/components/capsule_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddMedicinePage extends StatefulWidget {
  const AddMedicinePage({Key? key}) : super(key: key);

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final _nameController = TextEditingController();
  File? _pickedImage;

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
        // SingleChildScrollView : 스크롤이 가능한 영역이 되면, 그 영역만 스크롤 가능
        child: SingleChildScrollView(
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
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SafeArea(
                                child: Padding(
                                  padding: pagePadding,
                                  child: Column(
                                    mainAxisSize:
                                        MainAxisSize.min, // 최소 사이즈로 맞춰줌
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.camera)
                                              .then((xfile) {
                                            // 만약 xfile값이 null이 아닐때만, (사진이 있을때만) 다음 코드를 수행.
                                            if (xfile != null) {
                                              setState(() {
                                                _pickedImage = File(xfile.path);
                                              });
                                            }
                                            // 촬영 후 아니면 촬영 중에 나갈 시 showModal끄기
                                            Navigator.maybePop(context);
                                          });
                                        },
                                        child: const Text('카메라로 촬영'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.gallery)
                                              .then((xfile) {
                                            if (xfile == null) return;
                                            setState(() {
                                              _pickedImage = File(xfile.path);
                                              Navigator.maybePop(
                                                  context); // 사진 선택 후 showModal끄기
                                            });
                                          });
                                        },
                                        child: const Text('앨범에서 가져오기'),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      // 이미지가 없을때는 기본값 패딩을 넣음, // CupertinoButton은 기본값으로 패딩이 있음
                      padding: _pickedImage == null ? null : EdgeInsets.zero,
                      child: _pickedImage == null
                          ? const Icon(
                              CupertinoIcons.photo_camera_solid,
                              // Icons.camera_alt,
                              size: 40,
                              color: Colors.white,
                            )
                          : CircleAvatar(
                              foregroundImage: FileImage(_pickedImage!),
                              radius: 40,
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
                  style:
                      Theme.of(context).textTheme.bodyText1, // 텍스트 입력 시 스타일 설정
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
