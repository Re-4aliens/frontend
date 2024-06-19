import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingTermsPage extends StatefulWidget {
  const SettingTermsPage({super.key});

  @override
  State<SettingTermsPage> createState() => _SettingTermsPageState();
}

class _SettingTermsPageState extends State<SettingTermsPage> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth <= 600;

    List<String> termsList = [
      'setting-terms'.tr(),
      'setting-private'.tr(),
    ];

    List<String> navigatorList = [
      '/setting/terms/use',
      '/setting/terms/private'
    ];
    List<String> koUrl = [
      'https://www.notion.so/b9f482dffc8e4bec9a00a0995ea94c8e?pvs=4',
      'https://www.notion.so/5b22067f1f474dd6b77bf2d0f6110308?pvs=4'
    ];
    List<String> enUrl = [
      'https://www.notion.so/Terms-of-service-9dec964585be45f899b9ce78762666d3?pvs=4',
      'https://www.notion.so/privacy-policy-b267f77f0b264ec48eaf6ca5b8a9511b?pvs=4'
    ];

    Future<void> _launchUrl(String url) async {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri)) {
        throw Exception('Could not launch $url');
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          appBar: AppBar(),
          backgroundColor: Colors.transparent,
          infookay: false,
          infocontent: '',
          title: 'setting-terms'.tr(),
        ),
        body: Container(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
          child: ListView.builder(
            itemCount: 2,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  //한국어로 설정되어 있다면
                  if (EasyLocalization.of(context)!.locale ==
                      const Locale.fromSubtags(
                          languageCode: "ko", countryCode: "KR")) {
                    _launchUrl(koUrl[index]);
                  }
                  //영어로 설정되어 있다면
                  else {
                    _launchUrl(enUrl[index]);
                  }
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      termsList.elementAt(index),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isSmallScreen ? 14 : 16,
                      ),
                    ),
                    Expanded(child: Container()),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: isSmallScreen ? 14 : 16,
                      color: const Color(0xffC1C1C1),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
