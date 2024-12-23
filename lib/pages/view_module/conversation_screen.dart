// ignore_for_file: deprecated_member_use, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app_driver/modal/chat_modal.dart';
import 'package:connect_app_driver/modal/user_modal.dart';
import 'package:connect_app_driver/provider/chat_provider.dart';
import 'package:connect_app_driver/services/firebase_services/firebase_chat_services.dart';
import 'package:connect_app_driver/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:connect_app_driver/constants/global_data.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/my_colors.dart';
import '../../constants/my_image_url.dart';
import '../../constants/sized_box.dart';
import '../../widget/app_specific/conversation_card.dart';
import '../../widget/custom_appbar.dart';
import '../../widget/custom_scaffold.dart';
import '../../widget/custom_text_field.dart';

class ConversationScreen extends StatefulWidget {
  final UserModal userModal;
  final String bookingId;

  const ConversationScreen(
      {super.key, required this.userModal, required this.bookingId});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messageController = TextEditingController();
  Stream<List<DocumentSnapshot>>? _messagesStream;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var chatPro = Provider.of<ChatProvider>(context, listen: false);
      chatPro.messages = [];
      chatPro.notifyListeners();
      _messagesStream =
          chatPro.getMessagesStream(widget.userModal, widget.bookingId);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(
        isBackIcon: true,
        bottomCurve: false,
        title: SizedBox(
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(widget.userModal.profileImage!),
              ),
              hSizedBox,
              CustomText.appbarText(
                widget.userModal.fullName,
              )
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                var url = "tel: +${widget.userModal.phoneWithCode}";
                if (await canLaunch(url)) {
                  await launch(url);
                }
              },
              icon: Image.asset(
                MyImagesUrl.phone,
                width: 30,
                color: MyColors.whiteColor,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert,
                  size: 22, color: MyColors.whiteColor))
        ],
      ),
      body: Column(
        children: [
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) => StreamBuilder(
                stream: _messagesStream,
                builder: (context, snapshot) {
                  FirebaseChatServices().markMessagesAsRead(
                      widget.userModal.userId, widget.bookingId);
                  if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                    chatProvider.messages = List.generate(
                      snapshot.data!.length,
                      (index) => ChatModal.fromJson(
                          snapshot.data![index].data() as Map,
                          snapshot.data![index].id),
                    ).reversed.toList();
                  }
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                      itemCount: chatProvider.messages.length,
                      reverse: true,
                      itemBuilder: (context, index) => ConversationMessageCard(
                          messageAlignment: chatProvider.messages[index].from !=
                                  userData!.userId
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          chatMessage: chatProvider.messages[index],
                          messagesBgColor: chatProvider.messages[index].from ==
                                  userData!.userId
                              ? MyColors.lightWhiteColor
                              : MyColors.whiteColor,
                          messagesTextStyle: TextStyle(
                            color: chatProvider.messages[index].from ==
                                    userData!.userId
                                ? MyColors.whiteColor
                                : MyColors.blackColor,
                            fontSize: 13,
                          )),
                    ),
                  );
                }),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: globalHorizontalPadding),
                  child: CustomTextField(
                    verticalPadding: 10,
                    borderColor: Colors.transparent,
                    fillColor: MyColors.whiteColor,
                    textColor: MyColors.blackColor,
                    hintColor: const Color(0xFF7A7A7A),
                    controller: messageController,
                    borderRadius: 30,
                    obscureText: false,
                    hintText: "Type a message...",
                    suffix: Padding(
                      padding: const EdgeInsets.all(12),
                      child: InkWell(
                        onTap: () {
                          var chatPro =
                              Provider.of<ChatProvider>(context, listen: false);

                          if (messageController.text.trim().isNotEmpty) {
                            ChatModal message = ChatModal(
                              from: userData!.userId,
                              to: widget.userModal.userId,
                              message: messageController.text,
                              messageType: ChatMessageType.text.name,
                              likedBy: [],
                              visibleTo: [
                                widget.userModal.userId,
                                userData!.userId
                              ],
                              createdAt: Timestamp.now(),
                            );
                            FirebaseChatServices().sendMessage(message,
                                otherUserObject: widget.userModal.fullData,
                                isBlocked: false,
                                alreadyMessaged: chatPro.messages.isNotEmpty,
                                bookingId: widget.bookingId,
                                deviceIdList: widget.userModal.deviceTokens);
                            messageController.clear();
                          }
                        },
                        child: Image.asset(
                          MyImagesUrl.send,
                          color: MyColors.blackColor,
                          width: 23,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
