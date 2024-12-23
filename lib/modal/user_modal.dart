import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_app_driver/constants/api_keys.dart';
import 'package:connect_app_driver/constants/types/approval_status.dart';
import 'package:connect_app_driver/constants/types/ride_type_status.dart';
import 'package:connect_app_driver/modal/shared_ride_details_modal.dart';
import 'package:connect_app_driver/modal/vehicleModal.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants/types/user_type.dart';

class UserModal {
  String userId;
  String fullName;
  String? phone;
  String? phoneWithCode;
  String? phoneCode;
  String email;
  String? profileImage;
  // String? vehicleRegistrationImage;
  // String vehicle_no;
  // String license_number;
  // String insurance_number;
  // String vehicle_type;
  // String? vehicle_model;
  // String? driving_license_image;
  Timestamp? dob;
  int userType;
  int approvalStatus;
  double walletEarnings;
  int totalReviewCount;
  double averageRating;
  bool isBlocked;
  List deviceTokens;
  List rideTypes;
  bool isOnline;
  LatLng latLng;
  Map? location;
  Timestamp lastUpdated;
  bool isEmailVerified;
  bool isMobileVerified;
  int unreadNotificationsCount;
  VehicleModal? vehicleModal;
  SharedRideDetailsModal? sharedRideDetailsModal;
  final Map fullData;

  UserModal({
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.phoneCode,
    // required this.vehicle_no,
    // required this.license_number,
    // required this.insurance_number,
    // required this.vehicleRegistrationImage,
    // required this.vehicle_type,
    // required this.driving_license_image,
    // required this.vehicle_model,
    required this.phoneWithCode,
    required this.dob,
    required this.profileImage,
    required this.latLng,
    required this.location,
    required this.vehicleModal,
    required this.sharedRideDetailsModal,
    required this.userType,
    required this.deviceTokens,
    required this.rideTypes,
    required this.lastUpdated,
    required this.isOnline,
    required this.isBlocked,
    required this.isEmailVerified,
    required this.isMobileVerified,
    required this.unreadNotificationsCount,
    required this.approvalStatus,
    required this.walletEarnings,
    required this.averageRating,
    required this.totalReviewCount,
    required this.fullData,
  });

  factory UserModal.fromJson(Map json, String userId) {
    return UserModal(
      userId: userId,
      // userId: json[ApiKeys.uid] ?? 'temp userId',
      fullName: json[ApiKeys.fullName] ?? 'temp fullName',
      email: json[ApiKeys.email] ?? 'temp email',
      phone: json[ApiKeys.phone],
      phoneCode: json[ApiKeys.phone_code],
      phoneWithCode: json[ApiKeys.phone_with_code],
      profileImage: json[ApiKeys.profileImage],
      dob: json[ApiKeys.dob],
      isOnline: json[ApiKeys.isOnline] ?? false,
      lastUpdated: json[ApiKeys.lastUpdated] ?? Timestamp.now(),
      userType: json[ApiKeys.userType] ?? UserType.driver,
      deviceTokens: json[ApiKeys.deviceTokens] ?? [],
      rideTypes: json[ApiKeys.rideTypes] ?? [RideTypeStatus.private],
      isBlocked: json[ApiKeys.isBlocked] ?? false,
      isEmailVerified: json[ApiKeys.isEmailVerified] ?? false,
      isMobileVerified: json[ApiKeys.isMobileVerified] ?? false,
      // vehicleRegistrationImage: json[ApiKeys.vehicleRegistrationImage],
      // vehicle_no: json[ApiKeys.vehicle_no] ?? 'false',
      // license_number: json[ApiKeys.license_number] ?? 'false',
      // vehicle_model: json[ApiKeys.vehicle_model],
      // driving_license_image: json[ApiKeys.driving_license_image] ,
      // insurance_number: json[ApiKeys.insurance_number] ?? 'false',
      // vehicle_type: json[ApiKeys.vehicle_type] ?? 'false',
      latLng: LatLng(json[ApiKeys.latitude] ?? 0, json[ApiKeys.longitude] ?? 0),
      location: json[ApiKeys.location],
      vehicleModal: json[ApiKeys.driving_license_image] == null
          ? null
          : VehicleModal.tryParse(json, userId),
      sharedRideDetailsModal: json[ApiKeys.sharedRideConfig] == null
          ? null
          : SharedRideDetailsModal.fromJson(json[ApiKeys.sharedRideConfig]),
      unreadNotificationsCount: json[ApiKeys.unreadNotificationsCount] ?? 0,
      approvalStatus: json[ApiKeys.approvalStatus] ?? ApprovalStatus.pending,
      walletEarnings:
          double.tryParse(json[ApiKeys.walletEarnings].toString()) ?? 0.0,
      averageRating: double.tryParse(json[ApiKeys.rating].toString()) ?? 0.0,
      totalReviewCount: int.tryParse(json[ApiKeys.ratingCount].toString()) ?? 0,
      fullData: json,
    );
  }

  static UserModal? tryParse(Map? json, String userId) {
    try {
      return UserModal.fromJson(json!, userId);
    } catch (e) {
      // return UserModal.fromJson(json!);
      print('Error in catch block $e');
      return null;
    }

    // return UserModal.fromJson(json);
  }
}
