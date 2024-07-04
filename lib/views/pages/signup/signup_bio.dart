import 'package:aliens/views/components/appbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../components/button.dart';

class SignUpBio extends StatefulWidget {
  const SignUpBio({super.key});

  @override
  State<SignUpBio> createState() => _SignUpBioState();
}

class _SignUpBioState extends State<SignUpBio> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _bioController = TextEditingController();
  bool _isButtonEnabled = false;
  String constraintsText = "";

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;

    dynamic member = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: '',
        backgroundColor: Colors.white,
        infookay: false,
        infocontent: '',
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 24, left: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(child: SizedBox()),
            Text(
              'signup-bio1'.tr(),
              style: TextStyle(
                  fontSize: isSmallScreen ? 22 : 24,
                  fontWeight: FontWeight.bold),
            ),
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  onChanged: (value) {
                    _CheckValidate(value);
                  },
                  //validator : (value) => value!.isEmpty? "Please enter some text" : null,
                  controller: _bioController,
                  decoration: InputDecoration(
                      hintText: 'signup-bio2'.tr(),
                      hintStyle: TextStyle(
                          fontSize: isSmallScreen ? 18 : 20,
                          color: const Color(0xffD9D9D9))),
                ),
              ),
            ),
            Text(constraintsText),
            Text(
              '${'signup-bio3'.tr()}\n${'signup-bio4'.tr()}',
              style: const TextStyle(color: Color(0xff626262)),
            ),
            const Expanded(flex: 8, child: SizedBox()),
            Button(
                isEnabled: _isButtonEnabled,
                child: Text('next'.tr()),
                onPressed: () {
                  if (_isButtonEnabled) {
                    member.aboutMe = _bioController.text;
                    print(member.toJson());
                    Navigator.pushNamed(context, '/email', arguments: member);
                  }
                }),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/email', arguments: member);
                  print(member.toJson());
                },
                child: Text(
                  'refuse'.tr(),
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: isSmallScreen ? 12 : 14,
                      color: const Color(0xff626262)),
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }

  void _CheckValidate(String value) {
    if (value.isEmpty) {
      setState(() {
        _isButtonEnabled = false;
        constraintsText = '';
      });
    } else if (value.length > 15) {
      setState(() {
        _isButtonEnabled = false;
        constraintsText = 'signup-bio5'.tr();
      });
    } else {
      setState(() {
        _isButtonEnabled = true;
        constraintsText = '';
      });
    }
  }
}
