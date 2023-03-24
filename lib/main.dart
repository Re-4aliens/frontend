import 'package:flutter/material.dart';

import 'package:aliens/views/components/appbar.dart';
import 'package:aliens/views/pages/login_page.dart';

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
      initialRoute: '/',
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
