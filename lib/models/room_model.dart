class RoomFields {
  static const String roomState = 'roomState';
  static const String roomId = 'roomId';
  static const String partnerId = 'partnerId';
  static const String myId = 'myId';
}

class RoomModel {
  String? roomState;
  int? roomId;
  int? partnerId;
  int? myId;

  RoomModel({this.roomState, this.roomId, this.partnerId, this.myId});

  RoomModel.fromJson(Map<String, dynamic> json) {
    roomState = json['roomState'];
    roomId = json['roomId'];
    partnerId = json['partnerId'];
    myId = json['myId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['roomState'] = roomState;
    data['roomId'] = roomId;
    data['partnerId'] = partnerId;
    data['myId'] = myId;
    return data;
  }
}
