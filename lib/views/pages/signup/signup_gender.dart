import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

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

    return Scaffold(
      appBar: CustomAppBar(appBar: AppBar(), title: '', onPressed: () {},),
      body: Padding(
        padding: EdgeInsets.only(right: 20,left: 20,top: 50,bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('성별을 알려주세요',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('성별', style: TextStyle(fontSize: 20,),),
                DropdownButton(
                    hint: Text('성별') ,
                    items: _GenderList.map((value){
                      return DropdownMenuItem(
                          child: Text(value,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          value: value);
                    }).toList(),
                    value: _selectedGender,
                    onChanged: (value){
                      print(value);
                      setState(() {
                        _selectedGender = value!;
                      });
                    }),
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
                  member.gender = _selectedGender;
                  print(member.toJson());
                  Navigator.pushNamed(context,'/nationality', arguments: member);
                })

          ],
        ),
      ),
    );
  }
}