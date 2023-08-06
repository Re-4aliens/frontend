import 'dart:io';

import 'package:aliens/views/components/appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../apis/apis.dart';
import '../../../models/members.dart';
import '../../components/button.dart';
import 'package:image_picker/image_picker.dart';

bool _isButtonEnabled = false;

class SignUpProfile extends StatefulWidget {
  const SignUpProfile({super.key});

  @override
  State<SignUpProfile> createState() => _SignUpProfileState();
}

class _SignUpProfileState extends State<SignUpProfile> {
  File? _profileImage;
  final picker = ImagePicker();

  //비동기 처리를 통해 이미지 가져오기
  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);
    setState(() {
      _profileImage = File(image!.path); // 가져온 이미지를 _image에 저장
      _isButtonEnabled = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _isButtonEnabled = false;
  }

  @override
  Widget build(BuildContext context) {
    dynamic member = ModalRoute.of(context)!.settings.arguments;
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: '',
        backgroundColor: Colors.transparent,
        infookay: false,
        infocontent: '',
      ),
      body: Padding(
        padding: EdgeInsets.only(
            right: 24,
            left: 24,
            top: MediaQuery.of(context).size.height * 0.06,
            bottom: MediaQuery.of(context).size.height * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${'signup-pic1'.tr()}\n${'signup-pic2'.tr()}',
              style: TextStyle(
                  fontSize: isSmallScreen ? 22 : 24,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.13),
            Center(
              child: Stack(
                children: [
                  Container(
                      child: _profileImage == null
                          ? Container(
                              child: SvgPicture.asset(
                                'assets/icon/icon_profile.svg',
                                width: isSmallScreen?110:130,
                                height: isSmallScreen?110:130,
                                color: Color(0xffE3E3E3),
                              ),
                            )
                          : Container(
                        width: isSmallScreen?110:130,
                              height: isSmallScreen?110:130,
                              /*width: MediaQuery.of(context).size.width * 0.33,
                              height: MediaQuery.of(context).size.height * 0.16,*/
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.fitHeight,
                                      image: FileImage(_profileImage!))),
                            )),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: FloatingActionButton(
                        mini: true,
                        backgroundColor: Color(0xffFFFFFF),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SimpleDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  children: [
                                    SimpleDialogOption(
                                      child: Text(
                                        '${'signup-pic6'.tr()}',
                                      ),
                                      onPressed: () {
                                        getImage(ImageSource.camera);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    SimpleDialogOption(
                                      child: Text('${'signup-pic7'.tr()}'),
                                      onPressed: () {
                                        getImage(ImageSource.gallery);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(9),
                          child: SvgPicture.asset(
                            'assets/icon/icon_album.svg',
                            width: MediaQuery.of(context).size.width * 0.063,
                            height: MediaQuery.of(context).size.height * 0.027,
                          ),
                        )),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                '${'signup-pic3'.tr()}\n${'signup-pic4'.tr()}\n${'signup-pic5'.tr()}',
                style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    color: Color(0xff626262)),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
                child: Text(
                  '${'signup-picnoti'.tr()}',
                  style: TextStyle(
                      fontSize: isSmallScreen ? 10 : 12,
                      color: Color(0xff626262)),
                  textAlign: TextAlign.center,
                )
            ),
            Expanded(child: SizedBox()),
            SizedBox(height: MediaQuery.of(context).size.height * 0.025),
            Button(
                //수정
                isEnabled: _isButtonEnabled,
                child: Text('done'.tr(), style: TextStyle( color: _isButtonEnabled? Colors.white : Color(0xff888888))),
                onPressed: () {
                  if (_isButtonEnabled) {
                    member.profileImage = _profileImage!.path.toString();
                    print(member.toJson());
                    Navigator.pushNamed(context, '/bio', arguments: member);
                  }
                }),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/bio', arguments: member);
                  member.profileImage = '';
                  print(member.toJson());
                },
                child: Text(
                  'refuse'.tr(),
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: isSmallScreen ? 12 : 14,
                      color: Color(0xff626262)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
