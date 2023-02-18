import 'dart:convert';

import 'package:flutter/material.dart';


class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('log in test'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 50, right: 50),
              child: TextFormField(

              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(left: 50, right: 50),
              child: TextFormField(

              ),
            ),
            Container(
              child: ElevatedButton(
                onPressed: () async {
                },
                child: Text("Log In"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}