import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../models/members.dart';
import '../../components/button.dart';

class SignUpNationality extends StatefulWidget{
  const SignUpNationality({super.key});

  @override
  State<SignUpNationality> createState() => _SignUpNationalityState();
}

class _SignUpNationalityState extends State<SignUpNationality>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _NationalityController = new TextEditingController();
  final _NationalityList = ['대한민국', '일본', '중국', '미국'];
  var _selectedNationality = '대한민국';

  Widget build(BuildContext context){
    //var members = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: CustomAppBar(appBar: AppBar(), title: '', onPressed: () {},),
      body: Padding(
        padding: EdgeInsets.only(right: 20,left: 20,top: MediaQuery.of(context).size.height * 0.06,bottom: MediaQuery.of(context).size.height * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('국적을 선택해주세요',
              style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.04, fontWeight: FontWeight.bold),),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('국적', style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.026,),),
                ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                      underline: SizedBox.shrink(),
                      icon: SvgPicture.asset(
                        'assets/icon/icon_dropdown.svg',
                        width: MediaQuery.of(context).size.width * 0.037,
                        height: MediaQuery.of(context).size.height * 0.011,
                      ),
                      hint: Text('국적') ,
                      items: _NationalityList.map((value){
                        return DropdownMenuItem(
                            child: Text(value,
                              style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.032, fontWeight: FontWeight.bold),),
                            value: value);
                      }).toList(),
                      value: _selectedNationality,
                      onChanged: (value){
                        _NationalityController.text = value!;
                        print(value);
                        setState(() {
                          _selectedNationality = value!;
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
                  Navigator.pushNamed(context,'/mbti', /*arguments: members*/);
                })

          ],
        ),
      ),
    );
  }
}

