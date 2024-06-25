import 'dart:io';
import 'package:aliens/services/auth_service.dart';
import 'package:aliens/views/components/setting_list_widget.dart';
import 'package:aliens/views/components/setting_profile_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import 'package:aliens/services/user_service.dart';
import '../../models/screen_argument.dart';

class SettingWidget extends StatefulWidget {
  const SettingWidget(
      {super.key, required this.context, required this.screenArguments});

  final ScreenArguments screenArguments;
  final BuildContext context;

  @override
  State<StatefulWidget> createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  File? _profileImage;
  final picker = ImagePicker();

  // 비동기 처리를 통해 이미지 가져오기
  Future getImage(ImageSource imageSource) async {
    try {
      final image = await picker.pickImage(source: imageSource);
      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // 프로필 이미지 URL 디버깅 로그 추가
    final profileImageUrl =
        widget.screenArguments.memberDetails?.profileImage ?? '';
    print('Profile Image URL: $profileImageUrl');

    return Container(
      color: const Color(0xffF5F7FF),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
                padding: const EdgeInsets.only(
                        right: 5, left: 0, top: 17, bottom: 17)
                    .r,
                decoration: BoxDecoration(
                  color: const Color(0xff7898FF),
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
                            text: widget.screenArguments.memberDetails!.name
                                .toString(),
                            style: TextStyle(
                              fontSize: 32.h,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(
                                text: 'setting-nim'.tr(),
                                style: TextStyle(
                                  fontSize: 14.h,
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
                              widget.screenArguments.memberDetails!.birthday
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 14.h, color: Colors.white),
                            ),
                            Text(
                              widget.screenArguments.memberDetails!.email
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 14.h, color: Colors.white),
                            ),
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
                              color: profileImageUrl.isNotEmpty
                                  ? Colors.white
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              image: profileImageUrl.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(profileImageUrl),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: profileImageUrl.isEmpty
                                ? SvgPicture.asset(
                                    'assets/icon/icon_profile.svg',
                                    color: Colors.white,
                                    height: 90.h,
                                    width: 90.w,
                                  )
                                : const SizedBox(),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.038,
                              width: 30.w,
                              child: FloatingActionButton(
                                backgroundColor: const Color(0xffE5EBFF),
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
                                              'setting-takepicture'.tr(),
                                            ),
                                            onPressed: () async {
                                              await getImage(
                                                  ImageSource.camera);
                                              // 로딩 재생
                                              if (_profileImage != null) {
                                                String? imagePath =
                                                    _profileImage?.path;
                                                if (await UserService
                                                    .updateProfile(
                                                        imagePath!)) {
                                                  Navigator.of(context)
                                                      .pushNamedAndRemoveUntil(
                                                          '/loading',
                                                          (Route<dynamic>
                                                                  route) =>
                                                              false);
                                                }
                                              }
                                            },
                                          ),
                                          SimpleDialogOption(
                                            child: Text('setting-gallery'.tr()),
                                            onPressed: () async {
                                              await getImage(
                                                  ImageSource.gallery);
                                              // 로딩 재생
                                              if (_profileImage != null) {
                                                String? imagePath =
                                                    _profileImage?.path;
                                                if (await UserService
                                                    .updateProfile(
                                                        imagePath!)) {
                                                  Navigator.of(context)
                                                      .pushNamedAndRemoveUntil(
                                                          '/loading',
                                                          (Route<dynamic>
                                                                  route) =>
                                                              false);
                                                }
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: SvgPicture.asset(
                                  'assets/icon/icon_modify.svg',
                                  height: MediaQuery.of(context).size.height *
                                      0.019,
                                  width: MediaQuery.of(context).size.width *
                                      0.0415,
                                  color: const Color(0xff7898FF),
                                ),
                              ),
                            ),
                          ),
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
              padding: EdgeInsets.only(top: 17.h, bottom: 17.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Container(
                      padding: const EdgeInsets.only(left: 23),
                      height: MediaQuery.of(context).size.height * 0.03,
                      child: Text(
                        'setting-profile'.tr(),
                        style: TextStyle(
                          color: const Color(0xffC1C1C1),
                          fontSize: 16.h,
                        ),
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                      child: buildProfileList(
                        context,
                        index - 1,
                        widget.screenArguments,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Expanded(
            flex: 5,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.87,
              //margin: EdgeInsets.only(right: 24, left: 24),
              padding: EdgeInsets.only(top: 17.h, bottom: 17.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Container(
                      padding: const EdgeInsets.only(left: 23),
                      height: MediaQuery.of(context).size.height * 0.03,
                      child: Text(
                        'setting-account'.tr(),
                        style: TextStyle(
                          color: const Color(0xffC1C1C1),
                          fontSize: 16.h,
                        ),
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                      child: buildSettingList(
                        context,
                        index - 1,
                        widget.screenArguments,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () async {
                  // http 로그아웃 요청
                  // authProvider.logout(context);

                  final fcmToken = await FirebaseMessaging.instance.getToken();
                  await AuthService.logOut(context);
                },
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1.0,
                        color: Color(0xFF7898FF),
                      ),
                    ),
                  ),
                  child: Text(
                    'setting-logout'.tr(),
                    style: TextStyle(
                      color: const Color(0xFF7898FF),
                      fontSize: 14.h,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
