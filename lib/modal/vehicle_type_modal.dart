import 'package:connect_app_driver/constants/api_keys.dart';
import 'package:connect_app_driver/widget/custom_image.dart';

class VehicleTypeModal {
  String id;
  String title;
  String image;
  CustomFileType fileType;
  double vehicleBasePrice;
  double waitingChargePerMinute;
  double perKmPrice;
  double bufferAmount;
  double perMinCharge;
  List<int> markerListImage;
  String markerImage;
  int numberOfSeat;
  int freeWaitingMinutes;
  VehicleTypeModal({
    required this.id,
    required this.title,
    required this.image,
    required this.fileType,
    required this.vehicleBasePrice,
    required this.waitingChargePerMinute,
    required this.perKmPrice,
    required this.bufferAmount,
    required this.perMinCharge,
    required this.markerListImage,
    required this.markerImage,
    required this.numberOfSeat,
    required this.freeWaitingMinutes,
  });

  factory VehicleTypeModal.fromJson(Map json) {
    return VehicleTypeModal(
      id: json[ApiKeys.id],
      title: json[ApiKeys.title],
      image: json[ApiKeys.image],
      fileType: json[ApiKeys.fileType] == 'asset'
          ? CustomFileType.asset
          : CustomFileType.network,
      vehicleBasePrice:
          double.tryParse(json[ApiKeys.vehicleBasePrice].toString()) ?? 0,
      waitingChargePerMinute:
          double.tryParse(json[ApiKeys.waitingChargePerMinute].toString()) ?? 0,
      perKmPrice: double.tryParse(json[ApiKeys.perKmPrice].toString()) ?? 0,
      bufferAmount: double.tryParse(json[ApiKeys.bufferAmount].toString()) ?? 0,
      perMinCharge: double.tryParse(json[ApiKeys.perMinCharge].toString()) ?? 0,
      markerListImage: json[ApiKeys.markerListImage] == null
          ? []
          : List.generate(json[ApiKeys.markerListImage].length, (index) {
              return json[ApiKeys.markerListImage][index];
            }),
      markerImage: json[ApiKeys.markerImage],
      numberOfSeat: json[ApiKeys.numberOfSeat] ?? 4,
      freeWaitingMinutes: int.parse(
          (json[ApiKeys.freeWaitingMinutes] ?? 0).toString().split('.').first),
    );
  }

  toJson() {
    return {
      ApiKeys.id: id,
      ApiKeys.title: title,
      ApiKeys.image: image,
      ApiKeys.fileType: fileType == CustomFileType.asset ? 'asset' : 'network',
      ApiKeys.vehicleBasePrice: vehicleBasePrice,
      ApiKeys.waitingChargePerMinute: waitingChargePerMinute,
      ApiKeys.perKmPrice: perKmPrice,
      ApiKeys.freeWaitingMinutes: freeWaitingMinutes,
      ApiKeys.bufferAmount: bufferAmount,
      ApiKeys.perMinCharge: perMinCharge,
      ApiKeys.markerListImage: markerListImage,
      ApiKeys.markerImage: markerImage,
      ApiKeys.numberOfSeat: numberOfSeat,
    };
  }
}
