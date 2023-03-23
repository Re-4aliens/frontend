import 'dart:io';

import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import '../../../models/members.dart';
import '../../components/button.dart';
import 'package:image_picker/image_picker.dart';

class SignUpProfile extends StatefulWidget{
  const SignUpProfile({super.key});

  @override
  State<SignUpProfile> createState() => _SignUpProfileState();
}

class _SignUpProfileState extends State<SignUpProfile>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                    Icon(Icons.account_circle, size : 200):
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: FileImage(_profileImage!.path as File)
                            )
                          ),
                        )

                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                      child:
                      IconButton(
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
                          icon: Icon(Icons.photo_camera, size: 50)),
                  )
                ],
              ),
            ),
            Center(
              child:Text('프로필 사진을 선택하여\n본인을 나타내주세요\n상대방과 더 가까워질 수 있어요!',
                textAlign: TextAlign.center,),
            ),
            Expanded(child: SizedBox()),
            Center(
              child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/school');
                      },
                      child: Text('다음에 변경할래요!',
                              style: TextStyle(decoration: TextDecoration.underline),),),
            ), 
            SizedBox(height: 10),
            Button(
                child: Text('완료'),
                onPressed: (){
                  Navigator.pushNamed(context,'/school', /*arguments: members*/);
                })

          ],
        ),
      ),
    );
  }
}