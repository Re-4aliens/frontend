import 'package:flutter/material.dart';

import '../pages/home_page.dart';


Widget homeWidget(BuildContext context, memberDetails, selectedIndex) {

  return Container(
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
    ),
    child: Stack(children: [
      Column(
        children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 20,
            ),
            alignment: Alignment.topLeft,
            child: Text(
              '로고 또는 어플 이름',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          )),
          Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffefefef),
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HI, ${memberDetails['name']}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('어플 메인 문구'),
                      ],
                    ),
                    Center(
                      child: Container(
                        //alignment: Alignment.center,
                        height: 245,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildButton(
                                '매칭', selectedIndex, 1, context, memberDetails),
                            SizedBox(
                              width: 20,
                            ),
                            buildButton(
                                '채팅', selectedIndex, 2, context, memberDetails),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 100,
                      alignment: Alignment.topRight,
                    ),
                  ],
                ),
              ))
        ],
      ),
      Positioned(
        top: MediaQuery.of(context).size.height / 15,
        right: 0,
        child: Container(
          height: 150,
          width: 150,
          child: Text('캐릭터/일러스트'),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    ]),
  );
}

Widget buildButton(String _title, int selectedIndex, int index,
    BuildContext context, memberDetails) {
  return MaterialButton(
    minWidth: 165,
    height: 245,
    elevation: 3.0,
    highlightElevation: 1.0,
    onPressed: () {
    },
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(25),
    ),
    color: Colors.white,
    textColor: Colors.black,
    child: Column(
      children: [
        SizedBox(
          height: 40,
        ),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(54),
          ),
          width: 108,
          height: 108,
        ),
        SizedBox(
          height: 40,
        ),
        Text(
          _title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    ),
  );
}

