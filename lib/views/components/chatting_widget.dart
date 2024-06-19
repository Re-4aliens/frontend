import 'package:flutter/material.dart';

Widget chattingWidget(BuildContext context, partners) {
  return Container(
      decoration: const BoxDecoration(
        color: Color(0xffF5F7FF),
      ),
      alignment: Alignment.center,
      child: const Text(
        '매칭이 완료되면 채팅이 활성화됩니다.\n조금만 기다려주세요!',
        style: TextStyle(fontSize: 16, color: Color(0xff616161)),
        textAlign: TextAlign.center,
      ));
}
