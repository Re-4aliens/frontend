import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class languageButton extends StatelessWidget{
  final language;


  const languageButton({
    Key? key,
    required this.language,
  }) : super(key:key);

  @override
  Widget build(BuildContext context){
    return MaterialButton(
        height: 116,
        minWidth: 158,
        elevation: 3.0,
        highlightElevation: 1.0,
        onPressed: () {
          changeWidget();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.white,
        textColor: Color(0xff888888),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        language,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 25,)
                ],
              ),
            ),
            Container(
              child: Container(
                    child: Icon(Icons.check_circle, size: 30,),
                ),
            ),
              ],
            ),
        );

  }

  void changeWidget() {}
}



