import 'package:aliens/mockdatas/mockdata_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../models/message_model.dart';

class MessageBubble extends StatefulWidget {
  const MessageBubble(
      {super.key, required this.message, required this.applicant, required this.showingTime});

  final MessageModel message;
  final applicant;
  final bool showingTime;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    if(widget.message.messageCategory == 'VS_GAME_MESSAGE')
      return _vsGameBubble();
    else if(widget.message.messageCategory == 'START_MESSAGE')
      return _timeBubble();
    else {
      if(widget.message.senderId == widget.applicant.member.name)
        return _myBubble();
      else
        return _partnerBubble();
    }
  }

  Widget _partnerBubble() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 25),
          child: SvgPicture.asset(
            'assets/icon/icon_profile.svg',
            height: 40,
            color: Color(0xff7898ff),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 270, // 최대 너비 지정
              ),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          spreadRadius: 0.5,
                          offset: const Offset(0, 3))
                    ]),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text(
                  '${widget.message.message}',
                  style: TextStyle(
                    color: Color(0xff616161),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                '시간',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _myBubble() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            widget.showingTime ?
            '${DateFormat('hh:mm a').format(DateTime.now())}' : '',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 270, // 최대 너비 지정
          ),
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xff7898ff),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 0.5,
                      offset: const Offset(0, 3))
                ]),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
            margin: EdgeInsets.only(top: 10, bottom: 10, left: 18, right: 25),
            child: Text(
              '${widget.message.message}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _vsGameBubble() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10, right: 25),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4))
              ],
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: 260,
                height: 195,
                padding: EdgeInsets.only(left: 28),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(color: Color(0xff7898FF).withOpacity(0.25)),
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(-5, -5),
                        blurRadius: 10,
                      )
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 90,
                    ),
                    Text('밸런스 게임', style: TextStyle(color: Color(0xffC4C4C4), fontSize: 12),),
                    Text('하루만 공강을 만들 수 있다면?', style: TextStyle(color: Color(0xff616161), fontSize: 16, fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 90,
                          height: 35,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xff7898ff),),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('월공강', style: TextStyle(color: Color(0xff7898ff)),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text('vs', style: TextStyle(color: Color(0xff7898ff)),),
                        ),
                        Container(
                          width: 90,
                          height: 35,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xff7898ff),),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('금공강', style: TextStyle(color: Color(0xff7898ff)),),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _timeBubble() {
    return Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xff9B9B9B),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(horizontal: 15),
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text('${DateFormat('yyyy/MM/dd').format(DateTime.now())}', style: TextStyle(color: Colors.white),),
          ),
          Text("새로운 대화를 시작합니다.", style: TextStyle(color: Color(0xff717171), fontSize: 12),)
        ],
      );
  }
}
