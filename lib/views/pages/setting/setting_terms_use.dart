import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/material.dart';

class SettingTermsUsePage extends StatelessWidget {
  const SettingTermsUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;

    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        backgroundColor: Colors.transparent,
        infookay: false,
        infocontent: '',
        title: '서비스 이용약관',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
            right: 24,
            left: 24,
            top: MediaQuery.of(context).size.height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '제 1장 총칙',
              style: TextStyle(
                  fontSize: isSmallScreen ? 18 : 20,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              '• 제 1조 (목적)',
              style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              '프렌드쉽 서비스 이용약관은 프렌드쉽(이하 “회사”라 합니다)이 제공하는 프렌드쉽 서비스의 이용과 관련하여 관리자와 이용자간의 권리, 의무 및 책임 사항, 기타 필요한 사항 등을 규정함을 목적으로 합니다.',
              style: TextStyle(fontSize: isSmallScreen ? 11 : 13),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              '• 제 2조 (정의)',
              style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              '본 약관에서 사용하는 용어의 정의는 다음 각 호와 같으며, 정의되지 않은 본 약관상의 용어의 의미는 관련 법령, 본 이용약관 및 기타 일반적인 이용관행에 의합니다.',
              style: TextStyle(fontSize: isSmallScreen ? 11 : 13),
            ),
            const SizedBox(
              height: 17,
            ),
            Text(
              '1. 회원: 이 약관에 동의하고 서비스를 이용하는 자 \n2. 이용자: 회원 및 비회원으로서 서비스를 이용하는 자\n3.비회원: 회원이 아닌 자\n4. 아이디(ID): 회원 식별 및 서비스 이용을 위해 회원이 정하고 회사가 승인하는 문자와 숫자의 조합\n5. 비밀번호: 회원 정보보호 및 회원 본인임을 확인하기 위해 회원이 정한 문자와 숫자의 조합\n6. 이메일: 회원의 식별과 정보 수신을 위해 필요한 전자우편 주소\n7. 엠비티아이(MBTI): 사람의 성격 유형을 나타내는 심리검사인증: 회원 본인임을 확인하기 위해 회원이 제공한 정보를 회사가 확인하는 절차\n8. 매칭: 회원 간의 상호 매칭을 의미합니다.',
              style: TextStyle(fontSize: isSmallScreen ? 11 : 13),
            ),
          ],
        ),
      ),
    );
  }
}
