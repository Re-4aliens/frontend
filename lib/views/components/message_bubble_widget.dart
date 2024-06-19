import 'package:aliens/models/member_details_model.dart';
import 'package:aliens/models/vs_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final MemberDetails memberDetails;
  final bool showingTime;
  final bool showingPic;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.memberDetails,
    required this.showingTime,
    required this.showingPic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message.chatType == 1) {
      return _vsGameBubble();
    } else {
      if (message.senderId == memberDetails.memberId) {
        return _myBubble();
      } else {
        return _partnerBubble();
      }
    }
  }

  Widget _partnerBubble() {
    return Row(
      children: [
        showingPic
            ? Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SvgPicture.asset(
                  'assets/icon/icon_profile.svg',
                  height: 35,
                  color: const Color(0xff7898ff),
                ),
              )
            : const SizedBox(
                width: 55,
              ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 270, // 최대 너비 지정
              ),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          spreadRadius: 0.5,
                          offset: Offset(0, 3))
                    ]),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                margin: const EdgeInsets.only(
                    top: 10, bottom: 10, right: 5, left: 10),
                child: Text(
                  '${message.chatContent}',
                  style: const TextStyle(
                    color: Color(0xff616161),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                showingTime
                    ? DateFormat('hh:mm aaa')
                        .format(DateTime.parse('${message.sendTime}'))
                    : '',
                style: const TextStyle(
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: Text(
                showingTime
                    ? DateFormat('hh:mm aaa')
                        .format(DateTime.parse('${message.sendTime}'))
                    : '',
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 270, // 최대 너비 지정
              ),
              child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xff7898ff),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          spreadRadius: 0.5,
                          offset: Offset(0, 3))
                    ]),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                margin: const EdgeInsets.only(top: 10, left: 5, right: 25),
                child: Text(
                  '${message.chatContent}',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2, right: 18),
          child: message.unreadCount == 0
              ? const Text('읽음',
                  style: TextStyle(fontSize: 12, color: Color(0xffC1C1C1)))
              : const Text(
                  '읽지않음',
                  style: TextStyle(fontSize: 12, color: Color(0xffC1C1C1)),
                ),
        )
      ],
    );
  }

  Widget _vsGameBubble() {
    String answer1 = '';
    String answer2 = '';
    for (int i = 0; i < vsGames.length; i++) {
      if (vsGames[i]['question'] == message.chatContent) {
        answer1 = vsGames[i]['answer1']!;
        answer2 = vsGames[i]['answer2']!;
        break;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 15),
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
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xff7898FF).withOpacity(0.25)),
                      const BoxShadow(
                        color: Colors.white,
                        offset: Offset(0, -5),
                        blurRadius: 10,
                      )
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        height: 90,
                        padding: const EdgeInsets.only(top: 10),
                        child: Image.asset(
                          'assets/character/vsGame_hands.png',
                        )),
                    const Text(
                      '밸런스 게임',
                      style: TextStyle(color: Color(0xffC4C4C4), fontSize: 12),
                    ),
                    Text(
                      '${message.chatContent}',
                      style: const TextStyle(
                          color: Color(0xff616161),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 90,
                          height: 35,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xff7898ff),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            answer1,
                            style: const TextStyle(color: Color(0xff7898ff)),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            'vs',
                            style: TextStyle(color: Color(0xff7898ff)),
                          ),
                        ),
                        Container(
                          width: 90,
                          height: 35,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xff7898ff),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            answer2,
                            style: const TextStyle(color: Color(0xff7898ff)),
                          ),
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
}
