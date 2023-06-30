import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Button extends StatefulWidget{
  final Widget child;
  final VoidCallback onPressed;
  final bool isEnabled;

  const Button({
    Key? key,
    required this.child,
    required this.onPressed,
    required this.isEnabled,
  }) : super(key:key);

  @override
  State<StatefulWidget> createState() => _ButtonState();
}


class _ButtonState extends State<Button>{

  @override
  Widget build(BuildContext context){
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 700;
    final double fontSize = isSmallScreen ? 14.0 : 16.0;


    return Container(
      width : double.maxFinite,
      height: isSmallScreen?44:48,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        child: widget.child,
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(fontSize: fontSize),
            backgroundColor: widget.isEnabled? Color(0xff7898FF) : Color(0xffEBEBEB),// 여기 색 넣으면됩니다
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
            ),
            elevation: 0.0,
        ),
      ),
    );


  }
}