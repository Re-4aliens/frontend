import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../models/members.dart';
import '../../components/button.dart';

class SignUpVerifyFinish extends StatefulWidget {
  const SignUpVerifyFinish({super.key});

  @override
  State<SignUpVerifyFinish> createState() => _SignUpVerifyFinishState();
}

class _SignUpVerifyFinishState extends State<SignUpVerifyFinish> {
  Widget build(BuildContext context) {
    dynamic member = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.3),
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width* 0.72,
              height: MediaQuery.of(context).size.height * 0.29,
              //elevation: 3.0,
              //highlightElevation: 1.0,
              onPressed: () {
                Navigator.pushNamed(context, '/password', arguments: member);
              },
              shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.circular(25),
              ),
              color: Color(0xffF5F7FF),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: SvgPicture.asset(
                      'assets/icon/icon_check.svg',
                      width: MediaQuery.of(context).size.width * 0.22,
                      height: MediaQuery.of(context).size.height * 0.10,
                      color: Color(0xff7898FF),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('인증 완료!', style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.04),)
                ],
              ),
            ),
            Expanded(child: SizedBox()),

          ],
        )
      ),
    );
  }
}
