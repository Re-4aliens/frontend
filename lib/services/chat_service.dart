import 'dart:convert';
import 'package:aliens/models/chat_room_model.dart';
import 'package:http/http.dart' as http;
import 'package:stomp_dart_client/stomp_config.dart';
import 'api_service.dart';
import 'package:aliens/models/message_model.dart';
import 'dart:async';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class ChatService extends APIService {
  static late StompClient stompClient;
  static bool isConnected = false;

  static final StreamController<MessageModel> _messageController =
      StreamController<MessageModel>.broadcast();
  static Stream<MessageModel> get messageStream => _messageController.stream;

  static final StreamController<int> _readReceiptController =
      StreamController<int>.broadcast();
  static Stream<int> get readReceiptStream => _readReceiptController.stream;

  static late int roomIdToSubscribe;
  static late int memberId;

  /*
    
    웹소켓 연결 요청

  */
  static Future<void> connectWebSocket(int roomId, int id) async {
    var url = '$domainUrl/ws';
    roomIdToSubscribe = roomId;
    memberId = id;

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    stompClient = StompClient(
      config: StompConfig.SockJS(
        url: url,
        onConnect: onStompConnect,
        beforeConnect: () async {
          print('연결 대기 중...');
          await Future.delayed(const Duration(milliseconds: 200));
          print('연결 중...');
        },
        onWebSocketError: (dynamic error) => print('WebSocket Error: $error'),
        onStompError: (StompFrame frame) => print('STOMP Error: ${frame.body}'),
        onDisconnect: (frame) => print('Disconnected: ${frame.body}'),
        onWebSocketDone: () => print('WebSocket Closed'),
        stompConnectHeaders: {
          'Authorization': jwtToken,
        },
        webSocketConnectHeaders: {
          'Authorization': jwtToken,
        },
      ),
    );

    stompClient.activate();
  }

  static void onStompConnect(StompFrame frame) {
    print('STOMP 연결 성공');
    isConnected = true;
    subscribeWebSocket(roomIdToSubscribe, memberId);
  }

  /*
    
    웹소켓 구독 요청

  */
  static Future<void> subscribeWebSocket(int roomId, int memberId) async {
    if (isConnected) {
      stompClient.subscribe(
        destination: '/room/$roomId',
        callback: (StompFrame frame) {
          if (frame.body != null) {
            Map<String, dynamic> messageJson = json.decode(frame.body!);
            if (messageJson.containsKey('readBy')) {
              /*
  
                구독 후 읽음 처리 메시지 수신
  
              */
              print("읽음처리 수신");
              int readBy = messageJson['readBy'];
              _readReceiptController.add(readBy);
            } else {
              /*
  
                구독 후 메시지 수신
  
              */
              print("메시지 수신");

              if (messageJson.containsKey('sendTime') &&
                  messageJson['sendTime'] is int) {
                int sendTimeInt = messageJson['sendTime'];
                DateTime sendTimeDateTime =
                    DateTime.fromMillisecondsSinceEpoch(sendTimeInt);
                messageJson['sendTime'] = sendTimeDateTime.toIso8601String();
              }

              print(messageJson);

              MessageModel message = MessageModel.fromJson(messageJson);
              _messageController.add(message);
            }
          }
        },
      );
      ChatService.sendReadRequest(roomId, memberId);
    }
  }

  /*
    
    웹소켓 연결 해제

  */
  static void disconnectWebSocket() {
    if (isConnected) {
      stompClient.deactivate();
      isConnected = false;
      print('WebSocket disconnected.');
    }
  }

  /*

    메시지 전송 요청

  */
  static void sendMessage(MessageModel message) {
    if (isConnected) {
      Map<String, dynamic> request = {
        'type': message.type,
        'content': message.content,
        'roomId': message.roomId,
        'senderId': message.senderId,
        'receiverId': message.receiverId,
      };

      stompClient.send(
        destination: '/chat/send',
        body: json.encode(request),
        headers: {'content-type': 'application/json'},
      );
      print('Message sent: $request');
    } else {
      print('WebSocket is not connected.');
    }
  }

  /*
   
    읽음 처리 요청

  */
  static void sendReadRequest(int roomId, int memberId) async {
    print("읽음 처리 요청");
    if (isConnected) {
      Map<String, dynamic> readRequest = {
        'roomId': roomId,
        'memberId': memberId,
      };

      stompClient.send(
        destination: '/chat/read',
        body: json.encode(readRequest),
        headers: {'content-type': 'application/json'},
      );
      print('Read receipt sent: $readRequest');
    } else {
      print('읽음 처리 요청 WebSocket is not connected.');
    }
  }

  /*

    메시지 조회

   */
  static Future<List<MessageModel>> getMessages(roomId) async {
    var url = '$domainUrl/chat/room/$roomId/messages';

    print("메시지 조회 $roomId");

    //토큰 읽어오기
    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
      },
    );

    //success
    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      List<dynamic> items = body['result'];
      print(items);
      print("메시지 조회 성공");
      return items.map((dynamic item) => MessageModel.fromJson(item)).toList();

      //fail
    } else {
      print(json.decode(utf8.decode(response.bodyBytes)));
      throw Exception('요청 오류');
    }
  }

  /* 

    채팅방 요약 정보 조회

  */
  static Future<ChatData> getChatSummary() async {
    var url = '$domainUrl/chat/summaries';

    //토큰 읽어오기
    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    var response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': jwtToken,
      },
    );

    //success
    if (response.statusCode == 200) {
      final responseBody = json.decode(utf8.decode(response.bodyBytes));

      return ChatData.fromJson(responseBody['result']);

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
