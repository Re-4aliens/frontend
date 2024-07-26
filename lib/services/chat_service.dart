import 'dart:convert';
import 'package:aliens/models/chat_room_model.dart';
import 'package:http/http.dart' as http;
import 'package:stomp_dart_client/stomp_config.dart';
import 'api_service.dart';
import 'package:aliens/models/message_model.dart';
import 'dart:async';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:aliens/repository/sql_message_repository.dart';

class ChatService extends APIService {
  static late StompClient stompClient;
  static bool isConnected = false;

  static final StreamController<MessageModel> _messageController =
      StreamController<MessageModel>.broadcast();
  static Stream<MessageModel> get messageStream => _messageController.stream;

  static final StreamController<int> _readReceiptController =
      StreamController<int>.broadcast();
  static Stream<int> get readReceiptStream => _readReceiptController.stream;

  static Set<int> subscribedChannels = {};

  /*
    
    구독 목록 불러오기

  */
  static Future<void> loadSubscriptions() async {
    List<int> subscriptions = await SqlMessageRepository.getSubscriptions();
    subscribedChannels.addAll(subscriptions);
  }

  /*
    
    웹소켓 연결 요청

  */
  static Future<void> connectWebSocket() async {
    var url = '$domainUrl/ws';

    var jwtToken = await APIService.storage.read(key: 'token') ?? '';

    stompClient = StompClient(
      config: StompConfig(
        url: url,
        onConnect: onStompConnect,
        onWebSocketError: (dynamic error) => print('WebSocket Error: $error'),
        onStompError: (StompFrame frame) => print('STOMP Error: ${frame.body}'),
        onDisconnect: (frame) => print('Disconnected: ${frame.body}'),
        onWebSocketDone: () => print('WebSocket Closed'),
        stompConnectHeaders: {
          'Authorization': jwtToken,
        },
      ),
    );

    stompClient.activate();
  }

  static void onStompConnect(StompFrame frame) {
    print('STOMP 연결 성공');
    loadSubscriptions();
    isConnected = true;
  }

  /*
    
    웹소켓 구독 요청

  */
  static Future<void> subscribeWebSocket(int roomId) async {
    if (isConnected && !subscribedChannels.contains(roomId)) {
      stompClient.subscribe(
        destination: '/room/$roomId',
        callback: (StompFrame frame) {
          if (frame.body != null) {
            print('Received message from room $roomId: ${frame.body}');

            Map<String, dynamic> messageJson = json.decode(frame.body!);
            if (messageJson.containsKey('readBy')) {
              /*
  
              구독 후 읽음 처리 메시지 수신
  
            */
              int readBy = messageJson['readBy'];
              _readReceiptController.add(readBy);
            } else {
              /*
  
              구독 후 메시지 수신
  
            */
              MessageModel message = MessageModel.fromJson(messageJson);
              _messageController.add(message);
            }
          }
        },
      );
      subscribedChannels.add(roomId);
      await SqlMessageRepository.addSubscription(roomId);
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
      print('WebSocket is not connected.');
    }
  }

  /*

    메시지 조회

   */
  static Future<List<MessageModel>> getMessages(roomId) async {
    var url = '$domainUrl/chat/room/$roomId/messages';

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
      List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      return body.map((dynamic item) => MessageModel.fromJson(item)).toList();
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
