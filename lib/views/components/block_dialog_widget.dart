import 'package:aliens/models/partner_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web_socket_channel/status.dart';

import '../../apis/apis.dart';



class BlockDialog extends StatefulWidget {
  final Partner partner;
  final BuildContext context;

  const BlockDialog({
    Key? key,
    required this.partner,
    required this.context
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _BlockDialogState();
  }

class _BlockDialogState extends State<BlockDialog>{

  @override
  Widget build(BuildContext context) {
    if(Platform.isAndroid)
      return androidBlock();
    else
      return iosBlock();
  }

  Widget androidBlock(){
    return AlertDialog(
      title: Text('chatting-block2'.tr(), style: TextStyle(
        fontWeight: FontWeight.bold
      ),),
      content: Text('chatting-block3'.tr(),
      style: TextStyle(
        color: Color(0xff888888)
      ),),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('cancel'.tr(), style: TextStyle(color: Color(0xff616161)),)),
        TextButton(onPressed: ()async {

          if(await APIs.blockPartner(widget.partner)){
            Navigator.of(context).pushNamedAndRemoveUntil('/loading', (Route<dynamic> route) => false);
          }
        }, child: Text('chatting-block1'.tr(), style: TextStyle(color: Color(0xffFF4646)),)),
      ],
    );
  }

  Widget iosBlock(){
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
            SizedBox(height: 10,),
            Text('chatting-block2'.tr(), style: TextStyle(
                fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 10,),
            Text('chatting-block3'.tr(),
              style: TextStyle(
                  color: Color(0xff888888)
              ),),
            SizedBox(height: 20,),
            Divider(
              height: 2.w,),
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
                      child: Center(child: Text("chatting-block1".tr())),
                      onTap: () async {
                        if(await APIs.blockPartner(widget.partner)){
                          Navigator.of(context).pushNamedAndRemoveUntil('/loading', (Route<dynamic> route) => false);
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
  }
}

