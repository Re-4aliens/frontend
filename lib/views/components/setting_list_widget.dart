
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../apis/apis.dart';




Widget buildSettingList(context, index, screenArguments) {
  final TextEditingController _textEditingController = TextEditingController();
  List settingList = [
    '${'setting-security'.tr()}',
    '${'setting-noti'.tr()}',
    '${'setting-terms'.tr()}',
    '${'setting-inqury'.tr()}',
  ];

  List settingIcon = [
    Icon(
      Icons.lock_outline,
      size: 20.r,
      color: Colors.black,
    ),
    Icon(
      Icons.notifications_none,
      size: 20.r,
      color: Colors.black,
    ),
    Icon(
      Icons.assignment_outlined,
      size: 20.r,
      color: Colors.black,
    ),

    Icon(
      Icons.contact_support,
      size: 20.r,
      color: Colors.black,
    ),
  ];


  List navigatorList = [
    '/setting/security',
    '/setting/notification',
    '/setting/terms',

  ];

  return ListTile(
    onTap: () {
      if(index == 3){
        showDialog(context: context, builder: (context){
          return Dialog(
            elevation: 0,
            backgroundColor: Color(0xffffffff),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0).w,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20).r,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(padding: EdgeInsets.only(bottom: 20.h, top: 35.h), child: Text("setting-inqury".tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffEBEBEB),
                            borderRadius: BorderRadius.circular(10).r,
                          ),
                          margin: EdgeInsets.only(bottom: 30.h, left: 10.w, right: 10.w),
                          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                          child: TextField(
                            controller: _textEditingController,
                            maxLines: 20,
                            decoration: InputDecoration(
                              hintText: 'setting-inquiry-detail'.tr(),
                              hintStyle: TextStyle(
                                color: Color(0xff888888),
                                fontSize: 14.spMin,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      height: 2.h,
                    ),
                    Container(
                      height: 60.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: InkWell(
                            child: Center(child: Text('cancle'.tr())),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),),
                          VerticalDivider(
                            width: 2.w,
                          ),
                          Expanded(
                            child: InkWell(
                              child: Center(child: Text('setting-inquiry-submit'.tr(), style: TextStyle(
                                color: Color(0xff4B76FF),
                                fontWeight: FontWeight.bold
                              ),)),
                              onTap: () async{
                                if(await APIs.inquiry(_textEditingController.text)){
                                  Navigator.pop(context);
                                  showDialog(context: context, builder: (context){
                                    return AlertDialog(
                                      title: Text('chatting-report8'.tr(), style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    );
                                  });
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
            ),
          );
        });
      }else{
        Navigator.pushNamed(context, navigatorList.elementAt(index), arguments: screenArguments);
      }
    },
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          padding: EdgeInsets.only(left : MediaQuery.of(context).size.width * 0.012, right: MediaQuery.of(context).size.width * 0.04),
          child: settingIcon.elementAt(index),
        ),
        Text(
          '${settingList.elementAt(index)}',
          style: TextStyle(
            fontSize: 18.spMin,
          ),
        ),
        Expanded(child: Container()),
        Icon(
          Icons.arrow_forward_ios,
          size: 18.r,
          color: Color(0xffC1C1C1),
        ),
      ],
    ),
  );
}