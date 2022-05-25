import 'dart:io';

import 'package:capsule/components/capsule_constants.dart';
import 'package:capsule/components/capsule_page_route.dart';
import 'package:capsule/pages/add_medicine/add_alarm_page.dart';
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

  // 다른 위젯에 있는 _pickedImage 꺼내오는법 (안쪽에(자식이) 갖고있는 데이터를 밖으로 전달)
  File? _medicineImage; // (1) 객체 만들고

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
                  // 메서드로 분리
                  // (2) MedicineImageButton 눌러서 타고 들어가 보면
                  child: MedicineImageButton(
                    // (6) changeImageFile는 value에 _pickImage를 전달받아서,
                    changeImageFile: (File? value) {
                      _medicineImage = value;
                      // (7)여기서(AddMedicinePage) 선언한 _medicineImage에 _pickImage를 할당해줌
                    },
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
                  onChanged: (_) {
                    setState(() {});
                  },
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
              onPressed: _nameController.text.isEmpty ? null : _onAddAlarmPage,
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

  void _onAddAlarmPage() {
    Navigator.push(
      context,
      // 페이드 효과로 Page전환
      FadePageRoute(
        page: AddAlarmPage(
          medicineImage: _medicineImage,
          medicineName: _nameController.text,
        ),
      ),
    );
  }
}

// MedicineImageButton 코드가 지저분해 메서드로 분리해둠
class MedicineImageButton extends StatefulWidget {
  const MedicineImageButton({Key? key, required this.changeImageFile})
      : super(key: key);

  // MedicineImageButton 안에 있는 데이터를 가져오려면, ValueChanged가 필요함.
  // ValueChanged<내가 받고싶은 데이터 객체> 넣어주고, changeImageFile 변수 선언;
  final ValueChanged<File?> changeImageFile;

  @override
  State<MedicineImageButton> createState() => _MedicineImageButtonState();
}

class _MedicineImageButtonState extends State<MedicineImageButton> {
  // (4) MedicineImageButton 안에서만 사용되는 _pickedImage값을 밖으로 어떻게 전달하냐
  File? _pickedImage;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 40,
      child: CupertinoButton(
        onPressed: _showBottomSheet, // 메서드로 분리
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
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return PickImageBottomSheet(
          // 처리코드 메서드로 분리
          onPressedCamera: () => _onPressed(ImageSource.camera),
          onPressedGallery: () => _onPressed(ImageSource.gallery),
        );
      },
    );
  }

// _onPressed했을때 어떠한 처리를 할 지, 공통된 부분은 함수로 빼서, ImageSource source로 전달 받게끔 설정
  void _onPressed(ImageSource source) {
    ImagePicker().pickImage(source: source).then((xfile) {
      // 만약 xfile값이 null이 아닐때만, (사진이 있을때만) 다음 코드를 수행.
      if (xfile != null) {
        setState(() {
          _pickedImage = File(xfile.path);

          // (5) 내가 선언한changeImageFile()에 파라미터로 전달해줌
          widget.changeImageFile(_pickedImage);
        });
      }
      // 촬영 후 아니면 촬영 중에 나갈 시 showModal끄기
      Navigator.maybePop(context);
    });
  }
}

class PickImageBottomSheet extends StatelessWidget {
  const PickImageBottomSheet(
      {Key? key, required this.onPressedCamera, required this.onPressedGallery})
      : super(key: key);

  final VoidCallback onPressedCamera;
  final VoidCallback onPressedGallery;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min, // 최소 사이즈로 맞춰줌
          children: [
            TextButton(
              onPressed: onPressedCamera,
              child: const Text('카메라로 촬영'),
            ),
            TextButton(
              onPressed: onPressedGallery,
              child: const Text('앨범에서 가져오기'),
            ),
          ],
        ),
      ),
    );
  }
}
