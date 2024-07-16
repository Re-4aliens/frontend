import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'package:aliens/models/message_model.dart';
import 'package:aliens/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:web_socket_channel/io.dart';
import 'package:aliens/repository/sql_message_repository.dart';
import 'package:aliens/models/partner_model.dart';
import 'package:aliens/models/member_details_model.dart';

class ChatService extends APIService {
  static late IOWebSocketChannel sendChannel;
  static late IOWebSocketChannel readChannel;
  static late IOWebSocketChannel bulkReadChannel;

  static List<Map> requestBuffer = [];

  static Future<String> getChatToken() async {
    // Your implementation to get chat token
    return 'chatToken';
  }

  static Future<void> connectWebSocket(Partner partner,
      MemberDetails memberDetails, Function updateUi, Function setState) async {
    String chatToken = '';
    try {
      chatToken = await getChatToken();
    } catch (e) {
      print(e);
      if (e == "AT-C-002") {
        await AuthService.getAccessToken();
        chatToken = await getChatToken();
      }
    }

    final wsUrl = Uri.parse('ws://3.34.2.246:8081/ws/chat/message/send');
    final wsReadUrl = Uri.parse('ws://3.34.2.246:8081/ws/chat/message/read');
    final wsAllReadUrl = Uri.parse('ws://3.34.2.246:8081/ws/chat/room/read');
    var header = {'Authorization': chatToken};
    sendChannel = IOWebSocketChannel.connect(wsUrl, headers: header);
    readChannel = IOWebSocketChannel.connect(wsReadUrl, headers: header);
    bulkReadChannel = IOWebSocketChannel.connect(wsAllReadUrl, headers: header);

    sendBulkReadRequest(partner);

    sendChannel.stream.listen((message) async {
      messageSendResponseHandler(
          message, partner, memberDetails, updateUi, setState);
    }, onError: (error) {
      print('Error: $error');
    }, onDone: () {
      print('WebSocket connection closed');
    });

    readChannel.stream.listen((message) async {
      readResponseHandler(message, setState);
    }, onError: (error) {
      print('Error: $error');
    }, onDone: () {
      print('WebSocket connection closed');
    });

    bulkReadChannel.stream.listen((message) async {
      bulkReadResponseHandler(message, setState);
    }, onError: (error) {
      print('Error: $error');
    }, onDone: () {
      print('WebSocket connection closed');
    });
  }

  static void sendMessage(Map<String, dynamic> request) async {
    sendChannel.sink.add(json.encode(request));
    requestBuffer.add(request);
  }

  static void sendVSMessage(Map<String, dynamic> request) async {
    sendChannel.sink.add(json.encode(request));
    requestBuffer.add(request);
  }

  static void sendReadRequest(RemoteMessage message) async {
    print('단일 읽음처리');
    Map<String, dynamic> request = {
      'requestId': DataUtils.makeUUID(),
      'chatId': message.data['chatId'],
      'roomId': message.data['roomId'],
    };
    readChannel.sink.add(json.encode(request));
  }

  static void sendBulkReadRequest(Partner partner) async {
    Map<String, dynamic> request = {
      'requestId': DataUtils.makeUUID(),
      'partnerId': partner.memberId,
      'roomId': partner.roomId,
    };
    bulkReadChannel.sink.add(json.encode(request));
  }

  static void messageSendResponseHandler(message, Partner partner,
      MemberDetails memberDetails, Function updateUi, Function setState) async {
    print('웹소켓 전송 Received response: $message');
    if (json.decode(message)['status'] == 'success') {
      var requestId = json.decode(message)['requestId'];
      var request = requestBuffer
          .firstWhere((element) => element['requestId'] == requestId);

      print(json.decode(message)['chatId']);
      var chat = MessageModel(
          id: json.decode(message)['id'],
          type: request['type'],
          content: request['content'],
          roomId: request['roomId'],
          senderId: request['senderId'],
          receiverId: request['receiverId'],
          sendTime: request['sendTime'],
          isRead: true);
      await SqlMessageRepository.create(chat);
      setState(() {});

      requestBuffer.remove(request);
    }
  }

