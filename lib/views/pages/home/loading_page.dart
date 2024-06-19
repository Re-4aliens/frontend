import 'package:flutter/material.dart';
import 'package:aliens/services/matching_service.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FutureBuilder(
          future: MatchingService.getMatchingData(context),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print('Snapshot state: ${snapshot.connectionState}');

            if (snapshot.connectionState == ConnectionState.waiting) {
              // 데이터를 받아오는 중
              print('로딩 중...');
              return Container(
                child: const Image(
                    image: AssetImage("assets/illustration/loading_02.gif")),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              // 데이터를 모두 받아왔을 때
              print('데이터 받아오기 완료  ${snapshot.data.runtimeType}');
              print('Received Data: ${snapshot.data}');
              print('여기꺼지');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/main',
                  (Route<dynamic> route) => false,
                  arguments: snapshot.data,
                );
              });
              return Container(
                child: const Image(
                    image: AssetImage("assets/illustration/loading_02.gif")),
              );
            } else {
              // 에러 발생
              print('에러 발생: ${snapshot.error}');
              return Container(
                child: Text('에러 발생: ${snapshot.error}'),
              );
            }
          },
        ),
      ),
    );
  }
}
