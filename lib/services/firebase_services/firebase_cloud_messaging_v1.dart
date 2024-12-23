import 'dart:convert' as convert;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app_driver/constants/global_data.dart';
import 'package:connect_app_driver/services/firebase_services/firebase_collections.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

import '../../functions/print_function.dart';

class FirebaseCloudMessagingV1 {
  final String _endPointUrlForFireBaseMessagingScope =
      "https://www.googleapis.com/auth/firebase.messaging";

  /////////////////////////---------------------
  // Repace with your sender id
  // sender Id
  final String _senderId = "603468115777";
  // Project Id
  final String _projectId = "holeb-ride-sharing-apps";
  /////////////////////////---------------------
  Future<String> getFirebaseAccessToken() async {
    final response = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "holeb-ride-sharing-apps",
          "private_key_id": "48aa6d89a49854956022e776e48779220f22547c",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCgbzXb/21ans01\nBV0ve9e5C/YOGfDeH1teneeoq0hQuvXnDnx28xAehk+CMbZbO1qHezGVz5Vn2iVB\nJJJWJZGrJ+9/ihng6vGHhLbRIAQkGCmLsl5er8uRF+qV/NdHRlz1FvQB6u7q2CCh\noRuOGmLDroVWRnWmm/aA6QCgmj3aQGaAWggROr/VlSyXHS1zqyf0NYMHxyQTsMu1\no29eeE5WpuG8fTdJhaZ86RAoyYixUSR4mHh7Qntct9SGfHtCOeKFXbPS2jFYG++D\nR5IUMRi+doWnRImYYsk6p8glJFYTXx5OjvLSkjgFkoT8fx0NTaifPpm+Hfq8bbm9\nGKaHnjKZAgMBAAECggEABV+UKzkj3XwiHVt/on6AXCdFZ3WA9r+QHNwnDSQneOS6\nJbH7gzRi3tLayN6HYAjd4FnE8GKSe3b39nWWHSKG/XeJ8viaI0lbK5HLWbe7y8Wv\nZolj1cIHjGWDquBcCXwW0vKg24uV0vHILgGqXZkOo8UtnBUiDaF9oRWsurRPzAZ8\nlNxkr7mwkQEfiPBmrPveUheYMVe8sy57/uZd4JJIHIqeyfUG/Q2NIy3/YCrQS/Xd\nKGI3DV/mQrF9dOvcwzRMAM7lbTsOXSmEFbW/zcwg4kJEk6gWmd8XZNxm+LotBj+t\nLgZoY55h6lFpqsUh6ZKV0kS56upLtEuMu+AHHyEf3QKBgQDM63MpfqwOfk+jDtVx\nqQm+AhOAYhFpScjp4tQsuEMUxQv5a2bDpKA2nspEkfgYQdNHTKYcHia+d/f2WL05\nVp967YBPTcNABPT2RrtwAKR7I1BOg/DRXPIiDJCWTwfVk0YRO1xHAQh/NnE+p33h\n7y55wUwR4cArRVq8ENUzqQ9YhwKBgQDIbQSLwJT055PZTJLjKskmEpDGPa9tPXad\nbyqbS1Xq+01PlRqKQr+giH/D/TIv2X0IpTJ0q5rn3EPB6BUiEqq1X0/HLEdkD98Z\n+5rEtavK7fAea+i9t+sy6CMcPrXH8bqmApFxJrQcy3nqDrN6A9KDFwgV1voFR1fq\nQ1NPgzWD3wKBgFvXx0S4xmq0iALf+iA4D+q+SXlH+t/Cty7EgC4O49niOuyuC1/y\nX/A7GRLEjXppvkT9gJGnndvOLy+VNDIHtfDFk7V3d+QwlI3ww79+OjoKaMrX7c4Y\nJ1nFYeRMRYmeuU+t2DzmpKVHhFf9f7kMlzrwvKRjFtsN+Y3CyZue0QbvAoGAJKDP\nyN6MGmnL+lVlLsDd++g+rwwM6FDoQYNUbQcKj6QXj+i27fee366yctXt+xKrKA5Q\nt0O5TpBRjbllS1HQAs+FW+f6sA26fxwdP7/XwoFTdavQ4AMhp68G452OSRkjPD2R\n6PTiy7Rf9mdzY2QZb72gy6T7EkXkijp9mjVnbU8CgYAGhNxZSguFVZeEDfcJPHzt\nnMxq+zcKwHXWenO4W7tZAp2ualvKzibQlVgsSNvGKDpRnLbz7mcQfLnaB2PjqOtt\ns53e/QAzNkn1vkgzuhq+Z5gk1OVFY93ZI2oCrV9dZJdqCPbvG77gJ/8zDUdA/pmN\nMgPDq75pQMOS3WCRqNFJtw==\n-----END PRIVATE KEY-----\n",
          "client_email":
              "admin-669@holeb-ride-sharing-apps.iam.gserviceaccount.com",
          "client_id": "103406736316808255382",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/admin-669%40holeb-ride-sharing-apps.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        [_endPointUrlForFireBaseMessagingScope]);

