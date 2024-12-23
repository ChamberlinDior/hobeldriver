import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCollections {
  static final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  static final CollectionReference adminSettingsCollection =
      FirebaseFirestore.instance.collection('adminSettings');

  static final CollectionReference vehicleTypesCollection =
      FirebaseFirestore.instance.collection('vehicle_types');

  static final DocumentReference<Object?> appSettingsdocument =
      adminSettingsCollection.doc('appParameters');
  static CollectionReference sessionCollection(String userId) {
    return users.doc(userId).collection('sessions');
  }

  static CollectionReference banksCollection(String userId) {
    return users.doc(userId).collection('banks');
  }

  static CollectionReference walletHistory(String userId) {
    return users.doc(userId).collection('walletHistory');
  }

  static final CollectionReference logsCollection =
      FirebaseFirestore.instance.collection('logs');

  static final CollectionReference liveBookings =
      FirebaseFirestore.instance.collection('liveBookings');
  static final CollectionReference cancelledBookings =
      FirebaseFirestore.instance.collection('cancelledBookings');
  static final CollectionReference bookingHistory =
      FirebaseFirestore.instance.collection('bookingHistory');
  static final CollectionReference rating =
      FirebaseFirestore.instance.collection('rating');
  static final CollectionReference chatsCollection =
      FirebaseFirestore.instance.collection('chats');
  static final CollectionReference contactUs =
      FirebaseFirestore.instance.collection('contactUs');
  static final CollectionReference withdrawalRequest =
      FirebaseFirestore.instance.collection('withdrawalRequest');

  static CollectionReference notificationCollection(String userId) {
    return users.doc(userId).collection('notifications');
  }
}
