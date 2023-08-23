import 'dart:async';
import 'dart:html';
import 'dart:io';
import 'package:chips_choice/chips_choice.dart';
import 'package:aliens/models/chatRoom_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/views/pages/chatting/chatting_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../components/board_drawer_widget.dart';
import 'package:multiple_images_picker/multiple_images_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/button.dart';


class MarketBoardPostPage extends StatefulWidget {

  const MarketBoardPostPage({super.key,required this.screenArguments});
final ScreenArguments screenArguments;


  @override
  State<StatefulWidget> createState() => _MarketBoardPostPageState();
}

class _MarketBoardPostPageState extends State<MarketBoardPostPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;

  String _title = '';
  String _price = '';
  String _content = '';
  List<String> whatStatus = [
    '미개봉', '거의 새 것', '약간의 하자', '사용감 있음'
  ];
  String productStatus = '';

  //List<Asset> images = [];

  final picker = ImagePicker();
  File? _profileImage;
  final picker = ImagePicker();
  List<XFile> _images = [];

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
            showDialog(context: context, builder: (builder){
              return AlertDialog(
                title: Text('이미지 세 개 넘어감'),
              );
            });
          }
        }else{
          showDialog(context: context, builder: (builder){
            return AlertDialog(
              title: Text('이미지 세 개 넘어감'),
            );
          });
        }

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 56,
          leadingWidth: 100,
          leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
                'cancel'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xff888888),
                    fontSize: isSmallScreen ? 16 : 18
                )
            ),),
          title: Text('write'.tr(),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 22 : 24,
              )
          ),
          centerTitle: true,


        ),
        body: SingleChildScrollView(
          child:
            Container(
                width: double.infinity,
                color: Colors.white,
              padding: const EdgeInsets.only(right: 10.0, left: 10, top: 12, bottom: 50),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                    style: TextStyle(
                                        fontSize: isSmallScreen ? 18 : 20,
                                        color: Color(0xff616161)
                                    ),
                                    decoration: InputDecoration(
                                        counterText: '',
                                        hintText: '${'market-posting-title'.tr()}',
                                        hintStyle: TextStyle(
                                            fontSize: isSmallScreen ? 18 : 20,
                                            color: Color(0xff616161)
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.transparent),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.transparent)
                                        ),
                                        contentPadding: EdgeInsets.only(
                                            right: 14, left: 14)
                                    ),
                                    maxLength: 30,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '${'market-posting-title'.tr()}';
                                      }else if (value.length > 30) {
                                        return '${'market-posting-title-error'.tr()}';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _title = value ?? '';
                                    },
                                  ),
                            ),
                            Container(
                              width: 95,
                              height: 35,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Color(0xFFEBEBEB)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                   SizedBox(width: 15),
                                  Icon(Icons.arrow_drop_down,
                                    color: Color(0xff888888),
                                    size: isSmallScreen?18:20,
                                  ),
                                  Text('판매중',
                                    style: TextStyle(
                                      color: Color(0xff888888),
                                      fontSize: isSmallScreen?12:14
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ), //제목
                        Divider(thickness: 1,color:Color(0xffEBEBEB)),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 14),
                              child: Text(
                                '₩',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                  color: Color(0xff888888),
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.numberWithOptions(),
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                  color: Color(0xff888888),
                                ),
                                decoration: InputDecoration(
                                  hintText: '${'market-posting-price'.tr()}',
                                  hintStyle: TextStyle(
                                    fontSize: isSmallScreen ? 14 : 16,
                                    color: Color(0xff888888),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent)
                                  ),
                                  contentPadding: EdgeInsets.only(right: 14, left: 14),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '${'market-posting-price'.tr()}';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _price = value ?? '';
                                },
                              ),
                            ),
                          ],
                        ), //가격
                        Divider(thickness: 1,color:Color(0xffEBEBEB)),

                        SizedBox(height: MediaQuery.of(context).size.height * 0.014),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              child: Text(
                                '상품상태',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                  color: Color(0xff888888),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children:
                                  whatStatus.map((condition) {
                                    final bool isSelected = productStatus ==
                                        condition;
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: ChoiceChip(
                                        label: Text(
                                          condition,
                                          style: TextStyle(
                                            fontSize: isSmallScreen
                                                ? 10
                                                : 12,
                                            color: isSelected
                                                ? Colors.white
                                                : Color(0xffC1C1C1),
                                          ),
                                        ),
                                        selected: isSelected,
                                        backgroundColor: isSelected ? Color(
                                            0xff7898FF) : Colors.white,
                                        selectedColor: Color(0xff7898ff),
                                        onSelected: (isSelected) {
                                          setState(() {
                                            productStatus =
                                            isSelected ? condition : '';
                                          });
                                        },
                                        labelPadding: EdgeInsets.only(
                                            left: 12, right: 12),
                                        // 선택 영역 패딩 조절
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: isSelected ? Color(
                                                0xff7898FF) : Color(
                                                0xffC1C1C1),
                                          ),
                                          borderRadius: BorderRadius.circular(20.0), // 선택 테두리 둥글기 조절
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ), //상품 상태
                        SizedBox(height: MediaQuery.of(context).size.height * 0.014),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (int i = 0; i < images.length + 1; i++)
                                GestureDetector(
                                  onTap: i < images.length ? null : pickImages,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: i == 0 ? 14 : 5,
                                      right: 5,
                                    ),
                                    child: Container(
                                      width: 130,
                                      height: 130,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: i < images.length
                                            ? DecorationImage(
                                          image: FileImage(
                                            File(images[i]!.path),
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                            : null,
                                      ),
                                      child: i == images.length
                                          ? Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_photo_alternate,
                                            color: Color(0xffAEAEAE),
                                            size: 42,
                                          ),
                                          Text(
                                            '${images.length}/3',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xffAEAEAE),
                                            ),
                                          ),
                                        ],
                                      )
                                          : null,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 50),
                        TextFormField(
                          style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 14,
                              color: Color(0xff888888)
                          ),
                          decoration: InputDecoration(
                              hintText: '${'market-posting-content'.tr()}',
                              hintStyle: TextStyle(
                                  fontSize: isSmallScreen ? 12 : 14,
                                  color: Color(0xffC0C0C0)
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.transparent),
                                // 원하는 색상으로 설정
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent)
                              ),
                              errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.transparent)
                              ),
                              contentPadding: EdgeInsets.only(
                                  right: 14, left: 14)
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '${'market-posting-content1'.tr()}';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _content = value ?? '';
                          },
                          maxLines: null,
                        ), //상품 내용
                        SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                        Button(
                          isEnabled: _isButtonEnabled,
                          child: Text(
                              'post3'.tr(), style: TextStyle(color: _isButtonEnabled ? Colors.white : Color(0xff888888))),
                            onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isButtonEnabled = true; // Set to true when validation passes
                              });
                              _formKey.currentState!.save();
                            }
                          })

                      ],
                    ),
                  ),

            ),
          )
    );
  }
}
