import 'dart:io';

import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../models/members.dart';
import '../../components/button.dart';
import 'package:image_picker/image_picker.dart';

class SignUpProfile extends StatefulWidget{
  const SignUpProfile({super.key});

  @override
  State<SignUpProfile> createState() => _SignUpProfileState();
}

class _SignUpProfileState extends State<SignUpProfile>{

  File? _profileImage;
  final picker = ImagePicker();
  //비동기 처리를 통해 이미지 가져오기
  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);
    setState(() {
      _profileImage = File(image!.path); // 가져온 이미지를 _image에 저장
    });
  }


  Widget build(BuildContext context){
    //Members members = new Members('','','','','','','','');

    return Scaffold(
      appBar: CustomAppBar(appBar: AppBar(), title: '', onPressed: () {},),
      body: Padding(
        padding: EdgeInsets.only(right: 20,left: 20,top: 50,bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('나의 프로필 이미지를\n선택해 주세요',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
            SizedBox(height: 40),
            Center(
              child: Stack(
                children: [
                  Container(
                    child:_profileImage == null?
                        Container(
                          child: SvgPicture.asset(
                              'assets/icon/icon_profile.svg',
                            width: 130,
                            height: 135,
                            color: Color(0xffE3E3E3),
                          ),
                        )
                    /*Icon(Icons.account_circle, size : 200, color: Color(0xffE3E3E3),)*/:
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: FileImage(_profileImage!)
                            )
                          ),
                        )

                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                      child:
                      IconButton(
                        color: Color(0xff808080),
                          onPressed:(){
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
                          } ,
                          icon: SvgPicture.asset(
                            'assets/icon/icon_album.svg',
                            width: 24.57,
                            height: 22.72,
                          )
                      ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10,),
            Center(
              child:Text('프로필 사진을 선택하여\n본인을 나타내주세요\n상대방과 더 가까워질 수 있어요!',
                style: TextStyle(fontSize: 14 ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(child: SizedBox()),
            SizedBox(height: 10),
            Button(
                child: Text('완료'),
                onPressed: (){
                  Navigator.pushNamed(context,'/school', /*arguments: members*/);
                }),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/school');
                },
                child: Text('다음에 변경할래요!',
                  style: TextStyle(decoration: TextDecoration.underline,
                  fontSize: 14,
                  color: Color(0xff626262)),),),
            ),
          ],
        ),
      ),
    );
  }
}