import 'package:aliens/models/partner_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/views/components/block_dialog_widget.dart';
import 'package:aliens/views/components/report_dialog_widget.dart';
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
              "어떤 서비스를 원하세요?",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                "대화 상대방을 신고 또는 차단하고 싶다면 아래 버튼을 클릭해주세요.",
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
                  "신고하기",
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
                child: Text(
                  "차단하기",
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

