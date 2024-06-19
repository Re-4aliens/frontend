import 'package:aliens/views/components/appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/button.dart';

class SignUpGender extends StatefulWidget {
  const SignUpGender({super.key});

  @override
  State<SignUpGender> createState() => _SignUpGenderState();
}

class _SignUpGenderState extends State<SignUpGender> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _GenderList = ['male'.tr(), 'female'.tr()];
  String? tempPickedGender = "male".tr();
  var _selectedGender = "";
  bool _isButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    dynamic member = ModalRoute.of(context)!.settings.arguments;
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: '',
        backgroundColor: Colors.white,
        infookay: false,
        infocontent: '',
      ),
      body: Padding(
        padding: EdgeInsets.only(
            right: 24,
            left: 24,
            top: MediaQuery.of(context).size.height * 0.06,
            bottom: MediaQuery.of(context).size.height * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'signup-gender'.tr(),
              style: TextStyle(
                  fontSize: isSmallScreen ? 22 : 24,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Form(
                key: _formKey,
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    _selectGender();
                  },
                  child: Column(children: [
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: 'gender'.tr(),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _selectedGender,
                                style: TextStyle(
                                    fontSize: isSmallScreen ? 16 : 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: SvgPicture.asset(
                                  'assets/icon/icon_dropdown.svg',
                                  width:
                                      MediaQuery.of(context).size.width * 0.037,
                                  height: MediaQuery.of(context).size.height *
                                      0.011,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          hintStyle: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              color: Colors.black)),
                      //validator : (value) => value!.isEmpty? "Please enter some text" : null,
                      enabled: false,
                    )
                  ]),
                )),
            const Expanded(child: SizedBox()),
            Button(
                //수정
                isEnabled: _isButtonEnabled,
                child: Text('confirm'.tr(),
                    style: TextStyle(
                        color: _isButtonEnabled
                            ? Colors.white
                            : const Color(0xff888888))),
                onPressed: () {
                  if (_selectedGender != "") {
                    if (_selectedGender == "female".tr()) {
                      member.gender = 'FEMALE';
                    } else {
                      member.gender = 'MALE';
                    }
                    print(member.toJson());
                    Navigator.pushNamed(context, '/nationality',
                        arguments: member);
                  }
                })
          ],
        ),
      ),
    );
  }

  _selectGender() async {
    String? pickedGender = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return Container(
            child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: Text('cancel'.tr()),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoButton(
                    child: Text('done'.tr()),
                    onPressed: () {
                      Navigator.of(context).pop(tempPickedGender);
                    },
                  ),
                ],
              ),
            ),
            const Divider(
              height: 0,
              thickness: 1,
            ),
            Expanded(
                child: CupertinoPicker(
              magnification: 1.22,
              squeeze: 1.2,
              useMagnifier: true,
              itemExtent: 30,
              onSelectedItemChanged: (int selectedItem) {
                print(selectedItem);
                setState(() {
                  tempPickedGender = _GenderList[selectedItem];
                });
              },
              children: List<Widget>.generate(2, (int index) {
                return Center(child: Text(_GenderList[index]));
              }),
            )),
          ],
        ));
      },
    );
    if (pickedGender != null && pickedGender != _selectedGender) {
      setState(() {
        _selectedGender = pickedGender;
        _isButtonEnabled = true;
      });
    }
  }
}
