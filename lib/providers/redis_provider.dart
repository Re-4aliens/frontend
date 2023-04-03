
import 'package:flutter/material.dart';
import 'package:redis/redis.dart';

/*
class RedisProvider with ChangeNotifier {


  Future<void> readrRedisData() async {

    final redis = RedisConnection();
    Command cmd = await redis.connect('localhost', 6379);
    final pubsub = await PubSub(cmd);
    pubsub.subscribe(['chat']);
    final stream = pubsub.getStream();


    try{
      const url = 'https://ac14b376-0180-4ad0-aa45-948bbb7d12df.mock.pstmn.io';//mocksever
      var response = await http.get(Uri.parse(url));

      //success
      if (response.statusCode == 200) {

        //코드 200 확인 후 재요청
        var _response = await http.get(Uri.parse(url+'/member'));

        if (_response.statusCode == 200){
          member = Member.fromJson(json.decode(_response.body));
        }
        else {
          //오류 생기면 바디 확인
          print(_response.body);
        }

        //fail
      } else {
        //오류 생기면 바디 확인
        print(response.body);
      }
    }catch(error){
      return null;
    }
    //변경되었다고 알리기
    notifyListeners();
    return member;
  }




}

*/
