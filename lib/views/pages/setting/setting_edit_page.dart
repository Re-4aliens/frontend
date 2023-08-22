import 'dart:convert';
import 'dart:io';
import 'package:aliens/models/members.dart';
import 'package:aliens/providers/member_provider.dart';
import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../permissions.dart';
import '../../../providers/auth_provider.dart';
import '../../components/button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aliens/views/components/appbar.dart';



class SettingEditPage extends StatefulWidget {
  const SettingEditPage({super.key});

  @override
  State<SettingEditPage> createState() => _SettingEditPageState();
}

class _SettingEditPageState extends State<SettingEditPage> {
  @override
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
      if(await Permissions.getCameraPermission()){
        final image = await picker.pickImage(source: imageSource);
        setState(() {
          _profileImage = File(image!.path);
        });
      }
    }
  }

  Widget build(BuildContext context) {
    var memberDetails = ModalRoute.of(context)!.settings.arguments;
    dynamic member = ModalRoute.of(context)!.settings.arguments;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth <= 600;

    final storage = FlutterSecureStorage();
  //  File imageFile = File(memberDetails['profileImage']);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(appBar: AppBar(),backgroundColor: Colors.transparent, title: '프로필 변경하기', infookay: false, infocontent: '',),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40)),
                         child:SvgPicture.asset('assets/icon/icon_profile.svg', color: Color(0xffA8A8A8),),
                         /* child:
                          member.profileImage.existsSync()
                              ? Image.file(member.profileImage)
                              : SvgPicture.asset('assets/icon/icon_profile.svg', color: Color(0xffA8A8A8),),*/
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 30,
                              width: 30,
                              child: FloatingActionButton(
                                  backgroundColor: Colors.white,
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context){
                                          return SimpleDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20.0),
                                            ),
                                            children: [
                                              SimpleDialogOption(
                                                child: Text('사진 찍기',),
                                                onPressed: (){getImage(ImageSource.camera);},
                                              ),
                                              SimpleDialogOption(
                                                child: Text('사진첩에서 가져오기'),
                                                onPressed: (){getImage(ImageSource.gallery);},
                                              ),
                                            ],
                                          );
                                        }
                                    );
                                  },
                                  child: SvgPicture.asset('assets/icon/icon_modify.svg',
                                    width: MediaQuery.of(context).size.width * 0.0615,
                                    height: MediaQuery.of(context).size.height * 0.028,
                                    color: Color(0xff414141),)
                              ),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                ],
              ),
            ),
          ),

          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                //color: Colors.green.shade200
              ),
              child: ListView(
                children: [
                  for(int i = 0; i <4; i++)
                    buildInfoList(i, memberDetails),
                  ],
              ),
            ),
          ),
        ],
      )
    );
  }

  Widget buildInfoList(index, memberDetails) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth <= 600;
    List infoList = [
      'MBTI',
      '성별',
      '국적',
      '언어 재설정',
    ];

    List memberInfo = [
      memberDetails['mbti'].toString(),
      memberDetails['gender'].toString(),
      memberDetails['nationality'].toString(),
    ];

    List navigatorList = [
      '/edit',
      '/edit',
      '/edit',
      '/edit'
    ];

    return ListTile(
      minVerticalPadding: 28,
      onTap: () {
        if(index == 3)
          Navigator.pushNamed(context, navigatorList.elementAt(index));
        /*else if(index == 0)*/

      },
      title: Row(
        children: [
          Text(
            '${infoList.elementAt(index)}',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: isSmallScreen? 14:16,
            ),
          ),
          Expanded(child: Container()),
          if (index == 0)
            Row(
              children: [
                Text(
                  '${memberInfo.elementAt(index)}',
                  style: TextStyle(fontWeight: FontWeight.w700,fontSize: isSmallScreen?14:16, color: Color(0xff717171)),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: SvgPicture.asset('assets/icon/icon_next.svg',
                  width: MediaQuery.of(context).size.width * 0.022,
                  color: Color(0xff4D4D4D),)
                ),
              ],
            )
          else if (0 < index && index < 3)
            Text(
              '${memberInfo.elementAt(index)}',
              style: TextStyle(fontSize: isSmallScreen?14: 16, color: Color(0xff888888)),
            )
          else
            Container(
                margin: EdgeInsets.only(left: 10),
                child: SvgPicture.asset('assets/icon/icon_next.svg',
                  width: MediaQuery.of(context).size.width * 0.022,
                  color: Color(0xff4D4D4D),)
            ),
        ],
      ),
    );
  }

}
