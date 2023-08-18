
import 'dart:async';

import 'package:aliens/views/pages/board/article_writing_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/board_model.dart';
import '../pages/board/article_page.dart';
import 'board_dialog_widget.dart';

class ArticleWidget extends StatefulWidget {

  ArticleWidget({super.key, required this.board, required this.nationCode});

  final Board board;
  final String nationCode;
  @override
  State<StatefulWidget> createState() => _ArticleWidgetState();
}
class _ArticleWidgetState extends State<ArticleWidget>{

  String createdAt = '';

  @override
  void initState() {
    super.initState();

    //
    Timer.periodic(Duration(seconds: 1), (timer) {
      Duration diff = DateTime.now().difference(DateTime.parse('${widget.board.createdAt}'));

      //1분 이하
      if(diff.inSeconds < 60){
        setState(() {
          createdAt = "방금 전";
        });
      }
      //1분 이상 1시간 이하
      else if(diff.inSeconds >= 60 && diff.inMinutes < 60){
        setState(() {
          createdAt = "${diff.inMinutes}분 전";
        });
      }
      else if(diff.inMinutes >= 60 && diff.inHours < 24){

        setState(() {
          createdAt = "${diff.inHours}시간 전";
        });
      }
      else{
        setState(() {
          createdAt = DateFormat('yy.MM.dd').format(DateTime.parse('${widget.board.createdAt}'));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {


    return ListTile(
      //제목
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SvgPicture.asset(
                  'assets/icon/icon_profile.svg',
                  width: 35,
                  color: Color(0xff7898ff),
                ),
              ),
              Text(
                '${widget.board.member!.name}',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                '/',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                '${widget.nationCode}',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18),
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${createdAt}',
                style: TextStyle(
                    fontSize: 16, color: Color(0xffc1c1c1)),
              ),
              InkWell(
                onTap: (){
                  showDialog(context: context, builder: (builder){
                    return BoardDialog(context: context,);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child:
                  Icon(Icons.more_vert, color: Color(0xffc1c1c1)),
                ),
              )
            ],
          )
        ],
      ),

      //내용
      subtitle: Container(
        padding: EdgeInsets.only(left: 15, bottom: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text('${widget.board.title}', style: TextStyle(fontSize: 14, color: Color(0xff444444), fontWeight: FontWeight.bold)),
            ),
            widget.board.imageUrls == null ?
            SizedBox():
            Container(
              height: 100,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.board.imageUrls!.length,
                  itemBuilder: (context, index){
                    return Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Color(0xfff8f8f8),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Icon(Icons.add_photo_alternate_outlined),
                        ),
                      ],
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 25.0),
              child: Text('${widget.board.content}', style: TextStyle(fontSize: 14, color: Color(0xff616161)),),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.thumb_up_alt_sharp,
                    color: Color(0xffc1c1c1),
                    size: 20,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 4, right: 15),
                  child: widget.board.likeCount == 0
                      ? Text('')
                      : Text(
                      '${widget.board.likeCount}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.chat_bubble,
                    color: Color(0xffc1c1c1),
                    size: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                      '${widget.board.commentCount}'),
                ),
              ],
            )
          ],
        ),
      ),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ArticlePage(board: widget.board)),
        );
      },
    );
  }
}