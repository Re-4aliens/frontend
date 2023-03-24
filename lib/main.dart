import 'package:aliens/views/pages/login/login_checkmail_page.dart';
import 'package:aliens/views/pages/login/login_findpassword_page.dart';
import 'package:aliens/views/pages/login/login_page.dart';
import 'package:aliens/views/pages/signup/signup_birthday.dart';
import 'package:aliens/views/pages/signup/signup_email.dart';
import 'package:aliens/views/pages/signup/signup_emailverify.dart';
import 'package:aliens/views/pages/signup/signup_gender.dart';
import 'package:aliens/views/pages/signup/signup_mbti.dart';
import 'package:aliens/views/pages/signup/signup_nationality.dart';
import 'package:aliens/views/pages/signup/signup_password.dart';
import 'package:aliens/views/pages/signup/signup_profile.dart';
import 'package:aliens/views/pages/signup/signup_school.dart';
import 'package:aliens/views/pages/signup/signup_verifyfinish.dart';
import 'package:aliens/views/pages/signup/signup_welcome.dart';
import 'package:aliens/views/pages/start_page.dart';
import 'package:flutter/material.dart';

import 'package:aliens/views/components/appbar.dart';
import 'package:aliens/views/pages/login_page.dart';

import 'package:aliens/views/components/button.dart';
import 'package:aliens/views/pages/signup/signup_name.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      initialRoute: '/start',
      routes: {

        '/' : (context)=> ChangeNotifierProvider(create: (context) => MemberProvider(), child: MainPage()),
        '/home' : (context)=> HomePage(),

        // matching
        '/apply' : (context) => MatchingApplyPage(),
        '/done' : (context) => MatchingDonePage(),
        '/state' : (context) => MatchingStatePage(),
        '/choose' : (context) => MatchingChoosePage(),
        '/apply/done' : (context) => MatchingApplyDonePage(),
        '/info/my' : (conext) => MatchingInfoPage(title: '나의 매칭 정보'),
        '/info/your' : (context) => MatchingInfoPage(title: '남의 매칭 정보'),
        '/edit' : (context) => MatchingEditPage(),

        //setting
        '/setting/edit' : (context) => SettingEditPage(),
        '/setting/notification' : (context) => SettingNotificationPage(),
        '/setting/terms': (context) => SettingTermsPage(),
        '/setting/security': (context) => SettingSecurityPage(),
        '/setting/delete' : (context) => SettingDeletePage(),
        '/setting/delete/done': (context) => SettingDeleteDonePage(),
        '/setting/edit/PW' : (context) => SettingEditPWPage(),
        '/setting/edit/PW/done' : (context) => SettingEditPWDonePage(),
        '/setting/edit/find' : (context) => SettingFindPWPage(),

       '/' : (context)=> MyHomePage(),
        '/start' : (context)=> StartPage(),

        //SignUp
        '/name' : (context) => SignUpName(),
        '/birthday': (context) => SignUpBirthday(),
        '/gender' : (context) => SignUpGender(),
        '/nationality' :(context) => SignUpNationality(),
        '/mbti': (context) => SignUpMbti(),
        '/profile': (context) => SignUpProfile(),
        '/school' : (context) => SignUpSchool(),
        '/email': (context) => SignUpEmail(),
        '/verify' : (context) => SignUpVerify(),
        '/finish': (context) => SignUpVerifyFinish(),
        '/password': (context) => SignUpPassword(),
        '/welcome' : (context) => SignUpWelcome(),

        //login
        '/login': (context) => Login(),
        '/findpassword' : (context) => LoginFindPassword(),
        '/checkemail' : (context)=> LoginCheckMail(),



      },
    );
  }
}

class MyHomePage extends StatefulWidget {

  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('4aliens'),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '',
            ),
          ],
        ),
      ),
    );
  }
}
