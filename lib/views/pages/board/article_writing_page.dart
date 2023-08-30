import 'dart:async';
import 'dart:io';

import 'package:aliens/mockdatas/board_mockdata.dart';
import 'package:aliens/models/board_model.dart';
import 'package:aliens/models/chatRoom_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/repository/board_repository.dart';
import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/views/pages/chatting/chatting_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../models/countries.dart';
import '../../../permissions.dart';
import '../../components/board_drawer_widget.dart';
import '../../components/button.dart';
import 'article_page.dart';

class ArticleWritingPage extends StatefulWidget {
  const ArticleWritingPage({super.key, required this.screenArguments, required this.category});

  final ScreenArguments screenArguments;
  final String category;

  @override
  State<StatefulWidget> createState() => _ArticleWritingPageState();
}

class _ArticleWritingPageState extends State<ArticleWritingPage> {

  String boardCategory = "post4".tr();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  final GlobalKey<FormState> _formKeyFirst = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeySecond = GlobalKey<FormState>();

  String title = '';
  String content = '';

  bool isEnabled = false;

  File? _profileImage;
  final picker = ImagePicker();
  List<XFile> _images = [];

  //비동기 처리를 통해 이미지 가져오기
  Future getImages(int i) async {
    if(await Permissions.getPhotosPermission()){
      List<XFile> resultList = <XFile>[];
      String error = 'No Error Detected';

      try {
        resultList = await picker.pickMultiImage();
      } on Exception catch (e) {
        error = e.toString();
      }

      if (!mounted) return;

      setState(() {
        if(resultList.length == 0){
          //하나만 선택한 경우
        }else if(resultList.length == 1){
          if(_images.length <= i){
            _images.add(resultList[0]);
          }else{
            _images[i] = resultList[0];
          }
          //두 개 선택한 경우
        }else if(resultList.length == 2){
          if(_images.length <= i && i != 2){
            _images.add(resultList[0]);
            _images.add(resultList[1]);
          }else if(_images.length - i == 1 && i != 2){
            _images[i] = resultList[0];
            _images.add(resultList[1]);
          }else if(_images.length - i >= 2){
            _images[i] = resultList[0];
            _images[i+1] = resultList[1];
          }else{
          }
          //세 개 선택한 경우
        }else if(resultList.length == 3){
          if(_images.length == 0){
            _images = resultList;
          }else if(_images.length == 1 && i == 0){
            _images[0] = resultList[0];
            _images.add(resultList[1]);
            _images.add(resultList[2]);
          }else if(_images.length == 2 && i == 0){
            _images[0] = resultList[0];
            _images[1] = resultList[1];
            _images.add(resultList[2]);
          }else if(_images.length == 3 && i == 0){
            _images[0] = resultList[0];
            _images[1] = resultList[1];
            _images[2] = resultList[2];
          }else{

          }
        }else{

        }

      });
    }
  }


