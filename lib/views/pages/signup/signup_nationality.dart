import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:aliens/main.dart';
import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../models/members.dart';
import '../../components/button.dart';

class SignUpNationality extends StatefulWidget {
  const SignUpNationality({super.key});

  @override
  State<SignUpNationality> createState() => _SignUpNationalityState();
}

List<dynamic> nationList = [];

class _SignUpNationalityState extends State<SignUpNationality> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _NationalityController =
      new TextEditingController();
  var _selectedNationality;

  Widget build(BuildContext context) {
    dynamic member = ModalRoute.of(context)!.settings.arguments;

    //값 불러오는 함수
    Future<List?> getNationList() async {
      List<String> nationTextList = [];
      try {
        const url =
            'http://13.125.205.59:8080/api/v1/member/nationalities'; //mocksever

        var response = await http.get(Uri.parse(url));

        //success
        if (response.statusCode == 200) {
          print('요청 성공');
          var listLength =
              json.decode(response.body)['response']['nationalities'].length;
          for (int i = 0; i < listLength; i++) {
            nationTextList.add(json.decode(response.body)['response']
                ['nationalities'][i]['natinalityText']);
            nationList.add(json
                .decode(response.body)['response']['nationalities'][i]
                .values
                .toList());
          }
        } else {
          //오류 생기면 상태 확인
          print("요청 오류: " + response.statusCode.toString());
        }
      } catch (error) {
        print(error);
        return null;
      }

      //리스트 반환
      return nationTextList;
    }

    return Scaffold(
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: '',
        onPressed: () {}, backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
          future: getNationList(),
          builder: (context, snapshot) {
            if (snapshot.hasData == false)
              return Container();
            else if (snapshot.hasError) {
              return Container();
            } else {
              return Padding(
                padding: EdgeInsets.only(
                    right: 20,
                    left: 20,
                    top: MediaQuery.of(context).size.height * 0.06,
                    bottom: MediaQuery.of(context).size.height * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '국적을 선택해주세요',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.04,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '국적',
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.026,
                          ),
                        ),
                        ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton(
                              underline: SizedBox.shrink(),
                              icon: SvgPicture.asset(
                                'assets/icon/icon_dropdown.svg',
                                width:
                                    MediaQuery.of(context).size.width * 0.037,
                                height:
                                    MediaQuery.of(context).size.height * 0.011,
                              ),
                              hint: Text('국적'),
                              items: snapshot.data!.map((value) {
                                return DropdownMenuItem(
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.height *
                                              0.032,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    value: value);
                              }).toList(),
                              value: _selectedNationality,
                              onChanged: (value) {
                                print(value);
                                setState(() {
                                  _selectedNationality = value!.toString();
                                });
                              }),
                        ),
                      ],
                    ),
                    Divider(
                      height: 0,
                      thickness: 1,
                    ),
                    Expanded(child: SizedBox()),
                    Button(
                        child: Text('확인'),
                        onPressed: () {
                          if (_selectedNationality != '') {
                            //member.nationality = _selectedNationality;
                            var nationality = snapshot.data!
                                    .toList()
                                    .indexOf(_selectedNationality) +
                                1;
                            member.nationality = nationality.toString();
                            print(member.toJson());
                            Navigator.pushNamed(context, '/mbti',
                                arguments: member);
                          }
                        })
                  ],
                ),
              );
            }
          }),
    );
  }
}
