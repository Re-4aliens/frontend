import 'dart:io';

import 'package:aliens/models/chatRoom_model.dart';
import 'package:aliens/models/screenArgument.dart';
import 'package:aliens/repository/sql_message_database.dart';
import 'package:aliens/views/pages/chatting/chatting_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../apis.dart';
import '../../repository/sql_message_repository.dart';

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
            return Column(
              children: [
                if(index==0)TextButton(onPressed: (){
                  SqlMessageDataBase.instance.deleteDB();
                }, child: Text('DB삭제')),
                chatList(context, index),
              ],
            );
          }),
    );
  }

  Future<String> getCurrentMessage(int index) async {
    return await SqlMessageRepository.getCurrentMessage(
        widget.screenArguments.partners![index].roomId!);
  }

  Future<String> getCurrentTime(int index) async {
    return await SqlMessageRepository.getCurrentTime(
        widget.screenArguments.partners![index].roomId!);
  }

  Future<int> getUnreadChat(int index) async {
    return await SqlMessageRepository.getUnreadChat(
        widget.screenArguments.partners![index].roomId!);
  }

  Widget chatList(context, index) {
    return Padding(
      padding: EdgeInsets.only(right: 25, left: 25, top: 30),
      child: MaterialButton(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        height: 77,
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
          ).then((value) => setState(() {}));
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: SvgPicture.asset(
                'assets/icon/icon_profile.svg',
                height: 50,
                color: Color(0xff7898ff),
              ),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.screenArguments.partners![index].name!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FutureBuilder(
                          future: getCurrentTime(index),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || snapshot.data == '')
                              return Text(
                                '없음',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff888888),
                                ),
                              );
                            else
                              return Text(
                                '${DateFormat('hh:mm aaa').format(DateTime.parse(snapshot.data!))}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff888888),
                                ),
                              );
                          })
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FutureBuilder(
                        future: getCurrentMessage(index),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Text(
                              '없음',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xffA4A4A4),
                              ),
                            );
                          else
                            return Text(
                              '${snapshot.data}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xffA4A4A4),
                              ),
                            );
                        },
                      ),
                      FutureBuilder(
                          future: getUnreadChat(index),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || snapshot.data == 0)
                              return SizedBox(
                                height: 24,
                                width: 24,
                              );
                            else
                              return Container(
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                  color: Color(0xff7898ff),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${snapshot.data}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                          })
                    ],
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
