import 'dart:async';
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


class MarketBoardPostPage extends StatefulWidget {

  const MarketBoardPostPage({super.key,required this.screenArguments});
final ScreenArguments screenArguments;


  @override
  State<StatefulWidget> createState() => _MarketBoardPostPageState();
}

class _MarketBoardPostPageState extends State<MarketBoardPostPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _title = '';
  String _price = '';
  String _content = '';
  List<String> whatStatus = [
    '미개봉', '거의 새 것', '약간의 하자', '사용감 있음'
  ];
  String productStatus = '';

  List<Asset> images = [];

  //final ImagePicker imagePicker
  Future<void> pickImages() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultipleImagesPicker.pickImages(
        maxImages: 3,
        enableCamera: true,
        selectedAssets: images,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery
        .of(context)
        .size
        .height;
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
        body: Column(
          children: [
            Container(
                width: double.infinity,
                color: Colors.white.withOpacity(0.09),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                      right: 10.0, left: 10, top: 12, bottom: 12),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
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
                                borderSide: BorderSide(color: Color(
                                    0xffEBEBEB)), // 원하는 색상으로 설정
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
                        ), //제목
                        SizedBox(height: MediaQuery.of(context).size.height * 0.014),
                        TextFormField(
                          keyboardType: TextInputType.numberWithOptions(),
                          style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              color: Color(0xff888888)
                          ),
                          decoration: InputDecoration(
                              prefix: Text(
                                '₩',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                  color: Color(0xff888888),
                                ),
                              ),
                              hintText: '${'market-posting-price'.tr()}',
                              hintStyle: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                  color: Color(0xff888888)
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(
                                    0xffEBEBEB)), // 원하는 색상으로 설정
                              ),
                              contentPadding: EdgeInsets.only(
                                  right: 14, left: 14)
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
                        ), //가격
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
                        SingleChildScrollView(scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (int i = 0; i < 3; i++) ...[
                                if (i < images.length) ...[
                                  GestureDetector(
                                    onTap: pickImages,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: i == 0 ? 14 : 5, right: 5),
                                      child: Container(
                                        width: 130,
                                        height: 130,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: AssetThumbImageProvider(images[i], width: 130, height: 130),
                                            fit: BoxFit.cover,

                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              GestureDetector(
                                onTap: pickImages,
                                child: Padding(
                                  padding: EdgeInsets.only(left: i == 0 ? 14 : 5, right: 5),
                                  child: Container(
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: i == 0
                                        ? Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                            Icon(Icons.add_photo_alternate,
                                      color: Color(0xffAEAEAE),
                                      size: 42,),
                                            Text(
                                              '${images.length}/3',
                                              style: TextStyle(
                                                fontSize: isSmallScreen?12:14,
                                                color: Color(0xffAEAEAE)
                                              ),
                                            )
                                          ],
                                        ): Icon(Icons.add_circle,
                                      color: Color(0xffEBEBEB),
                                      size: 23,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
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
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                            }
                          },
                          child: Text('Submit'),
                        ),
                      ],
                    ),
                  ),
                )
            ),
          ],)
    );
  }
}
