import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget{
  final Widget child;
  final VoidCallback onPressed;

  const Button({
    Key? key,
    required this.child,
    required this.onPressed,
  }) : super(key:key);

  @override
  Widget build(BuildContext context){
    return Container(
      width : double.maxFinite,
      height: MediaQuery.of(context).size.height * 0.057 ,
      //margin: EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        child: child,
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.026),
            backgroundColor: Color(0xff7898FF),// 여기 색 넣으면됩니다
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40)
            )

        ),
      ),


    );

  }
}