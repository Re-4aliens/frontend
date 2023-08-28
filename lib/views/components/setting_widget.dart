
import 'dart:io';

import 'package:aliens/views/components/setting_list_widget.dart';
import 'package:aliens/views/components/setting_profile_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../apis/apis.dart';
import '../../models/screenArgument.dart';
import '../../permissions.dart';

class SettingWidget extends StatefulWidget{
  SettingWidget({super.key, required this.context, required this.screenArguments});

  final ScreenArguments screenArguments;
  final BuildContext context;

  @override
  State<StatefulWidget> createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget>{

  File? _profileImage;
  final picker = ImagePicker();

  //비동기 처리를 통해 이미지 가져오기
  Future getImage(ImageSource imageSource) async {
    if(imageSource == ImageSource.gallery){
      if(await Permissions.getPhotosPermission()){
        final image = await picker.pickImage(source: imageSource);
        setState(() {
          _profileImage = File(image!.path);
        });
      }
    }
    else{
      final image = await picker.pickImage(source: imageSource);
      setState(() {
        _profileImage = File(image!.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffF5F7FF),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
                padding:
                EdgeInsets.only(right: 5, left: 0, top: 17, bottom: 17).r,
                decoration: BoxDecoration(
                  color: Color(0xff7898FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                width: MediaQuery.of(context).size.width * 0.87,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: widget.screenArguments.memberDetails!.name.toString(),
                            style: TextStyle(
                              fontSize: 32.spMin,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(
                                text: '${'setting-nim'.tr()}',
                                style: TextStyle(
                                  fontSize: 14.spMin,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.screenArguments.memberDetails!.birthday.toString(),
                              style: TextStyle(
                                  fontSize: 14.spMin,
                                  color: Colors.white),
                            ),
                            Text(widget.screenArguments.memberDetails!.email.toString(),
                                style: TextStyle(
                                    fontSize: 14.spMin,
                                    color: Colors.white)),
                          ],
                        )
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Container(
                            height: 90.r,
                            width: 90.r,
                            decoration: BoxDecoration(
                                color: widget.screenArguments.memberDetails!.profileImage != ""
                                    ? Colors.white
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                                image: DecorationImage(

                                    image: widget.screenArguments.memberDetails!.profileImage != ""
                                        ? NetworkImage(widget.screenArguments.memberDetails!.profileImage!) : NetworkImage(''),
                                    fit: BoxFit.cover
                                )
                            ),

                            child: widget.screenArguments.memberDetails!.profileImage! == ""
                                ? SvgPicture.asset(
                              'assets/icon/icon_profile.svg',
                              color:Colors.white,
                              height: 90,
                              width: 90,
                            ) : SizedBox(),
                          ),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height:
                                MediaQuery.of(context).size.height * 0.038,
                                width: 30,
                                child: FloatingActionButton(
                                    backgroundColor: Color(0xffE5EBFF),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SimpleDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(20.0),
                                              ),
                                              children: [
                                                SimpleDialogOption(
                                                  child: Text(
                                                    '${'setting-takepicture'.tr()}',
                                                  ),
                                                  onPressed: () async{
                                                    await getImage(ImageSource.camera);
// 로딩 재생
                                                    if (_profileImage != null && _profileImage?.path != null) {
                                                      String? imagePath = _profileImage?.path!;
                                                      if (await APIs.updateProfile(File(imagePath!))) {
                                                        Navigator.of(context).pushNamedAndRemoveUntil('/loading', (Route<dynamic> route) => false);
                                                      }
                                                    }

                                                  },
                                                ),
                                                SimpleDialogOption(child: Text('${'setting-gallery'.tr()}'),
                                                  onPressed: () async {
                                                    await getImage(ImageSource.gallery);
                                                    print('요청');
                                                    // 로딩 재생
                                                    if (_profileImage != null && _profileImage?.path != null) {

                                                      print('요청시도');
                                                      String? imagePath = _profileImage?.path!;
                                                      if (await APIs.updateProfile(File(imagePath!))) {
                                                        print('성공');
                                                        Navigator.of(context).pushNamedAndRemoveUntil('/loading', (Route<dynamic> route) => false);
                                                      }
                                                    }

                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: SvgPicture.asset(
                                      'assets/icon/icon_modify.svg',
                                      height:
                                      MediaQuery.of(context).size.height *
                                          0.019,
                                      width: MediaQuery.of(context).size.width *
                                          0.0415,
                                      color: Color(0xff7898FF),
                                    )),
                              ))
                        ],
                      ),
                    )
                  ],
                )),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Expanded(
              flex: 5,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.87,
                padding:
                EdgeInsets.only(top: 17, bottom: 17),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Container(
                        padding: EdgeInsets.only(left:23),
                        height: MediaQuery.of(context).size.height * 0.03,
                        child: Text(
                          '${'setting-profile'.tr()}',
                          style: TextStyle(
                            color: Color(0xffC1C1C1),
                            fontSize: 16,
                          ),
                        ),
                      );
                    } else {
                      return Container(
                          height: MediaQuery.of(context).size.height * 0.04,
                          child: buildProfileList(
                              context, index - 1, widget.screenArguments));
                    }
                  },
                ),
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Expanded(
              flex: 5,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.87,
                //margin: EdgeInsets.only(right: 24, left: 24),
                padding:
                EdgeInsets.only(top: 17, bottom: 17),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Container(
                        padding: EdgeInsets.only(left: 23),
                        height: MediaQuery.of(context).size.height * 0.03,
                        child: Text(
                          '${'setting-account'.tr()}',
                          style: TextStyle(
                            color: Color(0xffC1C1C1),
                            fontSize: 16,
                          ),
                        ),
                      );
                    } else {
                      return Container(
                          height: MediaQuery.of(context).size.height * 0.04,
                          child: buildSettingList(
                              context, index - 1, widget.screenArguments));
                    }
                  },
                ),
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Expanded(
              child: Container(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () async {
                    //http 로그아웃 요청
                    //authProvider.logout(context);

                    final fcmToken = await FirebaseMessaging.instance.getToken();
                    await APIs.logOut(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1.0, color: Color(0xFF7898FF))),
                    ),
                    child: Text(
                      '${'setting-logout'.tr()}',
                      style: TextStyle(
                        color: Color(0xFF7898FF),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

}