import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../views/pages/signup/signup_mbti.dart' as signupMBTI;


class mbtiButton extends StatefulWidget{
  final text;
  final explain;
  final mbti;
  final color;

  const mbtiButton({
    Key? key,
    required this.text,
    required this.explain,
    required this.mbti,
    required this.color,
  }) : super(key:key);

  @override
  State<mbtiButton> createState() => mbtiButtonState();
}

class mbtiButtonState extends State<mbtiButton>{



  @override
  Widget build(BuildContext context){
    dynamic btnColor = widget.color;


    void changeWidget() {
      setState(() {
        //선택된 값이 있으면 선택된 값의 버튼 컬러는 그레이로 한다.
        signupMBTI.btnColor = Colors.green;
        signupMBTI.selected == widget.mbti ? btnColor = Colors.white : btnColor = widget.color;
      });
    }

    return MaterialButton(
      minWidth: 160,
      height: 230,
      elevation: 3.0,
      highlightElevation: 1.0,
      onPressed: (){
        signupMBTI.selected = widget.mbti;
        print(signupMBTI.selected);
        changeWidget();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      color : signupMBTI.selected == widget.mbti ? Colors.white : widget.color,
      textColor: Colors.black,
      child: Column(
        children: [
          Positioned(
            right: 5,
            child:Icon(Icons.check_circle_outline),
          ),

          Text(widget.text, textAlign: TextAlign.center,style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
          Text(widget.explain,textAlign: TextAlign.center,style: TextStyle(fontSize: 13),),
          Container(
            width: 60,height: 60,
            decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.grey),
          ),
          Text(widget.mbti, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

        ]
      ),

    );

  }


}



