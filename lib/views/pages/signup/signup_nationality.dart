import 'dart:convert';
import 'package:country_picker/country_picker.dart';

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

/*List<dynamic> nationList = [];*/

class _SignUpNationalityState extends State<SignUpNationality> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _NationalityController = new TextEditingController();
  var _selectedNationality = '';

  Widget build(BuildContext context) {
    dynamic member = ModalRoute.of(context)!.settings.arguments;
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;


    return Scaffold(
        backgroundColor: Colors.white,
      appBar: CustomAppBar(
        appBar: AppBar(),
        title: '',
        backgroundColor: Colors.white, infookay: false, infocontent: '',
      ),
      body: Padding(
        padding: EdgeInsets.only(
            right: 24,
            left: 24,
            top: MediaQuery.of(context).size.height * 0.06,
            bottom: MediaQuery.of(context).size.height * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '국적을 선택해주세요',
              style: TextStyle(
                  fontSize: isSmallScreen?22:24,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '국적',
                    style: TextStyle(
                      fontSize:isSmallScreen?14:16,
                    ),
                  ),
                  InkWell(
                    key: _formKey,
                    onTap: (){

                    },
                    child: Row(
                      children: [
                        Text(
                          _selectedNationality,
                          style: TextStyle(
                            fontSize: isSmallScreen?18:20, fontWeight: FontWeight.bold
                          ),
                        ),
                        IconButton(
                          icon: SvgPicture.asset(
                            'assets/icon/icon_dropdown.svg',
                            width:
                            MediaQuery.of(context).size.width * 0.037,
                            height:
                            MediaQuery.of(context).size.height * 0.011,
                          ),
                          onPressed: () {
                            showCountryPicker(
                                context: context,
                                showPhoneCode: false,
                                onSelect: (Country country){
                                  print('Select country: ${country.displayName}');
                                  setState(() {
                                    var countryName = country.displayName.toString();
                                    countryName = countryName.substring(0, countryName.indexOf(' ('));
                                    _selectedNationality = countryName;
                                  });
                                });
                          },
                        )
                      ],
                    ),

                  )

                ],
              ),
            ),

            /*
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '국적',
                      style: TextStyle(
                        fontSize:isSmallScreen?14:16,
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
                          items: country.map((value) {
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
              ),
            ),*/
            Divider(
              height: 0,
              thickness: 1,
            ),
            Expanded(child: SizedBox()),
            Button(
                child: Text('확인'),
                onPressed: () {
                  member.nationality = 1;
                  print(member.toJson());
                  Navigator.pushNamed(context, '/mbti', arguments:member);
                  /*if (_selectedNationality != '') {
                    member.nationality = _selectedNationality;
                    *//*var nationality = snapshot.data!
                        .toList()
                        .indexOf(_selectedNationality) +
                        1;
                    member.nationality = nationality.toString();*//*
                    print(member.toJson());
                    Navigator.pushNamed(context, '/mbti',
                        arguments: member);
                  }*/
                })
          ],
        ),
      )
      /*FutureBuilder(
          future: getNationList(),
          builder: (context, snapshot) {
            if (snapshot.hasData == false)
              return Container();
            else if (snapshot.hasError) {
              return Container();
            } else {
              return ;
            }
          }),*/
    );
  }
}