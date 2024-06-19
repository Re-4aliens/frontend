import 'package:flutter/material.dart';

class PostBoardPage extends StatefulWidget {
  const PostBoardPage({super.key});

  @override
  State<StatefulWidget> createState() => _PostBoardPageState();
}

class _PostBoardPageState extends State<PostBoardPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('글쓰기'),
      ),
    );
  }
}
