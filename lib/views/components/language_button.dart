import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class languageButton extends StatelessWidget{
  final language;
  final flag;


  const languageButton({
    Key? key,
    required this.language,
    required this.flag,
  }) : super(key:key);

  @override
  Widget build(BuildContext context){
    return MaterialButton(
        height: MediaQuery.of(context).size.height * 0.14,
        minWidth: MediaQuery.of(context).size.width * 0.4,
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
                        height: MediaQuery.of(context).size.height * 0.06,
                      ),
                      Text(
                        language,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height * 0.032,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.064)
                ],
              ),
            ),
            Container(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.072,
                    height: MediaQuery.of(context).size.height * 0.033,
                    child: SvgPicture.asset(
                      'assets/icon/icon_check.svg',
                    ),
                ),
            ),
              ],
            ),
        );

  }

  void changeWidget() {}
}



