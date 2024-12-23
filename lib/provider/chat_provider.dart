import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app_driver/constants/global_data.dart';
import 'package:connect_app_driver/modal/chat_modal.dart';
import 'package:connect_app_driver/modal/user_modal.dart';
import 'package:connect_app_driver/services/firebase_services/firebase_chat_services.dart';
import 'package:connect_app_driver/services/firebase_services/firebase_collections.dart';
import 'package:flutter/cupertino.dart';

class ChatProvider extends ChangeNotifier {
    List<ChatModal> messages = [];

     Stream<List<DocumentSnapshot>>  getMessagesStream( UserModal userModal,String bookingId) {
    if (messages.isNotEmpty) {
      return FirebaseCollections.chatsCollection
          .doc(FirebaseChatServices.getSessionId(
              userModal.userId, bookingId))
          .collection('messages')
          .where("visibleTo", arrayContains: userData!.userId)
          .where("createdAt", isGreaterThan: messages.first.createdAt)
          .orderBy('createdAt', descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs);
    } else {
      return FirebaseCollections.chatsCollection
          .doc(FirebaseChatServices.getSessionId(
              userModal.userId, bookingId))
          .collection('messages')
          .where("visibleTo", arrayContains: userData!.userId)
          .orderBy('createdAt', descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs);
    }
  }

}