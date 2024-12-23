import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app_driver/functions/custom_time_functions.dart';

class TransactionModal {
  String amount;
  String action;
  String bookingRef;
  String time;
  String docId;
  String text;

  TransactionModal(
      {required this.amount,
      required this.action,
      required this.bookingRef,
      required this.time,
      required this.docId,
      required this.text});

  factory TransactionModal.fromJson(Map json) {
    return TransactionModal(
      amount: json['amount'].toString(),
      action: json['action'],
      bookingRef: json['bookingRef'],
      time: CustomTimeFunctions.formatDateIndayDateMonthAtTime(
          (json['time'] as Timestamp).toDate()),
      docId: json['docId'],
      text: json['text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['action'] = action;
    data['bookingRef'] = bookingRef;
    data['time'] = time;
    data['docId'] = docId;
    data['text'] = text;
    return data;
  }
}
