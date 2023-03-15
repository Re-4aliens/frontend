import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SettingEditPage extends StatefulWidget {
  const SettingEditPage({super.key});

  @override
  State<SettingEditPage> createState() => _SettingEditPageState();
}

class _SettingEditPageState extends State<SettingEditPage> {
  @override
  Widget build(BuildContext context) {
    var memberDetails = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
        ),
        title: Text(
          '프로필 변경하기',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Color(0xffA8A8A8),
                              borderRadius: BorderRadius.circular(40)),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 30,
                              width: 30,
                              child: FloatingActionButton(
                                backgroundColor: Colors.white,
                                onPressed: () {

                                },
                                child: Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                            bottom:
                            BorderSide(width: 1.0, color: Color(0xFF6a6a6a))),
                      ),
                      child: Text(
                        '사진 변경하기',
                        style: TextStyle(
                          color: Color(0xFF6a6a6a),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                //color: Colors.green.shade200
              ),
              child: ListView(
                children: [
                  for(int i = 0; i <4; i++)
                    buildInfoList(i, memberDetails),
                  ],
              ),
            ),
          ),
        ],
      )
    );
  }

  Widget buildInfoList(index, memberDetails) {
    List infoList = [
      'MBTI',
      '성별',
      '국적',
      '언어 재설정',
    ];

    List memberInfo = [
      memberDetails.member.mbti.toString(),
      memberDetails.member.gender.toString(),
      memberDetails.member.nationality.toString(),
    ];

    List navigatorList = [
      '/edit',
      '/edit',
      '/edit',
      '/edit'
    ];

    return ListTile(
      minVerticalPadding: 28,
      onTap: () {
        if(index == 3)
          Navigator.pushNamed(context, navigatorList.elementAt(index));
      },
      title: Row(
        children: [
          Text(
            '${infoList.elementAt(index)}',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Expanded(child: Container()),
          if (index == 0)
            Row(
              children: [
                Text(
                  '${memberInfo.elementAt(index)}',
                  style: TextStyle(fontSize: 16, color: Color(0xff717171)),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Color(0xff4d4d4d),
                  ),
                ),
              ],
            )
          else if (0 < index && index < 3)
            Text(
              '${memberInfo.elementAt(index)}',
              style: TextStyle(fontSize: 16, color: Color(0xff717171)),
            )
          else
            Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: Color(0xff4d4d4d),
            ),
        ],
      ),
    );
  }

}
