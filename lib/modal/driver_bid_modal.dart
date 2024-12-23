import 'package:cloud_firestore/cloud_firestore.dart';

class DriverBidModal {
  Timestamp createdAt;
  String profileImage;
  String fullName;
  double rating;
  String userId;
  double driverBids;
  int ratingCount;

  DriverBidModal(
      {required this.createdAt,
      required this.profileImage,
      required this.fullName,
      required this.rating,
      required this.userId,
      required this.driverBids,
      required this.ratingCount});

  factory DriverBidModal.fromJson(Map<String, dynamic> json) {
    return DriverBidModal(
        createdAt: json['createdAt'],
        profileImage: json['profile_image'],
        fullName: json['full_name'],
        rating: double.parse(json['rating'].toString()),
        userId: json['userId'],
        driverBids: double.parse(json['driverBids'].toString()),
        ratingCount: int.parse(json['rating_count'].toString()));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createdAt'] = createdAt;
    data['profile_image'] = profileImage;
    data['full_name'] = fullName;
    data['rating'] = rating;
    data['userId'] = userId;
    data['driverBids'] = driverBids;
    data['rating_count'] = ratingCount;
    return data;
  }
}
