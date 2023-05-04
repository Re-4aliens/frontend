import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/screenArgument.dart';
import 'package:aliens/providers/member_provider.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


dynamic status= {
  '': '',
};
dynamic applicant= {
  '': '',
};
dynamic partners= {
  '': '',
};



Future<Map<String, dynamic>> applicantInfo() async {
  final storage = FlutterSecureStorage();
  var response;
  print('매칭 상태 요청');
  try {

    const url =
        'http://13.125.205.59:8080/api/v1/matching/applicant'; //mocksever

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['accessToken'];

    response = await http.get(Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json'},
    );

    //success
    if (response.statusCode == 200) {
      print('신청 정보 요청 성공');
      print(json.decode(response.body));

      //fail
    } else {
      //오류 생기면 바디 확인
      print("요청 오류: " + response.statusCode.toString());
    }
  } catch (error) {
    print(error);
    throw error;
  }

  return json.decode(utf8.decode(response.bodyBytes))['response'];
}

Future<Map<String, dynamic>> applicantStatus() async {
  final storage = FlutterSecureStorage();
  var response;
  print('매칭 상태 요청');
  try {
    const url =
        'http://13.125.205.59:8080/api/v1/matching/status'; //mocksever

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['accessToken'];


    response = await http.get(Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json'},
    );

    //success
    if (response.statusCode == 200) {
      print('신청정보 요청 성공');
      print(json.decode(response.body));


      //fail
    } else {
      //오류 생기면 바디 확인
      print("요청 오류: " + response.statusCode.toString());
    }
  } catch (error) {
    print(error);
    throw error;
  }

  return json.decode(utf8.decode(response.bodyBytes))['response'];
}

Future<Map<String, dynamic>> applicantPartners() async {
  final storage = FlutterSecureStorage();
  var response;
  print('상대 정보 요청');
  try {
    const url =
        'http://13.125.205.59:8080/api/v1/matching/partners';

    //토큰 읽어오기
    var jwtToken = await storage.read(key: 'token');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['accessToken'];


    response = await http.get(Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json'},
    );

    //success
    if (response.statusCode == 200) {
      print('상대 정보 요청 성공');
      print(json.decode(response.body));


      //fail
    } else {
      //오류 생기면 바디 확인
      print("요청 오류: " + response.statusCode.toString());
    }
  } catch (error) {
    print(error);
    throw error;
  }

  return json.decode(utf8.decode(response.bodyBytes))['response'];
}




class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});
  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  @override
  void initState() {
    super.initState();
    getData();
  }
  Future<Map<String, dynamic>> getData() async {
    var memberDetails = Provider.of<MemberProvider>(context, listen: false);
    status = await applicantStatus();
    if(status['status'] == 'MATCHED'){
      applicant = await applicantInfo();
      partners = await applicantPartners();
    }
    return memberDetails.memberInfo();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return Center(child: CircularProgressIndicator());
         }
          else if (snapshot.hasError) {
            //에러
            return Container();
          }
          else {
            //빌드하기 전에 또 다음 페이지를 불러서 생기는 오류 때문에 빌드가 끝난 다음에 수행될 수 있도록한다.
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              Navigator.popAndPushNamed(context, '/main',
                arguments: ScreenArguments(
                snapshot.data!,
                  status,
                  applicant,
                  partners,
              ));
            });
            return Scaffold(
              body: Center(
                child: Column(
                  children: [
                    Text('${status}'),
                    Text('${applicant}'),
                    Text('${partners}'),
                  ],
                ),
              ),
            );
          }
        });
  }
}


