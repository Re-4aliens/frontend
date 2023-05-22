import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../models/members.dart';
import '../../components/button.dart';

class SignUpGender extends StatefulWidget{
  const SignUpGender({super.key});

  @override
  State<SignUpGender> createState() => _SignUpGenderState();
}

class _SignUpGenderState extends State<SignUpGender>{
  final _GenderList = ['남성', '여성'];
  var _selectedGender = '남성';

  Widget build(BuildContext context){
    dynamic member = ModalRoute.of(context)!.settings.arguments;
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    return Scaffold(
      appBar: CustomAppBar(appBar: AppBar(), title: '',  backgroundColor: Colors.white, infookay: false, infocontent: '',),
      body: Padding(
        padding: EdgeInsets.only(right: 24, left: 24,top: MediaQuery.of(context).size.height * 0.06,bottom: MediaQuery.of(context).size.height * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('성별을 알려주세요',
              style: TextStyle(fontSize: isSmallScreen?22:24, fontWeight: FontWeight.bold),),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('성별', style: TextStyle(fontSize: isSmallScreen?14:16,),),
                ButtonTheme(
                  alignedDropdown: true,
                child: DropdownButton(
                underline: SizedBox.shrink(),
                    icon: SvgPicture.asset(
                      'assets/icon/icon_dropdown.svg',
                      width: MediaQuery.of(context).size.width * 0.037,
                      height: MediaQuery.of(context).size.height * 0.011,
                    ),
                    hint: Text('성별',style: TextStyle(fontSize: isSmallScreen?18:20, color: Color(0xffD9D9D9)),) ,
                   items: _GenderList.map((value){
                        return DropdownMenuItem(
                            child: Text(value,
                              style: TextStyle(fontSize: isSmallScreen?18:20, fontWeight: FontWeight.bold),),
                            value: value);
                      }).toList(),
                    value: _selectedGender,
                    onChanged: (value){
                      print(value);
                      setState(() {
                        _selectedGender = value!;
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
                onPressed: (){
                  if(_selectedGender == '여성')
                    member.gender = 'FEMALE';
                  else
                    member.gender = 'MALE';
                  print(member.toJson());
                  Navigator.pushNamed(context,'/nationality', arguments: member);
                })

          ],
        ),
      ),
    );
  }
}