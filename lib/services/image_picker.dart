// // ignore_for_file: depend_on_referenced_packages, avoid_print
//
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
//
// import '../constants/my_colors.dart';
// import '../widget/custom_loader.dart';
//
// Future pickImage(bool isGallery) async {
//   final ImagePicker picker = ImagePicker();
//
//   File? image;
//   try {
//     print('about to pick image');
//     XFile? pickedFile;
//     if (isGallery) {
//       pickedFile = await picker.pickImage(
//           source: ImageSource.gallery, imageQuality: 80, maxHeight: 600);
//     } else {
//       pickedFile = await picker.pickImage(
//           source: ImageSource.camera, imageQuality: 80, maxHeight: 600);
//     }
//     print('the error is $pickedFile');
//     int length = await pickedFile!.length();
//     print('the length is');
//     // print('size : ${length}');
//     print('size: ${pickedFile.readAsBytes()}');
//     File? croppedFile = await ImageCropper().cropImage(
//         cropStyle: CropStyle.circle,
//         // aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
//         compressQuality: length > 100000
//             ? length > 200000
//                 ? length > 300000
//                     ? length > 400000
//                         ? 5
//                         : 10
//                     : 20
//                 : 30
//             : 50,
//         sourcePath: pickedFile.path,
//         aspectRatioPresets: [
//           CropAspectRatioPreset.square,
//           // CropAspectRatioPreset.ratio3x2,
//           // CropAspectRatioPreset.original,
//           // CropAspectRatioPreset.ratio4x3,
//           // CropAspectRatioPreset.ratio16x9
//         ],
//         androidUiSettings: const AndroidUiSettings(
//             activeControlsWidgetColor: MyColors.primaryColor,
//             toolbarTitle: 'Adjust your Post',
//             toolbarColor: MyColors.primaryColor,
//             toolbarWidgetColor: MyColors.whiteColor,
//             initAspectRatio: CropAspectRatioPreset.original,
//             lockAspectRatio: true),
//         iosUiSettings: const IOSUiSettings(
//           minimumAspectRatio: 1.0,
//         ));
//
//     image = File(croppedFile!.path);
//     print(croppedFile);
//     print(image);
//     // setState(() {
//     // });
//
//     return image;
//   } catch (e) {
//     print("Image picker error $e");
//   }
// }
//
// Future multipleImagePicker(context) async {
//   final ImagePicker picker = ImagePicker();
//
//   final List<XFile>? pickedFiels;
//   try {
//     pickedFiels = await picker.pickMultiImage(
//       maxWidth: MediaQuery.of(context).size.width,
//       maxHeight: MediaQuery.of(context).size.height,
//       imageQuality: 10,
//     );
//     return pickedFiels;
//   } catch (err) {
//     print('multiple image catch err----$err');
//   }
// }
//
//
//
// Future<File?> imagepickerWithoutCroper(bool isGallery) async {
//   final ImagePicker picker = ImagePicker();
//   File? image;
//   try {
//     print('about to pick image');
//     XFile? pickedFile;
//     FilePickerResult? file;
//     if (isGallery) {
//       // pickedFile = await picker.pickImage(
//       //     source: ImageSource.gallery, imageQuality: 70);
//       file = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowMultiple: false,
//         allowedExtensions: [
//           'jpg',
//           'pdf',
//         ],
//       );
//     } else {
//       pickedFile =
//           await picker.pickImage(source: ImageSource.camera, imageQuality: 70);
//     }
//     print('the error is $pickedFile');
//     // int length = await pickedFile!.length();
//     print('the length is');
//     // print('size : ${length}');
//     // print('size: ${pickedFile.readAsBytes()}');
//
//     image = isGallery ? File(file!.files.single.path!) : File(pickedFile!.path);
//     // print(croppedFile);
//     print(image);
//     // setState(() {
//     // });
//     return image;
//   } catch (e) {
//     print("Image picker error $e");
//   }
//   return image;
// }
//
// Future<File?> cropImage(File pickedFile) async {
//   int length = await pickedFile.length();
//   File? image;
//   File? croppedFile = await ImageCropper().cropImage(
//       cropStyle: CropStyle.circle,
//       // aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
//       compressQuality: length > 100000
//           ? length > 200000
//               ? length > 300000
//                   ? length > 400000
//                       ? 5
//                       : 10
//                   : 20
//               : 30
//           : 50,
//       sourcePath: pickedFile.path,
//       aspectRatioPresets: [
//         CropAspectRatioPreset.square,
//       ],
//       androidUiSettings: const AndroidUiSettings(
//           activeControlsWidgetColor: MyColors.primaryColor,
//           toolbarTitle: 'Adjust your Post',
//           toolbarColor: MyColors.primaryColor,
//           toolbarWidgetColor: MyColors.whiteColor,
//           initAspectRatio: CropAspectRatioPreset.original,
//           lockAspectRatio: true),
//       iosUiSettings: const IOSUiSettings(
//         minimumAspectRatio: 1.0,
//       ));
//
//   image = File(croppedFile!.path);
//   print(croppedFile);
//   print(image);
//   return image;
// }
//
// Future<Map?> mediaPicker(ctx) async {
//   return showCupertinoModalPopup(
//       context: ctx,
//       builder: (_) => CupertinoActionSheet(
//             actions: [
//               CupertinoActionSheetAction(
//                   onPressed: () async {
//                     File? image;
//                     Map? row;
//                     image = await pickImage(false);
//                     print('image----$image');
//                     if (image != null) {
//                       row = {
//                         'value': image,
//                         'type': '1',
//                       };
//                       // medies.add(row);
//                     }
//                     // _close(ctx);
//                     // return row;
//                     Navigator.pop(ctx, row);
//                   },
//                   child: const Text('Take a picture')),
//               CupertinoActionSheetAction(
//                   onPressed: () async {
//                     File? image;
//                     Map? row;
//                     image = await pickImage(true);
//                     print('image----$image');
//
//                     if (image != null) {
//                       row = {
//                         'value': image,
//                         'type': '1',
//                       };
//                     }
//                     Navigator.pop(ctx, row);
//                   },
//                   child: const Text('Gallery')),
//
//             ],
//             cancelButton: CupertinoActionSheetAction(
//               onPressed: () => Navigator.pop(ctx, null),
//               child: const Text('Close'),
//             ),
//           ));
// }
//
// Future<Map?> cameraGallerypicker(ctx) async {
//   return showCupertinoModalPopup(
//       context: ctx,
//       builder: (_) => CupertinoActionSheet(
//             actions: [
//               CupertinoActionSheetAction(
//                   onPressed: () async {
//                     File? image;
//                     Map? row;
//                     image = await pickImage(false);
//                     print('image----$image');
//                     if (image != null) {
//                       row = {
//                         'value': image,
//                         'type': '1',
//                       };
//                     }
//                     Navigator.pop(ctx, row);
//                   },
//                   child: const Text('Take a picture')),
//               CupertinoActionSheetAction(
//                   onPressed: () async {
//                     File? image;
//                     Map? row;
//                     image = await pickImage(true);
//                     print('image----$image');
//
//                     if (image != null) {
//                       row = {
//                         'value': image,
//                         'type': '1',
//                       };
//                     }
//                     Navigator.pop(ctx, row);
//                   },
//                   child: const Text('Gallery')),
//             ],
//             cancelButton: CupertinoActionSheetAction(
//               onPressed: () => Navigator.pop(ctx, null),
//               child: const Text('Close'),
//             ),
//           ));
// }
//
// // void _close(BuildContext ctx) {
// //   Navigator.of(ctx).pop();
// // }
//
//
