import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:aliens/services/apis.dart';
import '../../../models/screen_argument.dart';
import '../../components/button.dart';

class SettingMBTIEditPage extends StatefulWidget {
  const SettingMBTIEditPage({super.key, required this.screenArguments});
  final ScreenArguments? screenArguments;

  @override
  State<SettingMBTIEditPage> createState() => _SettingMBTIEditPageState();
}

class _SettingMBTIEditPageState extends State<SettingMBTIEditPage> {
  final _MBTIlist = [
    'INTJ',
    'INTP',
    'ENTJ',
    'ENTP',
    'INFJ',
    'INFP',
    'ENFJ',
    'ENFP',
    'ISTJ',
    'ISFJ',
    'ESTJ',
    'ESFJ',
    'ISTP',
    'ISFP',
    'ESTP',
    'ESFP'
  ];
  late String _selectedMBTI;
  @override
  void initState() {
    super.initState();
    //_loadInitialMBTI();  // 서버에서 MBTI 정보 호출

    print(widget.screenArguments!.memberDetails!.mbti!);
    _selectedMBTI = widget.screenArguments!.memberDetails!.mbti!;
  }

  @override
  Widget build(BuildContext context) {
    //final screenArguments = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth <= 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
          appBar: AppBar(),
          backgroundColor: Colors.transparent,
          infookay: false,
          infocontent: '',
          title: 'setting-mbti'.tr()),
      body: Container(
        padding: EdgeInsets.only(
            right: 24,
            left: 24,
            top: MediaQuery.of(context).size.height * 0.06,
            bottom: MediaQuery.of(context).size.height * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Container(
              height: MediaQuery.of(context).size.height * 0.14,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MBTI',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: isSmallScreen ? 22 : 24,
                    ),
                  ),
                  SizedBox(
                    width: 110,
                    child: DropdownButton(
                        isExpanded: true,
                        items: _MBTIlist.map((value) {
                          return DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    fontSize: isSmallScreen ? 20 : 22,
                                    fontWeight: FontWeight.bold),
                              ));
                        }).toList(),
                        value: _selectedMBTI,
                        onChanged: (value) {
                          print(value);
                          setState(() {
                            _selectedMBTI = value!;
                          });
                        }),
                  ),
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Button(
                  //수정
                  isEnabled: true,
                  child: Text('confirm'.tr()),
                  onPressed: () async {
                    if (await APIs.updateMBTI(_selectedMBTI)) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/loading', (Route<dynamic> route) => false);
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
