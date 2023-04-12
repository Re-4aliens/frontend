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
    dynamic member = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(appBar: AppBar(), title: '', onPressed: () {},),
      body: Padding(
        padding: EdgeInsets.only(right: 20,left: 20,top: MediaQuery.of(context).size.height * 0.06,bottom: MediaQuery.of(context).size.height * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('메일로 보내드린\n인증코드를 입력해주세요',
              style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.04, fontWeight: FontWeight.bold),),
            SizedBox(height: MediaQuery.of(context).size.height * 0.013),
            Text('수신하지 못했다면 스팸함 또는 해당 이메일 서비스의\n설정을 확인해주세요.',
            style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.023, color: Color(0xff888888)),),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
             Form(
               key: _formKey,
               child: Column(
                 children: [
                   TextFormField(
                   validator : (value) => value!.isEmpty? "인증코드를 입력해주세요" : null,
                   controller: _VerifyController,
                   decoration: new InputDecoration(
                       hintText: '인증코드입력',
                       hintStyle: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.026, color: Color(0xffD9D9D9))
                   ),),
                   SizedBox(height: MediaQuery.of(context).size.height * 0.036),
                   Container(
                     height: MediaQuery.of(context).size.height * 0.036,
                     child: ElevatedButton(
                         onPressed: (){

                         },
                         style:ElevatedButton.styleFrom(
                             backgroundColor: Color(0xffEBEBEB),// 여기 색 넣으면됩니다
                             shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(40)
                             )
                         ),
                         child: Text('인증코드 재전송', style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.023, color: Color(0xff4D4D4D)),)
                     ),
                   )
                 ],
               )

                   ),
            Expanded(child: SizedBox()),
            Button(
                child: Text('본인 인증완료'),
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    Navigator.pushNamed(context,'/finish', arguments: member);
                  }
                })

          ],
        ),
      ),
    );
  }
}