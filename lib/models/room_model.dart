import 'package:uuid/uuid.dart';

class RoomFields {
  static final String roomState = 'roomState';
  static final String roomId = 'roomId';
  static final String partnerId = 'partnerId';
  static final String myId = 'myId';
}

class RoomModel {
  String? roomState;
  int? roomId;
  int? partnerId;
  int? myId;

  RoomModel(
      { this.roomState,
       this.roomId,
       this.partnerId,
       this.myId});

  RoomModel.fromJson(Map<String, dynamic> json) {
    roomState = json['roomState'];
    roomId = json['roomId'];
    partnerId = json['partnerId'];
    myId = json['myId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roomState'] = this.roomState;
    data['roomId'] = this.roomId;
    data['partnerId'] = this.partnerId;
    data['myId'] = this.myId;
    return data;
  }
}
