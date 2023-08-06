import 'package:aliens/models/partner_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
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
      return androidReport();
    else
      return androidReport();
  }

  Widget androidReport(){
    return AlertDialog(
      title: Text('사용자를 차단하시겠습니까?', style: TextStyle(
        fontWeight: FontWeight.bold
      ),),
      content: Text('메세지 수신 및 발신이 모두 차단되며, 차단된 상대방과는 재매칭이 불가합니다.',
      style: TextStyle(
        color: Color(0xff888888)
      ),),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('취소', style: TextStyle(color: Color(0xff616161)),)),
        TextButton(onPressed: ()async {

          if(await APIs.blockPartner(widget.partner)){
            Navigator.of(context).pushNamedAndRemoveUntil('/loading', (Route<dynamic> route) => false);
          }
        }, child: Text('차단하기', style: TextStyle(color: Color(0xffFF4646)),)),
      ],
    );
  }
}

