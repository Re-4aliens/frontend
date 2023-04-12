import 'package:aliens/views/components/appbar.dart';
import 'package:aliens/views/components/button_big.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../../../models/members.dart';
import '../../components/button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _EmailController = TextEditingController();
  final TextEditingController _PasswordController = TextEditingController();

  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
     /* appBar: CustomAppBar(
        appBar: AppBar(),
        title: '',
        onPressed: () {},
      ),*/
      body: Padding(
        padding: EdgeInsets.only(right: 20, left: 20, top: MediaQuery.of(context).size.height * 0.2, bottom: MediaQuery.of(context).size.height * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.0005),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.26,
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: BoxDecoration(color: Colors.grey),
                  ),
                  Text(
                    'FRIEND SHIP',
                    style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.023, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '프렌즈쉽에 오신것을 환영합니다.',
                    style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.026),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                  children: [
                    Form(
                      child: Material(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 3.0,
                        child: TextFormField(
                          validator : (value) => value!.isEmpty? "Please enter some text" : null,
                          controller: _EmailController,
                          decoration: new InputDecoration(
                            contentPadding: EdgeInsets.all(25),
                              hintText: '이메일주소',
                              hintStyle: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height * 0.026,
                                color: Color(0xffA0A0A0)
                              ),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25)
                              )
                          ),
                        ),
                      ) ,

                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.024),
                    Form(
                      child: Material(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 3.0,
                        child: TextFormField(
                          validator : (value) => value!.isEmpty? "Please enter some text" : null,
                          controller: _PasswordController,
                          decoration: new InputDecoration(
                              contentPadding: EdgeInsets.all(25),
                              hintText: '비밀번호',
                              hintStyle: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height * 0.026,
                                  color: Color(0xffA0A0A0)
                              ),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25)
                              )
                          ),
                        ),
                      ) ,

                    ),
                  ],
                ),
            ),
        BigButton(
          child: Text('로그인'),
            onPressed: () {
              //스택 비우고
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/main', (Route<dynamic> route) => false
              );
            },),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('비밀번호를 잊으셨나요?'),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login/findpassword');
                    },
                    child: Text(
                      '비밀번호 찾기',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
