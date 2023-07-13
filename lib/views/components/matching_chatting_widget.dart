import 'dart:io';

import 'package:aliens/models/chatRoom_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/views/pages/chatting/chatting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../apis.dart';

class matchingChattingWidget extends StatefulWidget {
  const matchingChattingWidget({super.key, required this.screenArguments});

  final ScreenArguments screenArguments;

  @override
  State<StatefulWidget> createState() => _matchingChattingWidgetState();
}

class _matchingChattingWidgetState extends State<matchingChattingWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffF5F7FF),
      ),
      child: ListView.builder(
          itemCount: widget.screenArguments.partners?.length,
          itemBuilder: (context, index) {
            return chatList(context, index);
          }),
    );
  }

  Widget chatList(context, index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: MaterialButton(
        minWidth: 350,
        height: 77,
        padding: EdgeInsets.symmetric(horizontal: 12),
        elevation: 0.0,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChattingPage(
                  applicant: widget.screenArguments.applicant,
                  partner: widget.screenArguments.partners![index],
                  memberDetails: widget.screenArguments.memberDetails!,
                )),
          );

          /*
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChattingPage(applicant: widget.screenArguments.applicant, partner: _partner, chatRoom: chatRoom,)),
          );

           */
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                'assets/icon/icon_profile.svg',
                height: 45,
                color: Color(0xff7898ff),
              ),
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(
                left: 10,
                top: 10,
                bottom: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.screenArguments.partners![index].name!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '00:00',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff888888),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '마지막 메세지',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xffA4A4A4),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
