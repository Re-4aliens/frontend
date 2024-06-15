import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BigButton extends StatelessWidget{
  final Widget child;
  final VoidCallback onPressed;

  const BigButton({
    Key? key,
    required this.child,
    required this.onPressed,
  }) : super(key:key);

  @override
  Widget build(BuildContext context){
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    final double fontSize = isSmallScreen ? 14.0 : 16.0;

    return Container(
      width : double.maxFinite,
      height: MediaQuery.of(context).size.height * 0.066 ,
      //margin: EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        child: child,
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.026, fontWeight: FontWeight.bold),
            backgroundColor: Color(0xff7898FF),// 여기 색 넣으면됩니다
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40)
            )
        ),
      ),
    );
  }
}