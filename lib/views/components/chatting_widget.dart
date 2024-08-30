import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

Widget chattingWidget(BuildContext context, partners) {
  return Container(
      decoration: const BoxDecoration(
        color: Color(0xffF5F7FF),
      ),
      alignment: Alignment.center,
      child: Text(
        "chatting5".tr(),
        style: const TextStyle(fontSize: 16, color: Color(0xff616161)),
        textAlign: TextAlign.center,
      ));
}
