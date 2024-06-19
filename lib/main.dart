import 'package:aliens/providers/bookmarks_provider.dart';
import 'package:aliens/providers/comment_provider.dart';
import 'package:aliens/providers/market_comment_provider.dart';
import 'package:aliens/providers/noti_board_provider.dart';
import 'package:aliens/providers/board_provider.dart';
import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/views/pages/board/market_notice_page.dart';
import 'package:aliens/views/pages/home/loading_page.dart';
import 'package:aliens/views/pages/login/login_checkmail_page.dart';
import 'package:aliens/views/pages/login/login_findpassword_page.dart';
import 'package:aliens/views/pages/login/login_page.dart';
import 'package:aliens/views/pages/setting/setting_delete_what.dart';
import 'package:aliens/views/pages/matching/matching_partner_info_page.dart';
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
import 'package:aliens/views/pages/home/start_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:overlay_support/overlay_support.dart';

import 'config/firebase_options.dart';
import './views/pages/matching/matching_apply_page.dart';
import './views/pages/matching/matching_state_page.dart';
import './views/pages/matching/matching_choose_page.dart';
import './views/pages/matching/matching_apply_done_page.dart';
import './views/pages/matching/matching_done_page.dart';
import './views/pages/matching/matching_info_page.dart';
import './views/pages/home/home_page.dart';
import './views/pages/setting/setting_notification_page.dart';
import './views/pages/setting/setting_terms_page.dart';
import './views/pages/setting/setting_security_page.dart';
import './views/pages/setting/setting_delete_page.dart';
import './views/pages/setting/setting_delete_done_page.dart';
import './views/pages/setting/setting_edit_PW_done_page.dart';
import './views/pages/setting/setting_edit_PW_page.dart';
import './views/pages/setting/setting_find_pw_page.dart';
import 'package:aliens/views/pages/home/splash_page.dart';
import './views/pages/signup/signup_name.dart';
import 'package:aliens/services/firebase_apis.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final supportedLocales = [const Locale('en', 'US'), const Locale('ko', 'KR')];

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('백그라운드 도착1');
}

@pragma('vm:entry-point')
void backgroundHandler(NotificationResponse details) {
  print('백그라운드 도착2');
}

Future<void> initializeNotification() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel(
          'high_importance_channel', 'high_importance_notification',
          importance: Importance.max));

  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      ),
    ),
    onDidReceiveNotificationResponse: (details) {
      print(details);
    },
    onDidReceiveBackgroundNotificationResponse: backgroundHandler,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
  if (message != null) {
    print(message);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SqlMessageDataBase();

  // easylocalization 초기화
  await EasyLocalization.ensureInitialized();

  // fcm 초기화 부분
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAPIs.setupFlutterNotifications();
  FirebaseMessaging.onBackgroundMessage(FirebaseAPIs.FCMBackgroundHandler);

  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  await initializeNotification();

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
        fallbackLocale: const Locale('en', 'US'),
        supportedLocales: supportedLocales,
        child: const MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) {
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
              '/': (context) => const StartPage(),
              '/main': (context) => const HomePage(),
              '/splash': (context) => const SplashPage(),

              // matching
              '/apply': (context) => const MatchingApplyPage(),
              '/done': (context) => const MatchingDonePage(),
              '/state': (context) => const MatchingStatePage(),
              '/choose': (context) => const MatchingChoosePage(),
              '/apply/done': (context) => const MatchingApplyDonePage(),
              '/info/my': (conext) => const MatchingInfoPage(),
              '/info/your': (context) => const MatchingPartnerInfoPage(),

              // setting
              '/setting/notification': (context) =>
                  const SettingNotificationPage(),
              '/setting/terms': (context) => const SettingTermsPage(),
              '/setting/terms/use': (context) => const SettingTermsUsePage(),
              '/setting/terms/private': (context) =>
                  const SettingTermsPrivatePage(),
              '/setting/security': (context) => const SettingSecurityPage(),
              '/setting/delete/what': (context) =>
                  const SettingDeleteWhatPage(),
              '/setting/delete': (context) => const SettingDeletePage(),
              '/setting/delete/done': (context) =>
                  const SettingDeleteDonePage(),
              '/setting/edit/PW': (context) => const SettingEditPWPage(),
              '/setting/edit/PW/done': (context) =>
                  const SettingEditPWDonePage(),
              '/setting/edit/find': (context) => const SettingFindPWPage(),

              // SignUp
              '/name': (context) => const SignUpName(),
              '/birthday': (context) => const SignUpBirthday(),
              '/bio': (context) => const SignUpBio(),
              '/gender': (context) => const SignUpGender(),
              '/nationality': (context) => const SignUpNationality(),
              '/mbti': (context) => const SignUpMbti(),
              '/profile': (context) => const SignUpProfile(),
              '/school': (context) => const SignUpSchool(),
              '/email': (context) => const SignUpEmail(),
              '/verify': (context) => const SignUpVerify(),
              '/finish': (context) => const SignUpVerifyFinish(),
              '/password': (context) => const SignUpPassword(),
              '/welcome': (context) => const SignUpWelcome(),

              // login
              '/login': (context) => const Login(),
              '/login/findpassword': (context) => const LoginFindPassword(),
              '/login/checkemail': (context) => const LoginCheckMail(),

              // loading
              '/loading': (context) => const LoadingPage(),

              // market board
              '/market/notice': (context) => const MarketNoticePage()
            },
          ),
        );
      },
    );
  }
}
