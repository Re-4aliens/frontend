import 'package:aliens/models/partner_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:web_socket_channel/status.dart';

import '../../apis/apis.dart';



class ReportDialog extends StatefulWidget {
  final int memberId;
  final BuildContext context;

  const ReportDialog({
    Key? key,
    required this.memberId,
    required this.context
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ReportDialogState();
  }

class _ReportDialogState extends State<ReportDialog>{

  @override
  Widget build(BuildContext context) {
    if(Platform.isAndroid)
      return androidReport();
    else
      return androidReport();
  }

  List<List<String>> reportList = [
    ["SEXUAL_HARASSMENT", 'chatting-report2'.tr()],
  ["VIOLENCE", 'chatting-report3'.tr()],
  ["SPAM", 'chatting-report4'.tr()],
  ["SCAM", 'chatting-report5'.tr()],
  ["ETC", 'chatting-report6'.tr()]
  ];
  final TextEditingController _textEditingController = TextEditingController();

  String? _reportReason = 'chatting-report2'.tr();
  Widget androidReport(){
    return AlertDialog(
      title: Text('chatting-report1'.tr()),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('${reportList[0][1]}'),
              leading: Radio<String>(
                value: reportList[0][1],
                groupValue: _reportReason,
                onChanged: (String? value) {
                  setState(() {
                    _reportReason = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('${reportList[1][1]}'),
              leading: Radio<String>(
                value: reportList[1][1],
                groupValue: _reportReason,
                onChanged: (String? value) {
                  setState(() {
                    _reportReason = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('${reportList[2][1]}'),
              leading: Radio<String>(
                value: reportList[2][1],
                groupValue: _reportReason,
                onChanged: (String? value) {
                  setState(() {
                    _reportReason = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('${reportList[3][1]}'),
              leading: Radio<String>(
                value: reportList[3][1],
                groupValue: _reportReason,
                onChanged: (String? value) {
                  setState(() {
                    _reportReason = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('${reportList[4][1]}'),
              leading: Radio<String>(
                value: reportList[4][1],
                groupValue: _reportReason,
                onChanged: (String? value) {
                  setState(() {
                    _reportReason = value;
                  });
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFD2D2D2), width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextFormField(
                  controller: _textEditingController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'chatting-report7'.tr(),
                    border: InputBorder.none,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('cancel'.tr())),
        TextButton(onPressed: ()async {
          var reportCategory;
          for(int i = 0; i < reportList.length; i ++){
            if(reportList[i][1] == _reportReason){
              reportCategory = reportList[i][0];
              break;
            }
          }
          if(await APIs.reportPartner(reportCategory, _textEditingController.text, widget.memberId)){
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
        }, child: Text('chatting-report1'.tr())),
      ],
    );
  }
}

