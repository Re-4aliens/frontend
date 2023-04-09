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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _GenderController = new TextEditingController();
  final _GenderList = ['남성', '여성'];
  var _selectedGender = '남성';

  Widget build(BuildContext context){
    //var members = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: CustomAppBar(appBar: AppBar(), title: '', onPressed: () {},),
      body: Padding(
        padding: EdgeInsets.only(right: 20,left: 20,top: 50,bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('성별을 알려주세요',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('성별', style: TextStyle(fontSize: 16),),
                ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    underline: SizedBox.shrink(),
                    icon: SvgPicture.asset(
                      'assets/icon/icon_dropdown.svg',
                      width: 14.3,
                      height: 8.98,
                    ),
                      hint: Text('성별',style: TextStyle(fontSize: 20),) ,
                      items: _GenderList.map((value){
                        return DropdownMenuItem(
                            child: Text(value,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            value: value);
                      }).toList(),
                      value: _selectedGender,
                      onChanged: (value){
                      _GenderController.text = value!;
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
                  Navigator.pushNamed(context,'/nationality', /*arguments: members*/);
                })

          ],
        ),
      ),
    );
  }
}