  static void readResponseHandler(message, Function setState) {
    print('Received response: $message');
    if (json.decode(message)['status'] == 'success') {
      setState(() {});
    }
  }

  static void bulkReadResponseHandler(message, Function setState) async {
    print('bulk read channel Received response: $message');
    if (json.decode(message)['status'] == 'success') {
      setState(() {});
    }
  }

  /*

  메세지 받아오기

   */
  static Future<List<MessageModel>> getMessages(roomId, context) async {
    var url = 'http://3.34.2.246:8081/api/v1/chat/$roomId'; //mocksever

    //토큰 읽어오기
    var jwtToken = await APIService.storage.read(key: 'token');

    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];
    String chatToken = '';
    try {
      chatToken = await getChatToken();
    } catch (e) {
      if (e == "AT-C-002") {
        try {
          await AuthService.getAccessToken();
        } catch (e) {
          if (e == "AT-C-005") {
            //토큰 및 정보 삭제
            await APIService.storage.delete(key: 'auth');
            await APIService.storage.delete(key: 'token');

            //스택 비우고 화면 이동
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          }
        }
        chatToken = await getChatToken();
      }
    }

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
        'ChattingToken': chatToken
      },
    );

    //success
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => MessageModel.fromJson(item)).toList();
      //fail
    } else {
      throw Exception('요청 오류');
    }
  }

  // /*

  //   채팅 토큰 받아오기

  //  */
  // static Future<String> getChatToken() async {
  //   var url = 'http://3.34.2.246:8080/api/v1/chat/token';
  //   //토큰 읽어오기
  //   var jwtToken = await APIService.storage.read(key: 'token');

  //   //accessToken만 보내기
  //   jwtToken = json.decode(jwtToken!)['data']['accessToken'];

  //   var response = await http.get(
  //     Uri.parse(url),
  //     headers: {
  //       'Authorization': 'Bearer $jwtToken',
  //       'Content-Type': 'application/json'
  //     },
  //   );

  //   //success
  //   if (response.statusCode == 200) {
  //     return json.decode(utf8.decode(response.bodyBytes))['data'];

  //     //fail
  //   } else {
  //     if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
  //       // 액세스 토큰 만료
  //       throw 'AT-C-002';
  //     } else if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
  //         'AT-C-007') {
  //       // 로그아웃된 토큰
  //       throw 'AT-C-007';
  //     } else {}

  //     throw Exception('요청 오류');
  //   }
  // }

  /* 

    채팅 정보 받아오기

  */
  static Future<Map<String, dynamic>> getChatSummary(context) async {
    var url = 'http://3.34.2.246:8081/api/v1/chat/summary';
    //토큰 읽어오기
    var jwtToken = await APIService.storage.read(key: 'token');
    //accessToken만 보내기
    jwtToken = json.decode(jwtToken!)['data']['accessToken'];

    String chatToken = '';
    try {
      chatToken = await getChatToken();
    } catch (e) {
      if (e == "AT-C-002") {
        print(e);
        try {
          await AuthService.getAccessToken();
        } catch (e) {
          if (e == "AT-C-005") {
            //토큰 및 정보 삭제
            await APIService.storage.delete(key: 'auth');
            await APIService.storage.delete(key: 'token');

            //스택 비우고 화면 이동
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          }
        }
        chatToken = await getChatToken();
      }
    }

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
        'ChattingToken': chatToken
      },
    );

    //success
    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));

      //fail
    } else {
      if (json.decode(utf8.decode(response.bodyBytes))['code'] == 'AT-C-002') {
        throw 'AT-C-002';
      } else if (json.decode(utf8.decode(response.bodyBytes))['code'] ==
          'AT-C-007') {
        throw 'AT-C-007';
      } else {}
      throw Exception('요청 오류');
    }
  }
}
