import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/material.dart';

class SettingTermsPrivatePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBar: AppBar(), backgroundColor: Colors.transparent,infookay: false,infocontent: '',title: '개인정보 처리방침',),

    );
  }
}