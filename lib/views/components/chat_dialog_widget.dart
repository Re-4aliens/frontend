import 'package:aliens/models/partner_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/views/components/block_dialog_widget.dart';
import 'package:aliens/views/components/report_dialog_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';


class ChatDialog extends StatelessWidget{
  final Partner partner;
  final BuildContext context;

  const ChatDialog({
    Key? key,
    required this.partner,
    required this.context
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    if(Platform.isAndroid)
      return androidDialog();
    else
      return iOSDialog();
  }

  Widget androidDialog(){
    return Dialog(
      elevation: 0,
      backgroundColor: Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'chatting-dialog1'.tr(),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                'chatting-dialog2'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.pop(context);
                showDialog(context: context, builder: (context){
                  return ReportDialog(partner: partner, context: context);
                });
              },
              child: Container(
                padding: EdgeInsets.all(13),
                decoration: BoxDecoration(
                    color: Color(0xff7898FF),
                    borderRadius: BorderRadius.circular(5)),
                alignment: Alignment.center,
                child: Text(
                  'chatting-report1'.tr(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: (){
                Navigator.pop(context);
                showDialog(context: context, builder: (context){
                  return BlockDialog(partner: partner, context: context);
                });
              },
              child: Container(
                padding: EdgeInsets.all(13),
                decoration: BoxDecoration(
                    color: Color(0xff7898FF),
                    borderRadius: BorderRadius.circular(5)),
                alignment: Alignment.center,
                child: Text('chatting-block1'.tr(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget iOSDialog(){
    return Container();
  }

}

