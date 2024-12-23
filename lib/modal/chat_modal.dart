// import 'package:do_not_be_lonely/services/firebase_constants_and_services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app_driver/functions/print_function.dart';

class Chat {
  List<ChatModal>? list;

  Chat.fromJson(Map<String, dynamic> json) {}
}

class ChatModal {
  String? id;
  String from;
  String to;
  String message;
  String messageType;
  List visibleTo;
  String? thumbnail;
  int? durationInSeconds;
  Timestamp createdAt;
  List likedBy;
  bool fromServer;
  String? bookingId;
  bool isCached;

  ChatModal({
    this.id,
    required this.from,
    required this.to,
    required this.message,
    required this.messageType,
    required this.visibleTo,
    required this.createdAt,
    required this.likedBy,
    this.thumbnail,
    this.durationInSeconds,
    this.bookingId,
    this.fromServer = true,
    this.isCached = false,
  });

  factory ChatModal.fromJson(Map data, String id, {bool isCachedTemp = false}) {
    myCustomPrintStatement('the chat message is $data');
    Timestamp? t;
    if (data['createdAt'] != null && data['createdAt'] is String) {
      DateTime d = DateTime.parse(data['createdAt']);
      t = Timestamp.fromDate(d);
    }
    return ChatModal(
      id: id,
      from: data['from'],
      to: data['to'],
      message: data['message'],
      messageType: data['messageType'],
      visibleTo: data['visibleTo'],
      createdAt: data['createdAt'] != null && data['createdAt'] is String
          ? t
          : data['createdAt'],
      durationInSeconds: data['durationInSeconds'],
      thumbnail: data['thumbnail'],
      likedBy: data['likedBy'] ?? [],
      fromServer: true,
      isCached: isCachedTemp,
      bookingId: data['bookingId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "from": from,
      "to": to,
      "message": message,
      "messageType": messageType,
      "visibleTo": visibleTo,
      "createdAt": createdAt,
      "likedBy": likedBy,
      "thumbnail": thumbnail,
      "bookingId": bookingId,
      "durationInSeconds": durationInSeconds,
    };
  }
}
