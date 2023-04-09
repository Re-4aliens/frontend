import 'package:aliens/views/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../../../models/members.dart';
import '../../components/button.dart';

class SignUpEmail extends StatefulWidget{
  const SignUpEmail({super.key});

  @override
  State<SignUpEmail> createState() => _SignUpEmailState();
}

class _SignUpEmailState extends State<SignUpEmail>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _EmailController = TextEditingController();
  FocusNode _emailFocus = new FocusNode();

  Widget build(BuildContext context){
    //Members members = new Members('','','','','','','','');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(appBar: AppBar(), title: '', onPressed: () {},),
      body: Padding(
        padding: EdgeInsets.only(right: 20,left: 20,top: 50,bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('본인 인증을 위해\n이메일을 입력해주세요',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            SizedBox(height: 10),
            Text('작성하신 메일로 보내드린 코드를 통해 인증이 진행됩니다.',style: TextStyle(fontSize: 14, color: Color(0xff888888)),),
            SizedBox(height: 40),
             Form(
               key: _formKey,
               child: Row(
                 children: [
                   Flexible(
                      child:TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        focusNode: _emailFocus,
                        validator : (value) => CheckValidate().validateEmail(_emailFocus, value!),
                        controller: _EmailController,
                              decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '이메일 주소를 입력해주세요',
                                  hintStyle: TextStyle(fontSize: 12, color: Color(0xffD9D9D9))
                              ),)
                   ),
                   Container(
                     child: ElevatedButton(
                       style:ElevatedButton.styleFrom(
                             backgroundColor: Color(0xff5F5F5F),// 여기 색 넣으면됩니다
                             shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(40)
                             )
                         ),
                       child: Text('중복확인', style: TextStyle(color: Color(0xffC4C4C4)),),
                       onPressed: (){
                         showDialog(
                             context: context,
                             builder: (BuildContext context){
                               return AlertDialog(
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(20.0),
                                 ),
                                 title: Text('이메일 중복확인', textAlign: TextAlign.center,
                                 style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                 content: Column(
                                   mainAxisSize: MainAxisSize.min,
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   children: [
                                     Text('사용 가능한 이메일입니다.\n계속해서 회원가입 진행을 완료해주세요:)\n',
                                     textAlign: TextAlign.center,
                                     style: TextStyle(fontSize: 14),),
                                     SizedBox(height: 10),
                                     Divider(
                                       height: 0,
                                       thickness: 1,
                                       endIndent: 0,
                                       indent: 0,
                                     ),
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         SimpleDialogOption(
                                           child: Text('취소', style: TextStyle(fontSize: 14),),
                                           onPressed: (){Navigator.pop(context);},
                                         ),
                                         VerticalDivider(
                                           thickness: 1,
                                           width: 1,
                                         ),
                                         SimpleDialogOption(
                                           child: Text('계속하기',
                                           style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                                           onPressed: (){

                                             }
                                         )
                                       ],
                                     )
                                   ],
                                 ),
                               );
                             });
                       },
                     ),
                   )
                 ],
               )

                   ),
            Divider(
              height: 0,
              thickness: 1,
            ),
            Expanded(child: SizedBox()),
            Button(
                child: Text('본인 인증하기'),
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    Navigator.pushNamed(context,'/verify', /*arguments: members*/);
                  }
                })

          ],
        ),
      ),
    );
  }
}


class CheckValidate {
  String? validateEmail(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return '이메일 주소를 입력하세요.';
    } else {
      String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus();
        return '잘못된 이메일 형식입니다.';
      } else {
        return null;
      }
    }
  }
}