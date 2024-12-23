import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app_driver/constants/language_en.dart';
import 'package:connect_app_driver/constants/types/message_type.dart';
import 'package:connect_app_driver/services/firebase_services/firebase_cloud_messaging_v1.dart';
import '../../constants/global_data.dart';
import '../../functions/print_function.dart';
import '../../modal/chat_modal.dart';
import 'firebase_collections.dart';

class FirebaseChatServices {
  static String getSessionId(String userId, String bookingId) {
    if (userData!.userId.hashCode > userId.hashCode) {
      return '${userId}_${bookingId}_${userData!.userId}';
    } else {
      return '${userData!.userId}_${bookingId}_$userId';
    }
  }

  Stream<QuerySnapshot> getUnreadChatCount() {
    return FirebaseCollections.chatsCollection
        .where('users', arrayContains: userData!.userId)
        .where('unreadCount_${userData!.userId}', isGreaterThan: 0)
        .snapshots();
  }

  markMessagesAsRead(String userId, String bookingId) async {
    await FirebaseCollections.chatsCollection
        .doc(getSessionId(userId, bookingId))
        .update({'unreadCount_${userData!.userId}': 0});
  }

  Stream<QuerySnapshot> getIndividualChatStream(
      String userId, String bookingId) {
    return FirebaseCollections.chatsCollection
        .doc(getSessionId(userId, bookingId))
        .collection('messages')
        .where("visibleTo", arrayContains: userData!.userId)
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  sendMessage(ChatModal message,
      {required Map otherUserObject,
      required bool isBlocked,
      required bool alreadyMessaged,
      required String bookingId,
      ChatMessageType messageType = ChatMessageType.text,
      List deviceIdList = const []}) async {
    Map<String, dynamic> users = {
      "users": [
        message.from,
        message.to,
      ],
      'lastMessage': message.message,
      'lastMessageType': message.messageType,
      'updatedAt': message.createdAt,
      message.from: userData!.fullData,
      message.to: otherUserObject,
      "bookingId": bookingId
      // "unreadCount_${message.to}": ///unread count get karke plus karna he
    };
    users['unreadCount_${message.to}'] = FieldValue.increment(1);
    // users['${message.to}']['unreadCount'] = FieldValue.increment(1);
    myCustomPrintStatement('dlkfsl ${users['${message.to}']['unreadCount']}');

    try {
      await FirebaseCollections.chatsCollection
          .doc(getSessionId(message.to, bookingId))
          .update(users);
      myCustomPrintStatement('chatddddddddddddddd');
    } catch (e) {
      myCustomPrintStatement('Error in catch block $e');
      await FirebaseCollections.chatsCollection
          .doc(getSessionId(message.to, bookingId))
          .set(users);
    }
    await FirebaseCollections.chatsCollection
        .doc(getSessionId(message.to, bookingId))
        .collection('messages')
        .add(message.toJson());

    if (deviceIdList.isNotEmpty && !alreadyMessaged) {
      myCustomLogStatements("kkkkkkkkkkkkk::::::::${deviceIdList}");

      try {
        FirebaseCloudMessagingV1()
            .sendPushNotificationsWithFirebaseCollectInsertion(
                deviceIds: deviceIdList,
                data: {
                  "screen": "new_messsage",
                  "bookingId": bookingId,
                },
                otherDetails: {
                  "bookingId": bookingId,
                  "sessionId": getSessionId(message.to, bookingId)
                },
                body: translate(
                        "CUSTOMER_NAME has started messaging you regarding booking #bookingId.")
                    .replaceFirst("CUSTOMER_NAME", userData!.fullName)
                    .replaceAll('#bookingId', ''),
                title: translate("Chat Started"),
                reciverUserId: message.to);
      } catch (e) {
        myCustomPrintStatement(
            "kskkcnknckncksnkcnks::::::::::::::::::::::${e}");
      }
    }
  }

  static getNotificationMessage(ChatModal message) {
    switch (message.messageType) {
      case MessageType.image:
        {
          return 'Sent you an image';
        }
      case MessageType.video:
        {
          return 'Sent you a video';
        }
      case MessageType.location:
        {
          return 'Sent you a location';
        }
      case MessageType.voiceMessage:
        {
          return 'Sent you an voice message';
        }
      default:
        {
          return message.message;
        }
    }
  }

  static getNotificationMessageNew(String messageType, String message) {
    switch (messageType) {
      case MessageType.image:
        {
          return 'Sent you an image';
        }
      case MessageType.video:
        {
          return 'Sent you a video';
        }
      case MessageType.location:
        {
          return 'Sent you a location';
        }
      case MessageType.voiceMessage:
        {
          return 'Sent you an voice message';
        }
      default:
        {
          return message;
        }
    }
  }

  deleteMessage({
    required ChatModal message,
    required String messageId,
    required String bookingId,
  }) async {
    String userId =
        message.from == userData!.userId ? message.to : message.from;
    myCustomPrintStatement(
        'Deleting message $messageId for ${userData!.userId}');
    DocumentSnapshot documentSnapshot = await FirebaseCollections
        .chatsCollection
        .doc(getSessionId(userId, bookingId))
        .collection('messages')
        .doc(messageId)
        .get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    List visibleTo = data['visibleTo'];
    if (visibleTo.contains(userData!.userId)) {
      visibleTo.remove(userData!.userId);
      if (visibleTo.isEmpty) {
        documentSnapshot.reference.delete();
        myCustomPrintStatement('The message is deleted...removed document');
      } else {
        data['visibleTo'] = visibleTo;
        documentSnapshot.reference.update(data);
        myCustomPrintStatement('The message is deleted...removed user id');
      }
    }
  }

  ///commented to check
// Future<bool> isUserFree()async{
//
//   var snapshots = await FirebaseCollections.gameSession.where('users', arrayContains: userData!.userId).get();
//   if(snapshots.docs.isEmpty){
//     return true;
//   }else{
//     for(int i=0; i<snapshots.docs.length;i++){
//
//       myCustomPrintStatement('the date time is ${(snapshots.docs[i].data() as Map)['startTime'].runtimeType}');
//       // DateTime timeStart = DateTime.parse((snapshots.docs[i].data() as Map)['startTime'].toString());
//
//       DateTime timeStart = ((snapshots.docs[i].data() as Map)['startTime'] as Timestamp).toDate();
//       if(DateTime.now().difference(timeStart).inSeconds>10 && (snapshots.docs[i].data() as Map)['allUsersJoined']!=true){
//         FirebaseCollections.gameSession.doc((snapshots.docs[i].id)).delete();
//       }
//     }
//   }
//   return false;
// }
}

Map data = {
  // for players 28 and 5
  'hostId': 28,
  'turn': 5,
  'users': [28, 5],
  'startAnimation': false,
  'truth': null,
  'dare': null,
  // 'selected_option': 1,2: 1 truth, 2 dare
};
