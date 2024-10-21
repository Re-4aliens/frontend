import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotiIschatProvider with ChangeNotifier {
  bool _isInChatRoom = false;

  bool get isInChatRoom => _isInChatRoom;

  void enterChatRoom() {
    _isInChatRoom = true;
    notifyListeners();
  }

  void leaveChatRoom() {
    _isInChatRoom = false;
    notifyListeners();
  }
}