  @override
  void initState() {
    super.initState();
    switch (widget.category){
      case '자유게시판':
        boardCategory = 'free-posting'.tr();
        break;
      case '음식게시판':
        boardCategory = 'food'.tr();
        break;
      case '음악게시판':
        boardCategory = 'music'.tr();
        break;
      case '패션게시판':
        boardCategory = 'fashion'.tr();
        break;
      case '게임게시판':
        boardCategory = 'game'.tr();
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'post'.tr(),
            style: TextStyle(
              fontSize: 20.spMin,
              color: Colors.black,
            ),
          ),
          toolbarHeight: 56,
          shadowColor: Colors.black26,
          backgroundColor: Colors.white,
          leadingWidth: 100,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Center(
              child: Text(
                "cancel".tr(),
                style: TextStyle(
                  color: Color(0xff888888),
                  fontSize: 17.spMin,
                ),
              ),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0).w,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20).r,
                                  ),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                  barrierColor: Colors.black.withOpacity(0.3),
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 480.h,
                                      child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(top: 30, left: 16.0, bottom: 25 ).r,
                                                child: Text("post4".tr(), style: TextStyle(color: Color(0xff121212), fontSize: 18.spMin, fontWeight: FontWeight.bold)),
                                              ),
                                             Expanded(child: Scrollbar(
                                               child: SingleChildScrollView(
                                                 child: Column(
                                                   children: [
                                                     ListTile(
                                                       title: Text("free-posting".tr(), style: TextStyle(color: Color(0xff888888), fontSize: 16.spMin),),
                                                       onTap: (){
                                                         setState(() {
                                                           boardCategory = "free-posting".tr();
                                                         });
                                                         Navigator.pop(context);
                                                       },
                                                     ),
                                                     ListTile(
                                                       title: Text("game".tr(), style: TextStyle(color: Color(0xff888888), fontSize: 16.spMin)),
                                                       onTap: (){
                                                         setState(() {
                                                           boardCategory = "game".tr();
                                                         });
                                                         Navigator.pop(context);
                                                       },
                                                     ),
                                                     ListTile(
                                                       title: Text("fashion".tr(), style: TextStyle(color: Color(0xff888888), fontSize: 16.spMin)),
                                                       onTap: (){
                                                         setState(() {
                                                           boardCategory = "fashion".tr();
                                                         });
                                                         Navigator.pop(context);
                                                       },
                                                     ),
                                                     ListTile(
                                                       title: Text("food".tr(), style: TextStyle(color: Color(0xff888888), fontSize: 16.spMin)),
                                                       onTap: (){
                                                         setState(() {
                                                           boardCategory = "food".tr();
                                                         });
                                                         Navigator.pop(context);
                                                       },
                                                     ),
                                                     ListTile(
                                                       title: Text("music".tr(), style: TextStyle(color: Color(0xff888888), fontSize: 16.spMin)),
                                                       onTap: (){
                                                         setState(() {
                                                           boardCategory = "music".tr();
                                                         });
                                                         Navigator.pop(context);
                                                       },
                                                     ),
                                                     ListTile(
                                                       title: Text("info".tr(), style: TextStyle(color: Color(0xff888888), fontSize: 16.spMin)),
                                                       onTap: (){
                                                         setState(() {
                                                           boardCategory = "info".tr();
                                                         });
                                                         Navigator.pop(context);
                                                       },
                                                     )
                                                   ],
                                                 ),
                                               ),
                                             ))
                                            ],
                                          ),
                                    );
                                  });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 65.h,
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 10.h),
                                    child: Text(boardCategory, style: TextStyle(
                                      color: Color(0xff616161),
                                      fontSize: 16.spMin
                                    ),),
                                  ),
                                ),Padding(
                                  padding: EdgeInsets.only(right: 10.0).w,
                                  child: SvgPicture.asset(
                                    'assets/icon/icon_dropdown.svg',
                                    width: 10.r,
                                    height: 10.r,
                                    color: Color(0xff888888),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 1,
                            color: Color(0xffebebeb),
                          ),
                            Container(
                              height: 65.h,
                              child: Form(
                                key: _formKeyFirst,
                                child: TextFormField(
                                  onChanged: (value){
                                    setState(() {
                                      title = value;
                                    });
                                  },
                                  controller: _titleController,
                                    textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: "post2".tr(),
                                    border: InputBorder.none,
                                    counterText: '',
                                    hintStyle: TextStyle(
                                      color: Color(0xffd9d9d9),
                                      fontSize: 18.spMin,
                                    )
                                  ),
                                  maxLength: 30,
                                ),
                              ),
                              alignment: Alignment.center,
                            ),
                          Divider(
                            thickness: 1,
                            color: Color(0xffebebeb),
                          ),
                          Container(
                            padding: EdgeInsets.all(10).r,
                            height: 150.h,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  children: [
                                    for(int i = 0; i < 3; i++)
                                      InkWell(
                                        onTap: (){
                                          getImages(i);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(right: 20).r,
                                          height: 130.h,
                                          width: 130.h,
                                          decoration: BoxDecoration(
                                              color: Color(0xfff8f8f8),
                                              borderRadius:
                                              BorderRadius.circular(10).r,
                                            image: i < _images.length ? DecorationImage(
                                              image: FileImage(File(_images[i].path)),
                                              fit: BoxFit.cover,
                                            ): null,
                                          ),
                                          alignment: Alignment.center,
                                          child: i < _images.length ? SizedBox() : i == _images.length ? Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset('assets/icon/ICON_photo_1.png', width: 30.r, height: 30.r,),
                                              Text('${_images.length}/3', style: TextStyle(color: Color(0xffaeaeae)),)
                                            ],
                                          ): SvgPicture.asset(
                                            'assets/icon/ICON_photo_2.svg',
                                            width: 25.r,
                                            height: 25.r,
                                          ),
                                        ),
                                      ),


                                  ],
                                  ),
                            ),
                          ),
                          Form(
                            key: _formKeySecond,
                            child: Container(
                              child: TextFormField(
                                onChanged: (value){
                                  setState(() {
                                    content = value;
                                  });
                                },
                                controller: _contentController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    helperStyle: TextStyle(
                                        color: Color(0xffc1c1c1), fontSize: 16.spMin)),
                                maxLines: 10,
                                maxLength: 200, // 글자 길이 제한
                                keyboardType: TextInputType.multiline,
                              ),
                              ),
                          )
                        ],
                      ),
                    ),
                  )),
              Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.all(20).r,
                    child: Button(
                      child: Text('post3'.tr()),
                      onPressed: () {
                        print(boardCategory);
                        if(title != '' && content != '' && boardCategory != 'post4'.tr()){
                          FocusScope.of(context).unfocus();
                          switch (boardCategory){
                            case 'Free Posting Board':
                              boardCategory = '자유게시판';
                              break;
                            case 'Food Board':
                              boardCategory = '음식게시판';
                              break;
                            case 'Music Board':
                              boardCategory = '음악게시판';
                              break;
                            case 'Fashion Board':
                              boardCategory = '패션게시판';
                              break;
                            case 'Game Board':
                              boardCategory = '게임게시판';
                              break;
                            case 'Information Board':
                              boardCategory = '정보게시판';
                              break;
                            default:
                          }

                          //
                          List<String> requestImages = [];

                          for(int i = 0; i < _images.length; i++){
                            requestImages.add(_images[i].path.toString());
                          }

                          Board _newBoard = Board(
                              category: boardCategory,
                              title: title,
                              content: content,
                              images: requestImages,
                          );

                          showDialog(
                              context: context,
                              builder: (_) => FutureBuilder(
                                  future: boardProvider.addPost(_newBoard),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.hasData == false) {
                                      //받아오는 동안
                                      return Container(
                                          child: Image(
                                              image: AssetImage(
                                                  "assets/illustration/loading_01.gif")));
                                    } else if(snapshot.data == true){
                                      //받아온 후
                                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      });
                                      return Container(
                                          child: Image(
                                              image: AssetImage(
                                                  "assets/illustration/loading_01.gif")));
                                    }else {
                                      return AlertDialog(
                                        title: Text('업로드 실패'),
                                      );
                                    }

                                  }));
                        }
                        },
                      isEnabled: title != '' && content != '' && boardCategory != 'post4'.tr(),
                    ),
                  )),
            ],
          ),
        ));
  }

}


