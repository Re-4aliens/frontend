import 'dart:async';
import 'dart:io';
import 'package:aliens/apis/apis.dart';
import 'package:aliens/models/market_articles.dart';
import 'package:aliens/permissions.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:aliens/models/chatRoom_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/views/pages/chatting/chatting_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../components/board_drawer_widget.dart';
import 'package:multiple_images_picker/multiple_images_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/button.dart';
import 'market_board_page.dart';


class MarketBoardPostPage extends StatefulWidget {
  const MarketBoardPostPage({super.key,required this.screenArguments, this.marketBoard});
  final ScreenArguments screenArguments;
  final MarketBoard? marketBoard;


  @override
  State<StatefulWidget> createState() => _MarketBoardPostPageState();
}

class _MarketBoardPostPageState extends State<MarketBoardPostPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  bool _isEditMode = false; //수정여부

  TextEditingController _titleController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  List<String> whatStatus = [
    'Brand_New'.tr(), 'Almost_New'.tr(), 'Slight_Defect'.tr(), 'Used'.tr()
  ];
  String productStatus = '';

  final _marketArticleStatusList = ['sale'.tr(), 'sold-out'.tr()];
  String? _marketArticleStatus = 'sale'.tr();


  //List<Asset> images = [];

  final picker = ImagePicker();
  File? _profileImage;
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

  void initState() {
    super.initState();

    // 수정 모드인 경우, 전달된 게시물 데이터 초기화
    if (widget.marketBoard != null) {
      _isEditMode = true;
      _titleController.text = widget.marketBoard!.title!;
      _priceController.text = widget.marketBoard!.price.toString();
      _contentController.text = widget.marketBoard!.content!;
      productStatus = widget.marketBoard!.productStatus!;
      _images = widget.marketBoard!.imageUrls!.map((imageUrl) => XFile(imageUrl)).toList();
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
          leadingWidth: 80.w,
          leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
                'cancel'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xff888888),
                    fontSize: 16.spMin
                )
            ),),
          title: Text('write'.tr(),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18.spMin,
              )
          ),
          centerTitle: true,


        ),
        body: SingleChildScrollView(
          child:
            Container(
                width: double.infinity,
                color: Colors.white,
              padding: EdgeInsets.only(right: 10.w, left: 10.w, top: 12.h, bottom: 50.h),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                    style: TextStyle(
                                        fontSize: 20.spMin,
                                        color: Color(0xff616161)
                                    ),
                                    decoration: InputDecoration(
                                        counterText: '',
                                        hintText: '${'market-posting-title'.tr()}',
                                        hintStyle: TextStyle(
                                            fontSize: 20.h,
                                            color: Color(0xff616161)
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.transparent),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.transparent)
                                        ),
                                        contentPadding: EdgeInsets.only(
                                            right: 14.w, left: 14.w)
                                    ),
                                    maxLength: 30,
                                controller: _titleController,
                                onChanged: (value){
                                      setState(() {
                                        _isButtonEnabled = _isFormValid();
                                      });
                                },
                              ),
                            ),
                            Container(
                              width: 95.w,
                              height: 37.h,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: Color(0xFFEBEBEB)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child:_isEditMode
                                  ?
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [

                                  SvgPicture.asset(
                                    'assets/icon/icon_dropdown.svg',
                                    width: 4.r,
                                    height: 4.r,
                                    color: Color(0xff888888),
                                  ),
                                  DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      icon: const SizedBox.shrink(),
                                      style: TextStyle(
                                        color: Color(0xff888888),
                                        fontSize: 14.spMin,

                                      ),
                                      items: _marketArticleStatusList.map((value) {
                                        return DropdownMenuItem(
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                              fontSize: 14.spMin,
                                              color: Color(0xff888888),
                                            ),
                                          ),
                                          value: value,
                                        );
                                      }).toList(),
                                      value: _marketArticleStatus,
                                      onChanged: (value) {
                                        setState(() {
                                          _marketArticleStatus = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              )
                              :  Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icon/icon_dropdown.svg',
                                      width: 4.r,
                                      height: 4.r,
                                      color: Color(0xff888888),
                                    ),
                                    Text('sale'.tr(),
                                      style: TextStyle(
                                          color: Color(0xff888888),
                                          fontSize:14.spMin
                                      ),
                              ),

                            ])
                            )],
                        ), //제목
                        Divider(thickness: 1.h,color:Color(0xffEBEBEB)),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 14.w),
                              child: SvgPicture.asset(
                                'assets/icon/ICON_won.svg',
                                width: 23.r,
                                height: 23.r,
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.numberWithOptions(),
                                style: TextStyle(
                                  fontSize: 16.spMin,
                                  color: Color(0xff888888),
                                ),
                                decoration: InputDecoration(
                                  hintText: '${'market-posting-price'.tr()}',
                                  hintStyle: TextStyle(
                                    fontSize: 16.h,
                                    color: Color(0xff888888),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent)
                                  ),
                                  contentPadding: EdgeInsets.only(right: 14.w, left: 14.w),
                                ),
                                controller: _priceController,
                                onChanged: (value){
                                  setState(() {
                                    _isButtonEnabled = _isFormValid();
                                  });
                                },
                              ),
                            ),
                          ],
                        ), //가격
                        Divider(thickness: 1,color:Color(0xffEBEBEB)),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14),
                              child: Text(
                                'market-productStatus'.tr(),
                                style: TextStyle(
                                  fontSize:  16.spMin,
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
                                          horizontal: 4.w),
                                      child: ChoiceChip(
                                        label: Text(
                                          condition,
                                          style: TextStyle(
                                            fontSize: 12.spMin,
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
                                            left: 12.w, right: 12.w),
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
                                    )
                                  ),
                                ),


                            ],
                          ),
                        ),
                        SizedBox(height: 45.h),
                        TextFormField(
                          style: TextStyle(
                              fontSize: 14.h,
                              color: Color(0xff888888)
                          ),
                          decoration: InputDecoration(
                              hintText: '${'market-posting-content'.tr()}',
                              hintStyle: TextStyle(
                                  fontSize: 14.spMin,
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
                                  right: 14.w, left: 14.w)
                          ),
                          controller: _contentController,
                          onChanged: (value){
                            setState(() {
                              _isButtonEnabled = _isFormValid();
                            });
                          },
                          maxLines: null,
                        ), //상품 내용
                        SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                        Button(
                          child: Text(
                            'post3'.tr(),
                            style: TextStyle(
                              color: _isButtonEnabled ? Colors.white : Color(0xff888888),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate() && productStatus.isNotEmpty && _images.isNotEmpty ) {
                              FocusScope.of(context).unfocus();
                              _formKey.currentState!.save();

                              MarketBoard marketArticle = MarketBoard(
                                title: _titleController.text,
                                content: _contentController.text,
                                price: int.parse(_priceController.text),
                                productStatus: productStatus,
                                marketArticleStatus: _marketArticleStatus,
                                imageUrls: _images.map((image) => image.path).toList(),
                              );

                              try {
                                if (_isEditMode) {
                                  // 수정 모드인 경우 게시물 업데이트
                                  Map<String, dynamic> updateData = {
                                    'title': _titleController.text,
                                    'content': _contentController.text,
                                    'price': int.parse(_priceController.text),
                                    'productStatus': productStatus,
                                    'marketArticleStatus':_marketArticleStatus,
                                    'imageUrls': _images.map((image) => image.path).toList(),
                                  };

                                  bool success = await APIs.updateMarketArticle(widget.marketBoard!.articleId ?? 0, updateData);
                                  Navigator.of(context).pop(); // 이전 페이지로 이동


                                  if (success) {
                                    print('게시물 수정 성공!!!');
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (BuildContext context) => MarketBoardPage(
                                        screenArguments: widget.screenArguments,
                                        memberDetails:widget.screenArguments.memberDetails!,
                                        marketBoard:widget.marketBoard,
                                      ),
                                    ));
                                  } else {
                                    print('게시물 수정 실패...');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Fail'),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                } else
                                {
                                  // 생성 모드인 경우 게시물 생성
                                  bool success = await APIs.createMarketArticle(marketArticle);
                                  Navigator.of(context).pop(); // 이전 페이지로 이동

                                  if (success) {
                                    print('게시물 생성 성공!!!');
                                    Navigator.of(context).pop(); // 이전 페이지로 이동
                                  } else {
                                    print('게시물 생성 실패...');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Fail'),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                }
                              } catch (error) {
                                print('Error: $error');
                              }
                            }
                          },
                          isEnabled: _isButtonEnabled
                        )


                      ],
                    ),
                  ),

            ),
          )
    );
  }

  bool _isFormValid() {
    return _titleController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _contentController.text.isNotEmpty &&
        productStatus.isNotEmpty &&
        _images.isNotEmpty;
  }
}
