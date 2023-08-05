import 'dart:convert';
import 'package:aliens/views/components/appbar.dart';
import 'package:aliens/views/pages/matching/matching_edit_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:aliens/apis/apis.dart';
import '../../../apis/apis.dart';
import '../../../mockdatas/mockdata_model.dart';
import '../../../models/screenArgument.dart';

class MatchingInfoPage extends StatefulWidget {
  const MatchingInfoPage({super.key});

  @override
  State<MatchingInfoPage> createState() => _MatchingInfoPageState();
}

class _MatchingInfoPageState extends State<MatchingInfoPage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;

    TextEditingController _bioEditingController = TextEditingController();
    String initialbio = '${args.memberDetails?.selfIntroduction}';
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


    @override
    void initState(){
      super.initState();
      _bioEditingController.text = initialbio;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFF8F8F8),
      //appBar: CustomAppBar(appBar: AppBar(), backgroundColor: Colors.transparent, infookay: false, infocontent: '', title: '${'matching-mine'.tr()}',),
     appBar: AppBar(
       elevation: 0,
       title: Text('${'matching-mine'.tr()}',style: TextStyle(color : Colors.white, fontWeight: FontWeight.w700),),
       backgroundColor: Colors.transparent,
       centerTitle: true,
       leading: IconButton(
         icon: SvgPicture.asset(
           'assets/icon/icon_back.svg',
           color: Colors.white,
           width: 24,
           height: MediaQuery.of(context).size.height * 0.029,),
         onPressed: (){
           Navigator.of(context).pop();
         },
       ),

      ),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Stack(
          children: [
            Positioned(
                top: isSmallScreen?-850:-950,
                left: -100,
                right: -100,
                child: Container(
                    width: isSmallScreen ? 1700: 2000,
                    height: isSmallScreen ? 1700 : 2000,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xff7898FF))
                )),//파란 반원
            Positioned(
                top: MediaQuery.of(context).size.height * 0.16,
                left: 0,
                right: 0,
                child: Container(
                  width: isSmallScreen?130:150,
                  height: isSmallScreen?130:150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    )

            )), //프로필뒤에 하얀원
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                  Expanded(
                    flex: 15,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            offset: Offset(0, 4),
                            color: Colors.black.withOpacity(0.1)
                          )
                        ]
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          color: Colors.white,
                          width: isSmallScreen ? 310 : 350,
                          child:
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(color:
                                  Color(0xff7898FF).withOpacity(0.3)),
                                    //버튼색
                                    BoxShadow(
                                      blurRadius: 10,
                                      color: Colors.white,
                                      offset: const Offset(-5, -5),
                                    ),
                                  ]
                                ),
                                child: Stack(
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(flex: 6, child: Container()),
                                        Positioned(
                                          left: 0,
                                          right: 0,
                                          child: Text(
                                            '${args.applicant?.member?.name}',
                                            //'${args.applicant['member']['name']}      '
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: isSmallScreen ? 34 : 36, color: Colors.black),
                                          ),
                                        ),
                                        Expanded(flex:2, child:Container()),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('${args.memberDetails?.selfIntroduction}',style: TextStyle(color: Color(0xff888888), fontSize: isSmallScreen?14:16),),
                                            Material(
                                              child: Ink(
                                                child: InkWell(
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: const Color(0xff888888),
                                                    size: isSmallScreen?18:20,
                                                  ),
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (_) => Padding(
                                                            padding: const EdgeInsets.only(right: 24, left: 24, top: 10),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    TextButton(
                                                                      onPressed: () {
                                                                        Navigator.pop(context);
                                                                      },
                                                                      child: Text(
                                                                        'cancel'.tr(),
                                                                        style: TextStyle(
                                                                          fontSize: isSmallScreen ? 14 : 16,
                                                                          color: Colors.white,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed: () async {
                                                                        if(await APIs.updateSelfIntroduction(_bioEditingController.text))
                                                                        Navigator.of(context).pushNamedAndRemoveUntil(
                                                                        '/loading', (Route<dynamic> route) => false
                                                                        );
                                                                      },
                                                                      child: Text(
                                                                        'confirm'.tr(),
                                                                        style: TextStyle(
                                                                          fontSize: isSmallScreen ? 14 : 16,
                                                                          color: Colors.white,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                //Expanded(child: Container(), flex: 2,),
                                                                Material(
                                                                  color: Colors.transparent,
                                                                  child : Padding(
                                                                    padding: EdgeInsets.only(
                                                                      top: MediaQuery.of(context).size.height * 0.25,
                                                                      right: MediaQuery.of(context).size.width * 0.1,
                                                                      left: MediaQuery.of(context).size.width * 0.1,
                                                                    ),
                                                                    child: Form(
                                                                      key: _formKey,
                                                                      child: TextFormField(
                                                                        onChanged: (value){
                                                                          initialbio = value;
                                                                        },
                                                                        controller: _bioEditingController,
                                                                        style: TextStyle(color: Colors.white, fontSize: isSmallScreen?14:16),
                                                                        textAlign: TextAlign.center,
                                                                        decoration: InputDecoration(
                                                                          enabledBorder: UnderlineInputBorder(
                                                                            borderSide: BorderSide(color: Colors.white)
                                                                          ),
                                                                          focusedBorder: UnderlineInputBorder(
                                                                            borderSide: BorderSide(color: Colors.white)
                                                                          ),
                                                                          suffixIcon: GestureDetector(
                                                                            child: Icon(
                                                                              Icons.cancel,
                                                                              color: Color(0xffB7B7B7),
                                                                              size: isSmallScreen?21:23,
                                                                            ),
                                                                            onTap: () => _bioEditingController.clear(),
                                                                          )
                                                                        ),

                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),

                                                              ],
                                                            ),
                                                          )

                                                      );
                                                    },
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Expanded(flex: 1, child: Container()),
                                        Container(
                                          margin: EdgeInsets.only(left: 40, right: 40, top: 25),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${'country'.tr()}',
                                                    style: TextStyle(
                                                      fontSize: isSmallScreen ? 12 : 14,
                                                      color: Color(0xff7898FF),
                                                    ),
                                                  ),
                                                  Text(
                                                    '${args.applicant?.member?.nationality}',
                                                    style: TextStyle(
                                                      fontSize: isSmallScreen ? 18 : 20,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${'Age(years)'.tr()}',
                                                    style: TextStyle(
                                                      color: Color(0xff7898FF),
                                                      fontSize: isSmallScreen ? 12 : 14,
                                                    ),
                                                  ),
                                                  Text(' ${args.applicant?.member?.age}',
                                                    style: TextStyle(
                                                      fontSize: isSmallScreen ? 18 : 20,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'MBTI',
                                                    style: TextStyle(
                                                      fontSize: isSmallScreen ? 12 : 14,
                                                      color: Color(0xff7898FF),
                                                    ),
                                                  ),
                                                  Text('${args.applicant?.member?.mbti}',
                                                    style: TextStyle(
                                                      fontSize: isSmallScreen ? 18 : 20,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(flex: 4, child: Container()),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 14,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          //color: Colors.blue.shade300,
                          ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.symmetric(vertical: 25),
                            decoration: BoxDecoration(
                                //color: Colors.blue,
                                ),
                            child: Text(
                              '${'matchinglan'.tr()}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: isSmallScreen ? 14 : 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: Offset(0, 4)),
                                    ]),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Container(
                                    height: 117,
                                    width: isSmallScreen ? 150 : 155,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 25),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Color(0xff7898FF).withOpacity(0.3)),
                                          //버튼색
                                          BoxShadow(
                                            blurRadius: 10,
                                            color: Colors.white,
                                            offset: const Offset(-5, -5),
                                          ),
                                        ]),
                                    child: Stack(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(child: SizedBox()),
                                            Text(
                                              '${'first'.tr()}',
                                              style: TextStyle(
                                                fontSize: isSmallScreen ? 12 : 14,
                                                color: Color(0xff7898ff),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Text('${args.applicant?.preferLanguages?.firstPreferLanguage}',
                                              style: TextStyle(
                                                fontSize:isSmallScreen ? 18 : 20,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff888888),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Positioned(
                                          right: 0,
                                          child: Container(
                                            height:  isSmallScreen ? 34 : 45,
                                            width:  isSmallScreen ? 34 : 45,
                                            child: SvgPicture.asset('assets/character/yellow_puzzle.svg'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: Offset(0, 4)),
                                    ]),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Container(
                                    height: 117,
                                    width: isSmallScreen ? 150 : 155,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 18, horizontal: 25),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Color(0xff7898FF).withOpacity(0.3)),
                                          //버튼색
                                          BoxShadow(
                                            blurRadius: 10,
                                            color: Colors.white,
                                            offset: const Offset(-5, -5),
                                          ),
                                        ]),
                                    child: Stack(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(child: SizedBox()),
                                            Text(
                                              '${'second'.tr()}',
                                              style: TextStyle(
                                                fontSize: isSmallScreen ? 12 : 14,
                                                color: Color(0xff7898ff),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Text('${args.applicant?.preferLanguages?.secondPreferLanguage}',
                                              style: TextStyle(
                                                fontSize: isSmallScreen ? 18 : 20,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff888888),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Positioned(
                                          right: 0,
                                          child: Container(
                                            height: isSmallScreen ? 34 : 45,
                                            width: isSmallScreen ? 34 : 45,
                                            child: SvgPicture.asset('assets/character/blue_puzzle.svg'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 22,
                          ),
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                //color: Colors.blue,
                                ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MatchingEditPage(
                                          screenArguments: args
                                      )
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.only(bottom: 1.0),
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1.0, color: Color(0xFFC4C4C4))),
                                ),
                                child: Text(
                                  '${'setting-lan'.tr()}',
                                  style: TextStyle(
                                    color: Color(0xFF888888),
                                    fontSize: isSmallScreen ? 10 : 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              right: 0,
              left: 0,
              child: Container(
                margin: EdgeInsetsDirectional.symmetric(vertical: 20),
                child:
                args.memberDetails!.profileImage != ""
                    ? Image.network(
                  '${args.memberDetails!.profileImage}',
                  height: isSmallScreen ? 80 : 90,
                  width: isSmallScreen ? 80 : 90,
                )
                    : SvgPicture.asset(
                  'assets/icon/icon_profile.svg',
                  height: isSmallScreen ? 100 : 120,
                  color: Color(0xffEBEBEB),
                ),
              ),
            ),//프로필
            Positioned(
              right: 0,
              top: MediaQuery.of(context).size.height * 0.3,
              left:0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(5),
                  //margin: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    color: Color(0xffEBEBEB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child:
                  Icon(
                    args?.applicant?.member?.gender == 'FEMALE'
                        ? Icons.female
                        : Icons.male,
                    color: Color(0xff7898ff),
                    size: 22,
                  ),
                ),),),//성별
          ],
        ),
      ),
    );
  }
}


