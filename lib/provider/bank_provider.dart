import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app_driver/constants/api_keys.dart';
import 'package:connect_app_driver/constants/global_data.dart';
import 'package:connect_app_driver/constants/global_error_constants.dart';
import 'package:connect_app_driver/constants/global_keys.dart';
import 'package:connect_app_driver/functions/easyLoadingConfigSetup.dart';
import 'package:connect_app_driver/functions/print_function.dart';
import 'package:connect_app_driver/modal/transaction_modal.dart';
import 'package:connect_app_driver/modal/withdraw_modal.dart';
import 'package:connect_app_driver/services/custom_navigation_services.dart';
import 'package:connect_app_driver/services/firebase_services/firebase_collections.dart';
import 'package:connect_app_driver/widget/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../modal/bank_modal.dart';

class BankProvider extends ChangeNotifier {
  List<BankModal> allBanks = [];
  bool banksLoad = false;
  List<WithdrawModal> withdrawalRequests = [];
  bool showWithdrawalRequestButton = false;
  List<TransactionModal> transactionHistoryList = [];

  getAllBanks() async {
    if (allBanks.isEmpty) {
      showBanksLoad();
    }

    var snapshot =
        await FirebaseCollections.banksCollection(userData!.userId).get();
    if (snapshot.docs.isNotEmpty) {
      allBanks = List.generate(
          (snapshot.docs).length,
          (index) => BankModal.fromJson(
              (snapshot.docs)[index].data() as Map, (snapshot.docs)[index].id));
    } else {
      allBanks.clear();
    }
    hideBankssLoad();
  }

  addOrEditBank(BankModal bankModal, {bool isEdit = false}) async {
    // if(allBanks.isEmpty){
    //   showBanksLoad();
    // }
    showBanksLoad();

    Map<String, dynamic> request = bankModal.toJson();

    if (isEdit) {
      await FirebaseCollections.banksCollection(userData!.userId)
          .doc(bankModal.id)
          .update(request);
      CustomNavigation.pop(MyGlobalKeys.navigatorKey.currentContext!);
      showSnackbar(GlobalErrorConstants.bankEdited);
    } else {
      request.remove(ApiKeys.id);
      await FirebaseCollections.banksCollection(userData!.userId).add(request);
      CustomNavigation.pop(MyGlobalKeys.navigatorKey.currentContext!);
      showSnackbar(GlobalErrorConstants.bankAdded);
    }
    getAllBanks();
    // hideTransactionsLoad();
  }

  deleteBank(String bankId) async {
    showBanksLoad();
    print('deleting ${userData!.userId}.... ${bankId}');
    await FirebaseCollections.banksCollection(userData!.userId)
        .doc(bankId)
        .delete();
    showBanksLoad();
    getAllBanks();
  }

  showBanksLoad() async {
    banksLoad = true;
    notifyListeners();
  }

  hideBankssLoad() async {
    banksLoad = false;
    notifyListeners();
  }

  getWithdrawalRequests() async {
    if (withdrawalRequests.isEmpty) {
      await showLoading();
    }
    var res = await FirebaseCollections.withdrawalRequest
        .where(ApiKeys.requestedBy, isEqualTo: userData!.userId)
        .orderBy('time', descending: true)
        .get();
    if (withdrawalRequests.isEmpty) {
      await hideLoading();
    }
    withdrawalRequests = [];
    showWithdrawalRequestButton = true;
    var todayDateIs =
        DateFormat("yyyy-MMM-dd").format(Timestamp.now().toDate());
    for (int i = 0; i < res.docs.length; i++) {
      Map d = res.docs[i].data() as Map;
      d['docId'] = res.docs[i].id;
      if (todayDateIs == DateFormat("yyyy-MMM-dd").format(d['time'].toDate()) &&
          d['requestStatus'] != 2) {
        showWithdrawalRequestButton = false;
      }
      withdrawalRequests.add(WithdrawModal.fromJson(d));
    }
    notifyListeners();
  }

  createWithDrawRequest(selectedBank, String amount) async {
    Map<String, dynamic> data = {
      "id": FirebaseCollections.withdrawalRequest.doc().id,
      "ibanAccountNumber": selectedBank!['ibanAccountNumber'],
      "account_name": selectedBank!['account_name'],
      "bank_name": selectedBank!['bank_name'],
      "bicCode": selectedBank!['bicCode'],
      "bankId": selectedBank!['id'],
      'time': DateTime.now(),
      'requestedBy': userData!.userId,
      'requestStatus': 0,
      'amount': double.parse(amount),
    };

    await showLoading();

    await FirebaseCollections.withdrawalRequest.doc(data['id']).set(data);

    Map<String, dynamic> data1 = {
      "bookingRef":
          FirebaseCollections.walletHistory(userData!.userId).doc().id,
      "time": DateTime.now(),
      "amount": amount,
      "action": "debit",
      "text":
          "Withdrawal request IBAN :- ${selectedBank!['ibanAccountNumber']}",
      "withdrawal_request_id": data['id']
    };

    await FirebaseCollections.walletHistory(userData!.userId)
        .doc(data1['id'])
        .set(data1);
    await FirebaseCollections.users.doc(userData!.userId).update({
      ApiKeys.walletEarnings: userData!.walletEarnings - double.parse(amount)
    });
    await hideLoading();

    showSnackbar(
        "Thank you! Your withdrawal request has been submitted successfully. It’s in pending state. Generally it takes 2-3 busniess days.");
    getWithdrawalRequests();
    getTransactionHistory();
  }

  getTransactionHistory() async {
    if (transactionHistoryList.isEmpty) {
      showLoading();
    }
    var res = await FirebaseCollections.walletHistory(userData!.userId)
        .orderBy('time', descending: true)
        .get();
    myCustomPrintStatement('get res ----- ${res.docs.length}');
    if (transactionHistoryList.isEmpty) {
      hideLoading();
    }
    transactionHistoryList = [];
    for (int i = 0; i < res.docs.length; i++) {
      Map d = res.docs[i].data() as Map;
      d['docId'] = res.docs[i].id;

      transactionHistoryList.add(TransactionModal.fromJson(d));
    }

    notifyListeners();
  }
}
