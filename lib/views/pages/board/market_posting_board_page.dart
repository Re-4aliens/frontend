import 'dart:async';
import 'dart:io';
import 'package:aliens/services/market_service.dart';
import 'package:aliens/models/market_articles.dart';
import 'package:aliens/util/permissions.dart';
import 'package:aliens/models/screen_argument.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/button.dart';
import 'market_board_page.dart';

class MarketBoardPostPage extends StatefulWidget {
  const MarketBoardPostPage(
      {super.key, required this.screenArguments, this.marketBoard});
  final ScreenArguments screenArguments;
  final MarketBoard? marketBoard;

  @override
  State<StatefulWidget> createState() => _MarketBoardPostPageState();
}

class _MarketBoardPostPageState extends State<MarketBoardPostPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  bool _isEditMode = false; //수정여부

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  List<String> whatStatus = [
    'Brand_New'.tr(),
    'Almost_New'.tr(),
    'Slight_Defect'.tr(),
    'Used'.tr()
  ];
  String productStatus = '';

  final _marketArticleStatusList = ['sale'.tr(), 'sold-out'.tr()];
  String? marketArticleStatus = 'sale'.tr();

  //List<Asset> images = [];

  final picker = ImagePicker();
  File? _profileImage;
  List<XFile> _images = [];

  Future getImages(int i) async {
    if (await Permissions.getPhotosPermission()) {
      List<XFile> resultList = <XFile>[];
      String error = 'No Error Detected';

      try {
        resultList = await picker.pickMultiImage();
      } on Exception catch (e) {
        error = e.toString();
      }

      if (!mounted) return;

      setState(() {
        if (resultList.isEmpty) {
          //하나만 선택한 경우
        } else if (resultList.length == 1) {
          if (_images.length <= i) {
            _images.add(resultList[0]);
          } else {
            _images[i] = resultList[0];
          }
          //두 개 선택한 경우
        } else if (resultList.length == 2) {
          if (_images.length <= i && i != 2) {
            _images.add(resultList[0]);
            _images.add(resultList[1]);
          } else if (_images.length - i == 1 && i != 2) {
            _images[i] = resultList[0];
            _images.add(resultList[1]);
          } else if (_images.length - i >= 2) {
            _images[i] = resultList[0];
            _images[i + 1] = resultList[1];
          } else {}
          //세 개 선택한 경우
        } else if (resultList.length == 3) {
          if (_images.isEmpty) {
            _images = resultList;
          } else if (_images.length == 1 && i == 0) {
            _images[0] = resultList[0];
            _images.add(resultList[1]);
            _images.add(resultList[2]);
          } else if (_images.length == 2 && i == 0) {
            _images[0] = resultList[0];
            _images[1] = resultList[1];
            _images.add(resultList[2]);
          } else if (_images.length == 3 && i == 0) {
            _images[0] = resultList[0];
            _images[1] = resultList[1];
            _images[2] = resultList[2];
          } else {
            showDialog(
                context: context,
                builder: (builder) {
                  return const AlertDialog(
                    title: Text('이미지 세 개 넘어감'),
                  );
                });
          }
        } else {
          showDialog(
              context: context,
              builder: (builder) {
                return const AlertDialog(
                  title: Text('이미지 세 개 넘어감'),
                );
              });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // 수정 모드인 경우, 전달된 게시물 데이터 초기화
    if (widget.marketBoard != null) {
      _isEditMode = true;
      _titleController.text = widget.marketBoard!.title!;
      _priceController.text = widget.marketBoard!.price.toString();
      _contentController.text = widget.marketBoard!.content!;
      productStatus = getProductStatusText(widget.marketBoard!.productStatus!);
      marketArticleStatus =
          getStatusText(widget.marketBoard!.marketArticleStatus!);

      _images = widget.marketBoard!.imageUrls!
          .map((imageUrl) => XFile(imageUrl))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 56,
          leadingWidth: 80.w,
          leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('cancel'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: const Color(0xff888888), fontSize: 16.spMin)),
          ),
          title: Text('write'.tr(),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18.spMin,
              )),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.only(
                right: 10.w, left: 10.w, top: 12.h, bottom: 50.h),
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
                              color: const Color(0xff616161)),
                          decoration: InputDecoration(
                              counterText: '',
                              hintText: 'market-posting-title'.tr(),
                              hintStyle: TextStyle(
                                  fontSize: 20.h,
                                  color: const Color(0xff616161)),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              contentPadding:
                                  EdgeInsets.only(right: 14.w, left: 14.w)),
                          maxLength: 30,
                          controller: _titleController,
                          onChanged: (value) {
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
                            border: Border.all(color: const Color(0xFFEBEBEB)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _isEditMode
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    SvgPicture.asset(
                                      'assets/icon/icon_dropdown.svg',
                                      width: 4.r,
                                      height: 4.r,
                                      color: const Color(0xff888888),
                                    ),
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        icon: const SizedBox.shrink(),
                                        style: TextStyle(
                                          color: const Color(0xff888888),
                                          fontSize: 14.spMin,
                                        ),
                                        items: _marketArticleStatusList
                                            .map((value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                fontSize: 14.spMin,
                                                color: const Color(0xff888888),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        value: marketArticleStatus,
                                        onChanged: (value) {
                                          setState(() {
                                            marketArticleStatus = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                      SvgPicture.asset(
                                        'assets/icon/icon_dropdown.svg',
                                        width: 4.r,
                                        height: 4.r,
                                        color: const Color(0xff888888),
                                      ),
                                      Text(
                                        'sale'.tr(),
                                        style: TextStyle(
                                            color: const Color(0xff888888),
                                            fontSize: 14.spMin),
                                      ),
                                    ]))
                    ],
                  ), //제목
                  Divider(thickness: 1.h, color: const Color(0xffEBEBEB)),
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
                          keyboardType: const TextInputType.numberWithOptions(),
                          style: TextStyle(
                            fontSize: 16.spMin,
                            color: const Color(0xff888888),
                          ),
                          decoration: InputDecoration(
                            hintText: 'market-posting-price'.tr(),
                            hintStyle: TextStyle(
                              fontSize: 16.h,
                              color: const Color(0xff888888),
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            contentPadding:
                                EdgeInsets.only(right: 14.w, left: 14.w),
                          ),
                          controller: _priceController,
                          onChanged: (value) {
                            setState(() {
                              _isButtonEnabled = _isFormValid();
                            });
                          },
                        ),
                      ),
                    ],
                  ), //가격
                  const Divider(thickness: 1, color: Color(0xffEBEBEB)),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          'market-productStatus'.tr(),
                          style: TextStyle(
                            fontSize: 16.spMin,
                            color: const Color(0xff888888),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: whatStatus.map((condition) {
                              final bool isSelected =
                                  productStatus == condition;
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                child: ChoiceChip(
                                  label: Text(
                                    condition,
                                    style: TextStyle(
                                      fontSize: 12.spMin,
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xffC1C1C1),
                                    ),
                                  ),
                                  selected: isSelected,
                                  backgroundColor: isSelected
                                      ? const Color(0xff7898FF)
                                      : Colors.white,
                                  selectedColor: const Color(0xff7898ff),
                                  onSelected: (isSelected) {
                                    setState(() {
                                      productStatus =
                                          isSelected ? condition : '';
                                    });
                                  },
                                  labelPadding:
                                      EdgeInsets.only(left: 12.w, right: 12.w),
                                  // 선택 영역 패딩 조절
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: isSelected
                                          ? const Color(0xff7898FF)
                                          : const Color(0xffC1C1C1),
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        20.0), // 선택 테두리 둥글기 조절
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
                        for (int i = 0; i < 3; i++)
                          InkWell(
                            onTap: () {
                              getImages(i);
                            },
                            child: Container(
                                margin: const EdgeInsets.only(right: 20).r,
                                height: 130.h,
                                width: 130.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xfff8f8f8),
                                  borderRadius: BorderRadius.circular(10).r,
                                  image: i < _images.length
                                      ? DecorationImage(
                                          image:
                                              FileImage(File(_images[i].path)),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: i < _images.length
                                    ? const SizedBox()
                                    : i == _images.length
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/icon/ICON_photo_1.png',
                                                width: 30.r,
                                                height: 30.r,
                                              ),
                                              Text(
                                                '${_images.length}/3',
                                                style: const TextStyle(
                                                    color: Color(0xffaeaeae)),
                                              )
                                            ],
                                          )
                                        : SvgPicture.asset(
                                            'assets/icon/ICON_photo_2.svg',
                                            width: 25.r,
                                            height: 25.r,
                                          )),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 45.h),
                  Container(
                    child: TextFormField(
                      style: TextStyle(
                          fontSize: 14.h, color: const Color(0xff888888)),
                      decoration: InputDecoration(
                          hintText:
                              '${'market-posting-content'.tr()}\n${'posting-noti'.tr()}',
                          hintStyle: TextStyle(
                              fontSize: 14.spMin,
                              color: const Color(0xffC0C0C0)),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            // 원하는 색상으로 설정
                          ),
                          focusedErrorBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          errorBorder: const UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          contentPadding:
                              EdgeInsets.only(right: 14.w, left: 14.w)),
                      controller: _contentController,
                      onChanged: (value) {
                        setState(() {
                          _isButtonEnabled = _isFormValid();
                        });
                      },
                      maxLines: 10,
                    ),
                  ), //상품 내용
                  SizedBox(height: 100.h),
                  Button(
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            productStatus.isNotEmpty &&
                            _images.isNotEmpty) {
                          FocusScope.of(context).unfocus();
                          _formKey.currentState!.save();

                          MarketBoard marketArticle = MarketBoard(
                            title: _titleController.text,
                            content: _contentController.text,
                            price: _priceController.text,
                            productStatus: productStatus,
                            marketArticleStatus: marketArticleStatus,
                            imageUrls:
                                _images.map((image) => image.path).toList(),
                          );

                          try {
                            if (_isEditMode) {
                              MarketBoard updateData = MarketBoard(
                                title: _titleController.text,
                                content: _contentController.text,
                                price: _priceController.text,
                                productStatus: productStatus,
                                marketArticleStatus: marketArticleStatus,
                                imageUrls:
                                    _images.map((image) => image.path).toList(),
                              );
                              print(marketArticleStatus);

                              bool success =
                                  await MarketService.updateMarketArticle(
                                      widget.marketBoard!.articleId ?? 0,
                                      updateData);
                              print('1');
                              print(updateData);
                              Navigator.of(context).pop(); // 이전 페이지로 이동

                              if (success) {
                                print('게시물 수정 성공!!!');
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      MarketBoardPage(
                                          screenArguments:
                                              widget.screenArguments,
                                          marketBoard: widget.marketBoard,
                                          memberDetails: widget
                                              .screenArguments.memberDetails!),
                                ));
                              } else {
                                print('게시물 수정 실패...');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Fail'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                            } else {
                              // 생성 모드인 경우 게시물 생성
                              bool success =
                                  await MarketService.createMarketArticle(
                                      marketArticle);
                              //Navigator.of(context).pop(); // 이전 페이지로 이동

                              if (success) {
                                print('게시물 생성 성공!!!');
                                Future.delayed(
                                    const Duration(milliseconds: 100), () {
                                  Navigator.of(context).pop(); // 이전 페이지로 이동
                                });
                              } else {
                                print('게시물 생성 실패...');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
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
                      isEnabled: _isButtonEnabled,
                      child: Text(
                        'post3'.tr(),
                        style: TextStyle(
                          color: _isButtonEnabled
                              ? Colors.white
                              : const Color(0xff888888),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ));
  }

  bool _isFormValid() {
    return _titleController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _contentController.text.isNotEmpty &&
        productStatus.isNotEmpty &&
        _images.isNotEmpty;
  }
}

String getProductStatusText(String? productStatus) {
  List<String> whatStatus = [
    'Brand_New'.tr(),
    'Almost_New'.tr(),
    'Slight_Defect'.tr(),
    'Used'.tr(),
  ];

  switch (productStatus) {
    case '새 것':
      return whatStatus[0];
    case '거의 새 것':
      return whatStatus[1];
    case '약간의 하자':
      return whatStatus[2];
    case '사용감 있음':
      return whatStatus[3];
    default:
      return '';
  }
}

String getStatusText(String? marketArticleStatus) {
  List<String> Status = [
    'sale'.tr(),
    'sold-out'.tr(),
  ];

  switch (marketArticleStatus) {
    case '판매 중':
      return Status[0];
    case '판매 완료':
      return Status[1];
    default:
      return '';
  }
}
