import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class mbtiButton extends StatelessWidget{
  final text;
  final explain;
  final mbti;
  final bool selected;
  final String step;
  final VoidCallback onPressed;
  final String image;


  const mbtiButton({
    Key? key,
    required this.text,
    required this.explain,
    required this.mbti,
    required this.selected,
    required this.step,
    required this.onPressed,
    required this.image,
  }) : super(key:key);

  @override
  Widget build(BuildContext context){
    final double screenWidth = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth <= 800;

    return Container(
      margin: EdgeInsets.only(left: 15,right: 15, top: 5, bottom: 5),
     // width: MediaQuery.of(context).size.width * 0.4,
      width: isSmallScreen ? 140 : 160,
      height: isSmallScreen ? 210 : 240,
      //width: isSmallScreen?MediaQuery.of(context).size.width * 0.37: MediaQuery.of(context).size.width * 0.42,
      //height: isSmallScreen? (MediaQuery.of(context).size.width * 0.37)*4.5/3:(MediaQuery.of(context).size.width * 0.42)*4.5/3,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25), // 10은 모서리 반경 값입니다.
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child:NeumorphicButton(
        style: NeumorphicStyle(
          color: selected? Color(0xff7898FF):Colors.white,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(25)),
          shadowDarkColorEmboss: Color(0xff7898FF).withOpacity(0.5),
          intensity: 10,
          //surfaceIntensity: 30,
          depth: -5, // depth 값이 음수이면 Inner Shadow 효과가 적용
          lightSource: LightSource.bottomRight,
        ), onPressed: onPressed,
        child: Container(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    selected? SvgPicture.asset(
                        'assets/icon/icon_check.svg',
                        width: MediaQuery.of(context).size.width * 0.077,
                        color: Colors.white)
                        : SvgPicture.asset(
                      'assets/icon/icon_emptycheck.svg',
                      width : MediaQuery.of(context).size.width * 0.077,
                      // color : Color(0xffFFF2a2)
                    ),

                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                  ],
                ),
                //SizedBox(height: MediaQuery.of(context).size.height * 0.002),
                Center(
                  child: Column(
                    children: [
                      Text(text, textAlign: TextAlign.center,style: TextStyle(
                          color: selected ? Colors.white: Colors.black,
                          fontSize: isSmallScreen?15:17, fontWeight: FontWeight.bold),),
                      Text(explain,textAlign: TextAlign.center,style: TextStyle(
                          color: selected ? Colors.white: Colors.black,
                          fontSize: isSmallScreen?13:15),),
                      Container(
                        width: 60,height: 60,
                        decoration: BoxDecoration(shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(image),
                      ),
                      Text(mbti, textAlign: TextAlign.center, style: TextStyle(fontSize: isSmallScreen?20:22, fontWeight: FontWeight.bold,
                          color:selected? Colors.white : Colors.black ),),
                    ],
                  ),
                ),

              ]
          ),

        ),
      ) ,
    );

  }

}



