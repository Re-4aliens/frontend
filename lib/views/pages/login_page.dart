import 'dart:convert';

import 'package:flutter/material.dart';


class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('log in'),
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