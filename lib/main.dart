import 'package:aliens/providers/bookmarks_provider.dart';
import 'package:aliens/providers/comment_provider.dart';
import 'package:aliens/providers/market_comment_provider.dart';
import 'package:aliens/providers/noti_board_provider.dart';
import 'package:aliens/repository/board_provider.dart';
import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/views/pages/board/market_notice_page.dart';
import 'package:aliens/views/pages/loading_page.dart';
import 'package:aliens/views/pages/login/login_checkmail_page.dart';
import 'package:aliens/views/pages/login/login_findpassword_page.dart';
import 'package:aliens/views/pages/login/login_page.dart';
import 'package:aliens/views/pages/matching/matching_list_page.dart';
import 'package:aliens/views/pages/setting/setting_delete_what.dart';
import 'package:aliens/views/pages/matching/matching_partner_info_page.dart';
import 'package:aliens/views/pages/setting/setting_lan_edit.dart';
import 'package:aliens/views/pages/setting/setting_mbti_edit.dart';
import 'package:aliens/views/pages/setting/setting_terms_private.dart';
import 'package:aliens/views/pages/setting/setting_terms_use.dart';
import 'package:aliens/views/pages/signup/signup_bio.dart';
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
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:aliens/views/pages/signup/signup_name.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'package:provider/provider.dart';
import './views/pages/matching/matching_apply_page.dart';
import './views/pages/matching/matching_state_page.dart';
import './views/pages/matching/matching_choose_page.dart';
import './views/pages/matching/matching_apply_done_page.dart';
import './views/pages/matching/matching_done_page.dart';
import './views/pages/matching/matching_info_page.dart';
import './views/pages/matching/matching_edit_page.dart';

import './views/pages/home_page.dart';

import './views/pages/setting/setting_notification_page.dart';
import './views/pages/setting/setting_terms_page.dart';
import './views/pages/setting/setting_terms_private.dart';
import './views/pages/setting/setting_terms_use.dart';

import './views/pages/setting/setting_security_page.dart';
import './views/pages/setting/setting_delete_page.dart';
import './views/pages/setting/setting_delete_done_page.dart';
import './views/pages/setting/setting_edit_PW_done_page.dart';
import './views/pages/setting/setting_edit_PW_page.dart';
import './views/pages/setting/setting_find_PW_page.dart';

import './views/pages/chatting/chatting_page.dart';
import './views/pages/splash_page.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

import 'apis/firebase_apis.dart';
import 'package:overlay_support/overlay_support.dart';
//import 'firebase_options.dart';

final supportedLocales = [
  Locale('en', 'US'),
  Locale('ko', 'KR')
];

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  SqlMessageDataBase();

  // easylocalization 초기화
  await EasyLocalization.ensureInitialized();


  // fcm 초기화 부분
  await initializeDefault();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  // fcm 토큰 출력
  print(fcmToken);

  FirebaseMessaging.onBackgroundMessage(FirebaseAPIs.FCMBackgroundHandler); // 백그라운드에서 동작하게 해줌


  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => BoardProvider()),
      ChangeNotifierProvider(create: (_) => CommentProvider()),
      ChangeNotifierProvider(create: (_) => MarketCommentProvider()),
      ChangeNotifierProvider(create: (_) => BookmarksProvider()),
      ChangeNotifierProvider(create: (_) => NotiBoardProvider())
    ],
    child: EasyLocalization(
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      supportedLocales: supportedLocales,
        child: const MyApp()
    ),
  ));

}

Future<void> initializeDefault() async {
  FirebaseApp app = await Firebase.initializeApp();
  print('Initialized default app $app');
  final fcmToken = await FirebaseMessaging.instance.getToken();
  // fcm 토큰 출력
  print(fcmToken);
}


class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child){
        return OverlaySupport.global(
          child: MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              theme: ThemeData(fontFamily: 'NotoSans'),
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          initialRoute: '/splash',
          routes: {


          '/' : (context)=> StartPage(),
          //'/' : (context)=> ChangeNotifierProvider(create: (context) => MemberProvider(), child: StartPage()),

          //'/main' : (context)=> ChangeNotifierProvider(create: (context) => MemberProvider(), child: HomePage()),
          '/main': (context)=> HomePage(),

          '/splash': (context)=> SplashPage(),

          // matching
          '/apply' : (context) => MatchingApplyPage(),
          '/done' : (context) => MatchingDonePage(),
          '/state' : (context) => MatchingStatePage(),
          '/choose' : (context) => MatchingChoosePage(),
          '/apply/done' : (context) => MatchingApplyDonePage(),
          '/info/my' : (conext) => MatchingInfoPage(),
          '/info/your' : (context) => MatchingPartnerInfoPage(),
          //'/edit' : (context) => MatchingEditPage(),

          //setting
          //'/setting/lan/edit':(context) => SettingLanEditPage(),
          //'/setting/MBTI/edit' : (context) => SettingMBTIEditPage(),
          '/setting/notification' : (context) => SettingNotificationPage(),
          '/setting/terms': (context) => SettingTermsPage(),
          '/setting/terms/use' : (context) => SettingTermsUsePage(),
          '/setting/terms/private': (context) => SettingTermsPrivatePage(),
          '/setting/security': (context) => SettingSecurityPage(),
          '/setting/delete/what': (context) => SettingDeleteWhatPage(),
          '/setting/delete' : (context) => SettingDeletePage(),
          '/setting/delete/done': (context) => SettingDeleteDonePage(),
          '/setting/edit/PW' : (context) => SettingEditPWPage(),
          '/setting/edit/PW/done' : (context) => SettingEditPWDonePage(),
          '/setting/edit/find' : (context) => SettingFindPWPage(),

          //SignUp
          '/name' : (context) => SignUpName(),
          '/birthday': (context) => SignUpBirthday(),
          '/bio': (context) => SignUpBio(),
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
          '/login/findpassword' : (context) => LoginFindPassword(),
          '/login/checkemail' : (context)=> LoginCheckMail(),

          //chatting
          //'/chatting': (context) => ChattingPage(),

          //loading
          //'/loading' : (context)=> ChangeNotifierProvider(create: (context) => MemberProvider(), child: LoadingPage()),
          '/loading' : (context) => LoadingPage(),

          //market board
          '/market/notice' : (context) => MarketNoticePage()

          },
          ),
        );

      },
    );
  }
}