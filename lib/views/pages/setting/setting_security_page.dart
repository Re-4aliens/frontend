import 'package:aliens/models/screen_argument.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../components/appbar.dart';

class SettingSecurityPage extends StatefulWidget {
  const SettingSecurityPage({super.key});

  @override
  State<SettingSecurityPage> createState() => _SettingSecurityPageState();
}

class _SettingSecurityPageState extends State<SettingSecurityPage> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    var screenArguments =
        ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          appBar: AppBar(),
          backgroundColor: Colors.transparent,
          infookay: false,
          infocontent: '',
          title: 'setting-security'.tr(),
        ),
        body: Container(
          padding: const EdgeInsets.only(right: 24, left: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Text(
                'setting-security'.tr(),
                style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    color: const Color(0xffC1C1C1)),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, '/setting/edit/find',
                      arguments: screenArguments.memberDetails);
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'setting-changepass'.tr(),
                      style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          fontWeight: FontWeight.bold),
                    ),
                    SvgPicture.asset(
                      'assets/icon/icon_next.svg',
                      width: MediaQuery.of(context).size.width * 0.022,
                      color: const Color(0xffC1C1C1),
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
                color: Color(0xffEFEFEF),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Text(
                'setting-withdrawal'.tr(),
                style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    color: const Color(0xffC1C1C1)),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, '/setting/delete/what',
                      arguments: screenArguments);
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'setting-memwithdrawal'.tr(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 14 : 16),
                    ),
                    SvgPicture.asset(
                      'assets/icon/icon_next.svg',
                      width: MediaQuery.of(context).size.width * 0.022,
                      color: const Color(0xffC1C1C1),
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
                color: Color(0xffEFEFEF),
              ),
            ],
          ),
        ));
  }
}
