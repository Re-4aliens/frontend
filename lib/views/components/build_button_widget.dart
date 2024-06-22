import 'package:aliens/views/components/matching_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/screen_argument.dart';
import 'chatting_button_widget.dart';

class BuildButton extends StatefulWidget {
  const BuildButton(
      {super.key,
      required this.context,
      required this.screenArguments,
      required this.index,
      required this.clicked});

  final ScreenArguments screenArguments;
  final BuildContext context;
  final bool clicked;
  final int index;

  @override
  State<StatefulWidget> createState() => _BuildButtonState();
}

class _BuildButtonState extends State<BuildButton> {
  bool isClick = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                color: Colors.black26,
                spreadRadius: 1,
                offset: Offset(0, 3),
              ),
            ]),
        child: Material(
          borderRadius: BorderRadius.all(
            const Radius.circular(30).r,
          ),
          child: Ink(
            width: 160.r,
            decoration: BoxDecoration(
              color: widget.index == 0
                  ? const Color(0xffAEC1FF)
                  : const Color(0xffFFB5B5),
              borderRadius: BorderRadius.all(
                const Radius.circular(30).r,
              ),
            ),
            child: InkWell(
              onTap: () {
                //신청하지 않고(블루) 매칭되지 않은 상태(그레이)
                if (widget.screenArguments.status ==
                    'NotAppliedAndNotMatched') {
                  //왼쪽 버튼 클릭 시
                  if (widget.index == 0 && widget.clicked) {
                    //신청으로 넘어감
                    Navigator.pushNamed(context, '/apply',
                        arguments: widget.screenArguments);
                  }
                  //오른쪽 버튼 클릭 시
                  else if (widget.index == 1 && widget.clicked) {
                    //반응 X
                  } else {}
                }

                //신청하지 않고(블루) 매칭된 상태(채팅, 레드)
                else if (widget.screenArguments.status ==
                    'NotAppliedAndMatched') {
                  //왼쪽 버튼 클릭 시
                  if (widget.index == 0 && widget.clicked) {
                    //신청으로 넘어감
                    Navigator.pushNamed(context, '/apply',
                        arguments: widget.screenArguments);
                  }
                  //오른쪽 버튼 클릭 시
                  else if (widget.index == 1 && widget.clicked) {
                    //채팅으로 넘어감
                    Navigator.pushNamed(context, '/done',
                        arguments: widget.screenArguments);
                  } else {}
                }

                //신청했고(그레이) 매칭되지 않은 상태(진행, 레드)
                else if (widget.screenArguments.status ==
                    'AppliedAndNotMatched') {
                  //왼쪽 버튼 클릭 시
                  if (widget.index == 0 && widget.clicked) {
                    //반응 X
                  }
                  //오른쪽 버튼 클릭 시
                  else if (widget.index == 1 && widget.clicked) {
                    //매칭 진행 화면으로 넘어감
                    Navigator.pushNamed(context, '/state',
                        arguments: widget.screenArguments);
                  } else {}
                }

                //신청했고(그레이) 매칭된 상태(채팅, 레드)
                else if (widget.screenArguments.status == 'AppliedAndMatched') {
                  //왼쪽 버튼 클릭 시
                  if (widget.index == 0 && widget.clicked) {
                    //반응 X
                  }
                  //오른쪽 버튼 클릭 시
                  else if (widget.index == 1 && widget.clicked) {
                    //채팅으로 넘어감
                    Navigator.pushNamed(context, '/done',
                        arguments: widget.screenArguments);
                  } else {}
                } else {}
              },
              onTapDown: (TapDownDetails details) {
                setState(() {
                  isClick = true;
                });
              },
              onTapUp: (TapUpDetails details) {
                setState(() {
                  isClick = false;
                });
              },
              borderRadius: BorderRadius.all(
                const Radius.circular(30).r,
              ),
              child: widget.index == 0
                  ? MatchingButton(
                      isClick: isClick,
                      screenArguments: widget.screenArguments,
                    )
                  : ChattingButton(
                      isClick: isClick,
                      screenArguments: widget.screenArguments,
                    ),
            ),
          ),
        ));
  }
}
