import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../../../models/members.dart';
import '../../components/button.dart';

class SignUpVerify extends StatefulWidget{
  const SignUpVerify({super.key});

  @override
  State<SignUpVerify> createState() => _SignUpVerifyState();
}

class _SignUpVerifyState extends State<SignUpVerify>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _VerifyController = TextEditingController();

  Widget build(BuildContext context){
    //Members members = new Members('','','','','','','','');

    return Scaffold(
      appBar: CustomAppBar(appBar: AppBar(), title: '', onPressed: () {},),
      body: Padding(
        padding: EdgeInsets.only(right: 20,left: 20,top: 50,bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('메일로 보내드린\n인증코드를 입력해주세요',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
            SizedBox(height: 10),
            Text('수신하지 못했다면 스팸함 또는 해당 이메일 서비스의\n설정을 확인해주세요.'),
            SizedBox(height: 40),
             Form(
               key: _formKey,
               child: Column(
                 children: [
                   TextFormField(
                   validator : (value) => value!.isEmpty? "인증코드를 입력해주세요" : null,
                   controller: _VerifyController,
                   decoration: new InputDecoration(
                       hintText: '인증코드입력'),),
                   ElevatedButton(
                       onPressed: (){

                       },
                       style:ElevatedButton.styleFrom(
                           backgroundColor: Colors.grey,// 여기 색 넣으면됩니다
                           shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(40)
                           )
                       ),
                       child: Text('인증코드 재전송')
                   )
                 ],
               )

                   ),
            Expanded(child: SizedBox()),
            Button(
                child: Text('본인 인증하기'),
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    Navigator.pushNamed(context,'/finish');
                  }
                })

          ],
        ),
      ),
    );
  }
}