    return response.credentials.accessToken.data;
  }

  Future<String> getMultipleDeviceToken(
      {required List deviceIds, required String apiAuthToken}) async {
    var request = {
      "operation": "create",
      "notification_key_name": await generateNotificationId(),
      "registration_ids": deviceIds
    };

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "authorization": "Bearer $apiAuthToken",
      "access_token_auth": "true",
      "project_id": _senderId
    };

    myCustomPrintStatement("notification sending---------");

    var response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/notification'),
        headers: headers,
        body: convert.jsonEncode(request));

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      if (jsonResponse['notification_key'] != null) {
        return jsonResponse['notification_key'];
      }
      return '';
    } else {
      return '';
    }
  }

  Future sendPushNotifications({
    required List deviceIds,
    required Map data,
    required String body,
    required String title,
  }) async {
    String apiAuthToken = "";
    String singleDeviceToken = "";
    apiAuthToken = await FirebaseCloudMessagingV1().getFirebaseAccessToken();
    myCustomLogStatements("all device ids are ${deviceIds}");
    if (deviceIds.length > 1) {
      singleDeviceToken = await getMultipleDeviceToken(
        deviceIds: deviceIds,
        apiAuthToken: apiAuthToken,
      );
    } else {
      singleDeviceToken = deviceIds.first;
    }

    var request = {
      "message": {
        "token": singleDeviceToken,
        "notification": {
          "body": body,
          "title": title,
        },
        "data": data,
      }
    };

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "authorization": "Bearer $apiAuthToken",
    };

    myCustomLogStatements("notification sending---------");

    var response = await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send'),
        headers: headers,
        body: convert.jsonEncode(request));
    myCustomLogStatements(
        'the response is ${response.statusCode}.... ${response.body}');
    if (response.statusCode == 200) {
      myCustomLogStatements('notification sent to ${deviceIds.length} devices');
    }
  }

  Future sendPushNotificationsWithFirebaseCollectInsertion({
    required List deviceIds,
    required Map data,
    Map? otherDetails,
    required String body,
    required String title,
    required String reciverUserId,
  }) async {
    String apiAuthToken = "";
    String singleDeviceToken = "";
    apiAuthToken = await FirebaseCloudMessagingV1().getFirebaseAccessToken();
    myCustomLogStatements("all device ids are ${deviceIds}");
    if (deviceIds.length > 1) {
      singleDeviceToken = await getMultipleDeviceToken(
        deviceIds: deviceIds,
        apiAuthToken: apiAuthToken,
      );
    } else {
      singleDeviceToken = deviceIds.first;
    }

    var request = {
      "message": {
        "token": singleDeviceToken,
        "notification": {
          "body": body,
          "title": title,
        },
        "data": data,
      }
    };

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "authorization": "Bearer $apiAuthToken",
    };

    myCustomLogStatements("notification sending---------");

    var response = await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send'),
        headers: headers,
        body: convert.jsonEncode(request));
    myCustomLogStatements(
        'the response is ${response.statusCode}.... ${response.body}');
    if (response.statusCode == 200) {
      myCustomLogStatements('notification sent to ${deviceIds.length} devices');

      if (reciverUserId != null) {
        var docId = FirebaseCollections.users
            .doc(reciverUserId)
            .collection('notifications')
            .doc()
            .id;
        await FirebaseCollections.users
            .doc(reciverUserId)
            .collection('notifications')
            .doc(docId)
            .set({
          "to": reciverUserId,
          "by": userData!.userId,
          "title": title,
          "message": body,
          "otherDetails": otherDetails,
          "data": data,
          "read": false,
          "createdAt": Timestamp.now(),
          "id": DateTime.now().second
        });
      }
    }
  }

  Future<String> generateNotificationId() async {
    const allowedChars =
        'abcdefghijklmnopqrstuvwxyz0123456789'; // Define allowed characters
    final rand = Random();
    const idLength = 35; // Maximum length of the ID

    // Generate random characters from the allowed characters
    String id = List.generate(
            idLength, (_) => allowedChars[rand.nextInt(allowedChars.length)])
        .join();

    return id + '${DateTime.now().millisecondsSinceEpoch}';
  }
}
