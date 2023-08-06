import 'package:aliens/models/partner_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:web_socket_channel/status.dart';

import '../../apis/apis.dart';



class ReportDialog extends StatefulWidget {
  final Partner partner;
  final BuildContext context;

  const ReportDialog({
    Key? key,
    required this.partner,
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
    ["SEXUAL_HARASSMENT", "성희롱"],
  ["VIOLENCE", "욕설/폭력"],
  ["SPAM", "스팸/광고"],
  ["SCAM", "사기"],
  ["ETC", "기타"]
  ];
  final TextEditingController _textEditingController = TextEditingController(text: ' ');

  String? _reportReason = '성희롱';
  Widget androidReport(){
    return AlertDialog(
      title: Text('신고하기'),
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
                    hintText: '신고 사유를 입력해주세요',
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
        }, child: Text('취소')),
        TextButton(onPressed: ()async {
          var reportCategory;
          for(int i = 0; i < reportList.length; i ++){
            if(reportList[i][1] == _reportReason){
              reportCategory = reportList[i][0];
              break;
            }
          }
          if(await APIs.reportPartner(reportCategory, _textEditingController.text, widget.partner.memberId!)){
            Navigator.pop(context);
            showDialog(context: context, builder: (context){
              return AlertDialog(
                title: Text('신고가 접수되었습니다.', style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),),
              );
            });
          }
        }, child: Text('신고하기')),
      ],
    );
  }
}

