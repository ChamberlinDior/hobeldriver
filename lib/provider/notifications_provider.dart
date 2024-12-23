import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app_driver/pages/view_module/withdraws_screen.dart';
import 'package:connect_app_driver/services/custom_navigation_services.dart';
import 'package:flutter/material.dart';
import 'package:connect_app_driver/services/api_urls.dart';
import 'package:connect_app_driver/services/newest_webservices.dart';
import '../modal/notifications_modal.dart';

class NotificationsProvider extends ChangeNotifier {
  List<NotificationModal> notifications = [];

  bool notificationsLoad = true;

  getNotifications() async {
    notificationsLoad = true;
    notifyListeners();
    Map<String, dynamic> request = {};
    var response = await NewestWebServices.getResponse(
        apiUrl: ApiUrls.getNotifications,
        request: request,
        apiMethod: ApiMethod.get);
    if (response.status == 1) {
      notifications = List.generate(response.data['data'].length,
          (index) => NotificationModal.fromJson(response.data['data'][index]));
    }
    notificationsLoad = false;
    notifyListeners();
  }

  updateNotifications(List<QueryDocumentSnapshot<Object?>> docs) async {
    print('Updating notifications....${docs.length}');
    notifications.clear();
    for (int i = 0; i < docs.length; i++) {
      notifications.add(NotificationModal.fromJson(docs[i].data() as Map));
    }
    notifyListeners();
  }

  //
  // readAllNotifications()async{
  //   var querySnapshot = await FirebaseCollections.notificationCollection(userData!.uid).where('isRead', isEqualTo: 0).get();
  //
  //   for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
  //     // Assuming 'parameterToUpdate' is the field you want to update
  //     await FirebaseCollections.notificationCollection(userData!.uid).doc(documentSnapshot.id).update({'isRead': 1});
  //   }
  //   // FirebaseCollections.notificationCollection(userData!.uid).
  //   notifyListeners();
  // }

  // getScreenNavigation(String screenName){
  //   switch(screenName){
  //     case 'booking': return BookingDetails(isComplete: isComplete, bookingModal: bookingModal)
  //   }
  // }

  static handleNotification(
      {required Map data,
      required BuildContext context,
      bool popAll = true}) async {
    print('tkdsfklsjdf  ${data} $context');
    // BuildContext context = MyGlobalKeys.navigatorKey.currentContext!;

    if (data['screen'] == 'withdrawal_screen') {
      CustomNavigation.push(context: context, screen: const WithdrawsScreen());
    } else if (data['screen'] == 'shipment') {
      // CustomNavigation.push(context: MyGlobalKeys.navigatorKey.currentContext!, screen: NewShipmentDetailScreen(shipmentModalTemp: null, shipmentId: int.tryParse(data[ApiKeys.shipment_id].toString())??0,));
    }

    if (data['screen'] == 'booking') {
      if (popAll) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }

      // var request= {
      //   'bookingId': data['bookingId']
      // };
      // var response = await NewestWebServices.getResponse(apiUrl: ApiUrls.getBookingDetail, request: request, apiMethod: ApiMethod.get);
      // if(response.status==1){
      //   BookingModal bookingModal = BookingModal.fromJson(response.data);
      //
      // }
    }
  }
}
