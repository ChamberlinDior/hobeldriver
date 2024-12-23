import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app_driver/functions/custom_time_functions.dart';

class WithdrawModal {
  String requestedBy;
  String amount;
  String bankId;
  String bicCode;
  String bankName;
  String time;
  String id;
  String bankHolderName;
  String accountNumber;
  String rejecetedReason;
  int requestStatus;
  String docId;

  WithdrawModal(
      {required this.requestedBy,
      required this.amount,
      required this.bankId,
      required this.bankName,
      required this.bicCode,
      required this.time,
      required this.rejecetedReason,
      required this.id,
      required this.bankHolderName,
      required this.accountNumber,
      required this.requestStatus,
      required this.docId});

  factory WithdrawModal.fromJson(Map<dynamic, dynamic> json) {
    return WithdrawModal(
      requestedBy: json['requestedBy'],
      amount: json['amount'].toString(),
      bankId: json['bankId'],
      bicCode: json['bicCode'] ?? '',
      rejecetedReason: json['reason'] ?? '',
      bankName: json['bank_name'] ?? '',
      time: CustomTimeFunctions.formatDayDateMonthAndYear(
          (json['time'] as Timestamp).toDate()),
      id: json['id'],
      bankHolderName: json['account_name'],
      accountNumber: json['ibanAccountNumber'],
      requestStatus: json['requestStatus'],
      docId: json['docId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requestedBy'] = requestedBy;
    data['amount'] = amount;
    data['bankId'] = bankId;
    data['bankName'] = bankName;
    data['time'] = time;
    data['id'] = id;
    data['bankHolderName'] = bankHolderName;
    data['accountNumber'] = accountNumber;
    data['requestStatus'] = requestStatus;
    data['docId'] = docId;
    data['bicCode'] = bicCode;
    return data;
  }
}
