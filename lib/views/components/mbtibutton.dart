import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class mbtiButton extends StatelessWidget{
  final text;
  final explain;
  final mbti;
  final isSelected;

  const mbtiButton({
    Key? key,
    required this.text,
    required this.explain,
    required this.mbti,
    required this.isSelected,
  }) : super(key:key);

  @override
  Widget build(BuildContext context){
    return MaterialButton(
      minWidth: 160,
      height: 230,
      elevation: 3.0,
      highlightElevation: 1.0,
      onPressed: (){
        changeWidget();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      color: Colors.white,
      textColor: Colors.black,
      child: Column(
        children: [
          Positioned(
            right: 5,
            child:Icon(Icons.check_circle_outline),
          ),

          Text(text, textAlign: TextAlign.center,style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
          Text(explain,textAlign: TextAlign.center,style: TextStyle(fontSize: 13),),
          Container(
            width: 60,height: 60,
            decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.grey),
          ),
          Text(mbti, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

        ]
      ),

    );

  }

  void changeWidget() {}
}



