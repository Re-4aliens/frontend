import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class mbtiButton extends StatelessWidget{
  final text;
  final explain;
  final mbti;
  final bool selected;
  final String step;
  final VoidCallback onPressed;

  const mbtiButton({
    Key? key,
    required this.text,
    required this.explain,
    required this.mbti,
    required this.selected,
    required this.step,
    required this.onPressed
  }) : super(key:key);

  @override
  Widget build(BuildContext context){
    return MaterialButton(
      minWidth: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.3,
      elevation: 3.0,
      highlightElevation: 1.0,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      color: selected? Color(0xff7898FF):Colors.white  ,
      textColor: Colors.black,
      child: Column(
        children: [
          Positioned(

            child: selected? Icon(Icons.check_circle, color: Colors.white) : Icon(Icons.check_circle_outline),
          ),

          Text(text, textAlign: TextAlign.center,style: TextStyle(
              color: selected ? Colors.white: Colors.black,
              fontSize: 15, fontWeight: FontWeight.bold),),
          Text(explain,textAlign: TextAlign.center,style: TextStyle(
              color: selected ? Colors.white: Colors.black,
              fontSize: 13),),
          Container(
            width: 60,height: 60,
            decoration: BoxDecoration(shape: BoxShape.circle,
                color: selected? Color(0xffFFB5B5): Colors.grey),
          ),
          Text(mbti, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
          color:selected? Colors.white : Colors.black ),),

        ]
      ),

    );

  }

  void changeWidget() {}
}



