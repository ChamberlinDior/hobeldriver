// import 'dart:async';
// import 'dart:io';
//
// import 'package:audioplayers/audioplayers.dart';
// import 'package:connect_app_driver/constants/global_data.dart';
// import 'package:connect_app_driver/constants/global_data.dart';
// import 'package:connect_app_driver/constants/global_data.dart';
// import 'package:connect_app_driver/services/file_services.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../constants/types/message_type.dart';
// import '../functions/print_function.dart';
// import '../modal/chat_modal.dart';
// import '../modal/user_modal.dart';
//
// class ChatDetailProvider extends ChangeNotifier {
//   //AudioPlayer playerController = AudioPlayer();
//   //CacheAudioPlayerPlus? playerController;
//
//   AudioPlayer? playerController;
//
//   ValueNotifier<bool> isPlaying = ValueNotifier(false);
//   ValueNotifier<bool> isComplete = ValueNotifier(false);
//   ValueNotifier<int> currentPos = ValueNotifier(0);
//   ValueNotifier<int> maxDuration = ValueNotifier(100);
//   ValueNotifier<String> currentPositionLabel = ValueNotifier("00:00");
//   ValueNotifier<int> messageID = ValueNotifier(0);
//   ValueNotifier<double> setPlaybackRateValue = ValueNotifier(1.0);
//   bool isInit = false;
//   bool isLoad = false;
//
//   void showAudioLoader() {
//     isLoad = true;
//     notifyListeners();
//   }
//
//   void hideLoader() {
//     isLoad = false;
//     notifyListeners();
//   }
//
//   var urlSource;
//   StreamSubscription<Duration>? durationStream;
//   StreamSubscription<Duration>? positionChangeStream;
//   StreamSubscription<PlayerState>? playerStateChangeStream;
//
//   String? selectedCopyText;
//
//   void init() {
//     playerController = AudioPlayer();
//
//     durationStream = playerController?.onDurationChanged.listen((Duration? d) {
//       maxDuration.value = d?.inMilliseconds ?? 0;
//     });
//
//     positionChangeStream =
//         playerController?.onPositionChanged.listen((Duration p) async {
//           currentPos.value = p.inMilliseconds;
//           int sHours = Duration(milliseconds: currentPos.value).inHours;
//           int sMinutes = Duration(milliseconds: currentPos.value).inMinutes;
//           int sSeconds = Duration(milliseconds: currentPos.value).inSeconds;
//           int rHours = sHours;
//           int rMinutes = sMinutes - (sHours * 60);
//           int rSeconds = sSeconds - (sMinutes * 60 + sHours * 60 * 60);
//           currentPositionLabel.value =
//           "${(rHours <= 9) ? '0$rHours' : '$rHours'}:${(rMinutes <= 9) ? '0$rMinutes' : '$rMinutes'}:${(rSeconds <= 9) ? '0$rSeconds' : '$rSeconds'}";
//         });
//
//     playerStateChangeStream =
//         playerController?.onPlayerStateChanged.listen((event) async {
//           if (event == PlayerState.completed) {
//             await playerController?.pause();
//             isComplete.value = true;
//             isPlaying.value = false;
//             currentPos.value = 0;
//             currentPositionLabel.value = "00:00:00";
//           }
//         });
//   }
//
//   Future<void> unsetAll() async {
//     await playerController?.pause();
//     //playerController.seek(const Duration(milliseconds: 0));
//     isPlaying.value = false;
//     isComplete.value = false;
//     currentPos.value = 0;
//     maxDuration.value = 100;
//     currentPositionLabel.value = '00:00';
//     messageID.value = '';
//     //urlSource = null;
//   }
//
//   bool usersLoad = false;
//   List<QueryDocumentSnapshot> users = [];
//   List<QueryDocumentSnapshot> copyData = [];
//   bool isLastUser = false;
//   QuerySnapshot<Object?>? usersSnap;
//
//   getChatUsersList({int? offset}) async {
//     if (offset == null) {
//       usersLoad = true;
//     }
//     notifyListeners();
//
//     if (offset == null) {
//       usersSnap = null;
//       isLastUser = false;
//       notifyListeners();
//       usersSnap = await FirebaseCollections.chatsCollection
//           .where(
//         'users',
//         arrayContains: userDataNotifier.value!.id,
//       )
//           .get();
//     }
//
//     myCustomPrintStatement('the users length is ${usersSnap!.docs.length}');
//     if (offset == null) {
//       users.clear();
//       users = usersSnap?.docs ?? [];
//       copyData = usersSnap?.docs ?? [];
//     } else {
//       users.addAll(usersSnap?.docs ?? []);
//       copyData.addAll(usersSnap?.docs ?? []);
//     }
//     if (offset == null) {
//       usersLoad = false;
//     }
//     notifyListeners();
//   }
//
//   List fileter() {
//     return [];
//   }
//
//   void search({required String v}) {
//     if (v.isEmpty) {
//       users = copyData;
//     } else {
//       List<QueryDocumentSnapshot> tempList = [];
//       for (int i = 0; i < copyData.length; i++) {
//         List temp = ((copyData[i].data() as Map)['users'] as List);
//         myCustomLogStatements('the temp list is $temp');
//         temp.remove(userDataNotifier.value!.id);
//         String otherUserIdd = temp[0].toString();
//         UserModal otherUserModal =
//         UserModal.fromJson((copyData[i].data() as Map)[otherUserIdd]);
//         if (otherUserModal.fullName.toLowerCase().contains(v.toLowerCase())) {
//           tempList.add(copyData[i]);
//         }
//       }
//       users = tempList;
//     }
//     notifyListeners();
//   }
//
//
//
//
//   Map<String, Map<int, ChatModal>> tempChats = {};
//
//   sendMessage({
//     required ChatModal message,
//     required Map otherUserObject,
//     required bool isBlocked,
//     required List deviceIdList,
//   }) async {
//     String chatId = FirebaseChatServices.getSessionId(message.to);
//     ///commented to check 17-5-24
//     int messageId = message.createdAt.millisecondsSinceEpoch;
//     Map<int, ChatModal> innerMap = {};
//     message.fromServer = false;
//     var chats = tempChats[chatId] ?? {};
//     message.id = messageId.toString();
//     chats[messageId] = message;
//     // Map<int, ChatModal> message =
//     tempChats[chatId] = chats;
//     notifyListeners();
//     if (message.messageType == MessageType.image) {
//       message.progress = ValueNotifier(0);
//       // var uploadTask = FirebaseService().uploadImageAndGetSnapshotStream(message.message);
//
//       File f = File(message.message);
//       var ref = FirebaseService().getFileReference(path: f.path);
//       var uploadTask = ref.putFile(f);
//       var stream = uploadTask.snapshotEvents;
//       stream.listen((event) async {
//         innerMap = tempChats[chatId] ?? {};
//         print("ghghghghghghghghghghg${innerMap.containsKey(messageId)}");
//         if (innerMap.containsKey(messageId)) {
//           print('the stream event is listened');
//           message.progress?.value =
//               ((event.bytesTransferred / event.totalBytes) * 100).ceil();
//           print(
//               'the stream event :  ${message.progress?.value}: ${event.bytesTransferred}...Total Bytes: ${event.totalBytes}');
//         } else {
//           await uploadTask.cancel();
//         }
//       });
//       await uploadTask.whenComplete(() async => {
//         // url = uploadTask.storage.
//         message.message = await ref.getDownloadURL(),
//       });
//       print('the stream is ${stream}');
//     } else if (message.messageType == MessageType.video) {
//       // var uploadTask = FirebaseService().uploadImageAndGetSnapshotStream(message.message);
//       print("adtadtdatdatdtadatdtadta::::::::::${message.message}");
//       File f = await FileServices.compressVideo(path: message.message);
//
//       message.message = f.path;
//       print("adtadtdatdatdtadatdtadta::::::::::${message.message}");
//       message.progress = ValueNotifier(0);
//       File t = File(message.thumbnail!);
//       var thumbRef = FirebaseService().getFileReference(path: t.path);
//       var thumbuploadTask = thumbRef.putFile(t);
//       var thumbstream = thumbuploadTask.snapshotEvents;
//
//       thumbstream.listen((event) async {
//         innerMap = tempChats[chatId] ?? {};
//         if (innerMap.containsKey(messageId)) {
//           print('the thumb stream event is listened');
//           print(
//               'the thumb stream event ${event.bytesTransferred}...Total Bytes: ${event.totalBytes}');
//         } else {
//           await thumbuploadTask.cancel();
//         }
//       });
//       await thumbuploadTask.whenComplete(() async => {
//         // url = uploadTask.storage.
//       });
//
//       print('the thumb stream is ${thumbstream}');
//       File v = File(message.message);
//       var ref = FirebaseService().getFileReference(path: v.path);
//       var uploadTask = ref.putFile(v);
//       var stream = uploadTask.snapshotEvents;
//       stream.listen((event) async {
//         innerMap = tempChats[chatId] ?? {};
//         if (innerMap.containsKey(messageId)) {
//           print('the stream event is listened');
//           message.progress?.value =
//               ((event.bytesTransferred / event.totalBytes) * 100).ceil();
//           print(
//               'the stream event :  ${message.progress?.value}: ${event.bytesTransferred}...Total Bytes: ${event.totalBytes}');
//         } else {
//           await uploadTask.cancel();
//         }
//       });
//       await uploadTask.whenComplete(() async => {
//         // url = uploadTask.storage.
//         message.message = await ref.getDownloadURL(),
//       });
//       message.thumbnail = await thumbRef.getDownloadURL();
//       print('the stream is ${stream}');
//       print("voicevoicececececce::::::::::}${message.message}");
//     } else if (message.messageType == MessageType.voiceMessage) {
//       print("voicevoicececececce::::::::::}");
//       message.progress = ValueNotifier(0);
//       // var uploadTask = FirebaseService().uploadImageAndGetSnapshotStream(message.message);
//       File a = File(message.message);
//       var ref = FirebaseService().getFileReference(path: a.path);
//       var uploadTask = ref.putFile(a);
//       var stream = uploadTask.snapshotEvents;
//       stream.listen((event) async {
//         innerMap = tempChats[chatId] ?? {};
//         print("ghghghghghghghghghghg${innerMap.containsKey(messageId)}");
//         if (innerMap.containsKey(messageId)) {
//           print('the stream event is listened');
//           message.progress?.value =
//               ((event.bytesTransferred / event.totalBytes) * 100).ceil();
//           print(
//               'the stream event :  ${message.progress?.value}: ${event.bytesTransferred}...Total Bytes: ${event.totalBytes}');
//         } else {
//           await uploadTask.cancel();
//         }
//       });
//
//       await uploadTask.whenComplete(() async => {
//         // url = uploadTask.storage.
//         message.message = await ref.getDownloadURL(),
//       });
//       print('the stream is ${stream}');
//     }
//     print("voicevoicececececce::::::::::}${message.message}");
//
//     if (message.messageType == MessageType.video ||
//         message.messageType == MessageType.image ||
//         message.messageType == MessageType.voiceMessage) {
//       if (innerMap.containsKey(messageId)) {
//         await FirebaseChatServices().sendMessage(
//           message,
//           otherUserObject: otherUserObject,
//           deviceIdList: deviceIdList,
//           isBlocked: isBlocked,
//         );
//       }
//     } else {
//       await FirebaseChatServices().sendMessage(
//         message,
//         otherUserObject: otherUserObject,
//         deviceIdList: deviceIdList,
//         isBlocked: isBlocked,
//       );
//     }
//
//     myCustomLogStatements('Manish: removing chat id $chatId');
//     myCustomPrintStatement('sfsa ${tempChats[chatId]}');
//
//     tempChats[chatId]?.remove(messageId);
//     myCustomPrintStatement('sfsa  after${tempChats[chatId]}');
//     notifyListeners();
//   }
//
//   List<ChatModal> getChatMessages(String chatId) {
//     var temp = tempChats[chatId];
//     print('the list lengngn ${temp?.length}');
//     return temp?.values.toList() ?? [];
//   }
//
//
//
//   // likeMessage(String messageId, String otherUserId) async {
//   //   var request = {
//   //     MyFirebaseKeys.likedBy: [userDataNotifier.value!.id]
//   //   };
//   //   myCustomLogStatements(
//   //       'sdfkls ${FirebaseChatServices.getSessionId(otherUserId)}.....$request');
//   //   FirebaseCollections.chatsCollection
//   //       .doc(FirebaseChatServices.getSessionId(otherUserId))
//   //       .collection('messages')
//   //       .doc(messageId)
//   //       .update(request);
//   // }
//
//
// }
