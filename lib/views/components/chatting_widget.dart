
import 'package:flutter/material.dart';

Widget chattingWidget(BuildContext context, partners) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
    ),
    alignment: Alignment.center,
    child: Text('매칭이 완료되면 채팅이 활성화됩니다.\n조금만 기다려주세요!')
  );
}
Widget chatList(context, name, lastMassage, time){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    child: MaterialButton(
      minWidth: 350,
      height: 77,
      padding: EdgeInsets.symmetric(horizontal: 15),
      elevation: 5.0,
      onPressed: () {
        Navigator.pushNamed(context, '/chatting', arguments: name);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      color: Colors.white,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Color(0xffD9D9D9),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          Expanded(child: Container(
            margin: EdgeInsets.only(
              left: 20,
              top: 15,
              bottom: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),),
                    Text(time,
                    style: TextStyle(

                    ),)
                  ],
                ),
                SizedBox(height: 8),
                Text(lastMassage,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xffA4A4A4),
                  ),),
              ],
            ),
          )),
        ],
      ),
    ),
  );
}