// import 'package:connect_app_driver/services/file_services.dart';
// import 'package:cached_video_player_plus/cached_video_player_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';
// import '../constants/global_data.dart';
// import '../constants/my_colors.dart';
// import '../constants/sized_box.dart';
// import '../services/download_services.dart';
// import 'custom_appbar.dart';
// import 'custom_gesture_detector.dart';
// import 'custom_loader.dart';
// import 'old_custom_text.dart';
//
// // ignore: must_be_immutable
// class VideoPlayerPage extends StatefulWidget {
//   String videoUrl;
//   final int durationMax;
//   final bool isDownloadIcon;
//   final CachedVideoPlayerPlusController? controller;
//   final bool isShareIcon;
//
//   VideoPlayerPage(
//       {Key? key,
//       required this.videoUrl,
//       required this.durationMax,
//       this.isDownloadIcon = true,
//       this.isShareIcon = true,
//       this.controller})
//       : super(key: key);
//
//   @override
//   _VideoPlayerPageState createState() => _VideoPlayerPageState();
// }
//
// class _VideoPlayerPageState extends State<VideoPlayerPage> {
//   /*VideoPlayerController? videoPlayerController;
//   ValueNotifier<Widget> playerWidget = ValueNotifier(
//     const Center(child: CircularProgressIndicator()),
//   );*/
//
//   ValueNotifier<bool> isDownload = ValueNotifier(false);
//   ValueNotifier<bool> isInitialized = ValueNotifier(false);
//   ValueNotifier<bool> isPlaying = ValueNotifier(true);
//   ValueNotifier<bool> audioPlayed = ValueNotifier(false);
//   ValueNotifier<int> currentPos = ValueNotifier(1);
//   ValueNotifier<String> currentPositionLabel = ValueNotifier("00:00");
//   ValueNotifier<double> setPlaybackRateValue = ValueNotifier(1.0);
//   int maxDuration = 100;
//   CachedVideoPlayerPlusController? controller;
//
//   @override
//   void initState() {
//     super.initState();
//     init();
//   }
//
//   Future<void> init() async {
//     /*  videoPlayerController =
//         VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
//     await videoPlayerController?.initialize();
//     final chewieController = ChewieController(
//       videoPlayerController: videoPlayerController!,
//       autoPlay: true,
//       looping: false,
//     );
//     playerWidget.value = Chewie(
//       controller: chewieController,
//     );*/
//
//     if (widget.controller != null) {
//       controller = widget.controller;
//       isInitialized.value=true;
//       controller?.play();
//     } else {
//       controller = CachedVideoPlayerPlusController.networkUrl(
//         Uri.parse(
//           widget.videoUrl,
//         ),
//         invalidateCacheIfOlderThan: const Duration(days: 1),
//       )..initialize().then((value) async {
//           controller?.play();
//           isInitialized.value=true;
//           setState(() {});
//         });
//     }
//
//     maxDuration = widget.durationMax;
//     isPlaying.value = true;
//     audioPlayed.value = false;
//     currentPos.value = 0;
//     currentPositionLabel.value = "00:00:00";
//     // await getRecordedSongListApi();
//
//     controller!.addListener(() async {
//       Duration? p = await controller?.position;
//       currentPos.value = p!.inSeconds;
//       if (currentPos.value == maxDuration) {
//         isPlaying.value = false;
//         controller?.pause();
//       }
//       int sHours = Duration(seconds: currentPos.value).inHours;
//       int sMinutes = Duration(seconds: currentPos.value).inMinutes;
//       int sSeconds = Duration(seconds: currentPos.value).inSeconds;
//       int rHours = sHours;
//       int rMinutes = sMinutes - (sHours * 60);
//       int rSeconds = sSeconds - (sMinutes * 60 + sHours * 60 * 60);
//       currentPositionLabel.value =
//           "${(rHours <= 9) ? '0$rHours' : '$rHours'}:${(rMinutes <= 9) ? '0$rMinutes' : '$rMinutes'}:${(rSeconds <= 9) ? '0$rSeconds' : '$rSeconds'}";
//     });
//   }
//
//   Future<void> onChangedSlider(double value) async {
//     int seekVal = value.round();
//     await controller!.seekTo(Duration(seconds: seekVal));
//     currentPos.value = seekVal;
//   }
//
//   @override
//   void dispose() {
//     /* videoPlayerController?.dispose();*/
//     controller?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//           isBackIcon: true,
//           titleText: 'Video',
//           centerTitle: true,
//           bgcolor: MyColors.primaryColor,
//           actions: [
//             widget.isDownloadIcon
//                 ? ValueListenableBuilder(
//               valueListenable: isInitialized,
//                   builder: (context, isInitializedValue, child) {
//                     return IconButton(
//                         onPressed: () async {
//                           if(isInitializedValue)
//                             {
//                               isDownload.value = true;
//                               const snackBar = SnackBar(
//                                 content: SubHeadingText(
//                                   'Download complete!',
//                                   color: MyColors.whiteColor,
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: 16,
//                                 ),
//                                 duration: Duration(seconds: 2),
//                               );
//
//                               if (currentPos.value != maxDuration) {
//                                 isPlaying.value = false;
//                                 await controller?.pause();
//                               }
//                               await DownloadServices.saveNetworkImage(
//                                   url: widget.videoUrl,
//                                   name: '${DateTime.now().millisecondsSinceEpoch}',
//                                   ext: 'mp4');
//                               isDownload.value = false;
//                               // ignore: use_build_context_synchronously
//                               ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                               if (currentPos.value != maxDuration) {
//                                 await controller?.play();
//                                 isPlaying.value = true;
//                               }
//                             }
//
//                         },
//                         icon:  Icon(
//                           Icons.download_rounded,
//                           size: 30,
//                           color:isInitializedValue? MyColors.greyColor:MyColors.blackColor.withOpacity(0.3),
//                         ));
//                   }
//                 )
//                 : Container(),
//             widget.isShareIcon
//                 ? ValueListenableBuilder(
//                 valueListenable: isInitialized,
//                   builder: (context, isInitializedValue, child)  {
//                     return IconButton(
//                         onPressed: () async {
//                           if(isInitializedValue)
//                             {
//                                 isDownload.value = true;
//                               if (currentPos.value != maxDuration) {
//                                 isPlaying.value = false;
//                                 await controller?.pause();
//                               }
//
//
//                               String? path = await DownloadServices.getFilePath(
//                                   url: widget.videoUrl,
//                                   name: '${DateTime.now().millisecondsSinceEpoch}',
//                                   ext: 'mp4');
//                               isDownload.value = false;
//                               if (path != null) {
//                                 final file = XFile(path);
//                                 await FileServices.shareFiles(files: [file.path]);
//                               }
//
//
//                               if (currentPos.value != maxDuration) {
//                                 await controller?.play();
//                                 isPlaying.value = true;
//                               }
//                             }
//
//                         },
//                         padding: const EdgeInsets.only(
//                           right: 7,
//                         ),
//                         icon:  Icon(
//                           Icons.share,
//                           size: 26,
//                           color:isInitializedValue?MyColors.whiteColor: MyColors.blackColor.withOpacity(0.3),
//                         ) /*Image.asset(
//                           MyImagesUrl.userWalkReportShare,
//                           color: MyColors.whiteColor,
//                           scale: 7.5,
//                         )*/
//                         ,
//                       );
//                   }
//                 )
//                 : Container()
//           ]),
//       body: ValueListenableBuilder(
//         valueListenable: isDownload,
//         builder: (context, downloadValue, child) {
//           if (controller?.value.isInitialized == true) {
//             return Center(
//               child: Stack(
//                 alignment: Alignment.bottomCenter,
//                 children: [
//                   AspectRatio(
//                     aspectRatio: controller!.value.aspectRatio,
//                     child: CachedVideoPlayerPlus(controller!),
//                   ),
//                   Container(
//                       color: Colors.transparent,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(
//                                 left: globalHorizontalPadding + 10,
//                                 right: globalHorizontalPadding + 5),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 ValueListenableBuilder(
//                                     valueListenable: currentPositionLabel,
//                                     builder: (context, value, child) {
//                                       return ParagraphText(
//                                         value,
//                                         color: MyColors.blackColor,
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 14,
//                                       );
//                                     }),
//                                 ValueListenableBuilder(
//                                   valueListenable: isPlaying,
//                                   builder: (context, playing, child) {
//                                     if (playing) {
//                                       return InkWell(
//                                           onTap: () async {
//                                             await controller?.pause();
//                                             isPlaying.value = !isPlaying.value;
//                                           },
//                                           child: const Icon(Icons.pause));
//                                     } else {
//                                       return InkWell(
//                                           onTap: () async {
//                                             await controller?.play();
//                                             isPlaying.value = !isPlaying.value;
//                                           },
//                                           child: const Icon(Icons.play_arrow));
//                                     }
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                           ValueListenableBuilder(
//                               valueListenable: currentPos,
//                               builder: (context, value, child) {
//                                 return Slider(
//                                   activeColor: MyColors.primaryColor,
//                                   inactiveColor: Colors.black.withOpacity(0.2),
//                                   value: double.parse(value.toString()),
//                                   min: 0,
//                                   max: double.parse(maxDuration.toString()),
//                                   divisions: maxDuration,
//                                   onChanged: (double value) =>
//                                       onChangedSlider(value),
//                                 );
//                               }),
//                         ],
//                       )),
//                   ValueListenableBuilder(
//                       valueListenable: currentPos,
//                       builder: (context, value, child) {
//                         if (value == maxDuration) {
//                           return Align(
//                               child: CustomGestureDetector(
//                             onTap: () async {
//                               await controller
//                                   ?.seekTo(const Duration(seconds: 0));
//                               currentPos.value = 0;
//                               isPlaying.value = true;
//                               currentPositionLabel.value = "00:00:00";
//                               controller?.play();
//                             },
//                             child: Container(
//                               height: 50,
//                               width: 50,
//                               padding: const EdgeInsets.all(4),
//                               decoration: BoxDecoration(
//                                 color: MyColors.whiteColor,
//                                 borderRadius: BorderRadius.circular(25),
//                               ),
//                               child: const Icon(
//                                 Icons.restart_alt,
//                                 color: MyColors.redColor,
//                                 size: 40,
//                               ),
//                             ),
//                           ));
//                         } else {
//                           return const SizedBox();
//                         }
//                       }),
//                   if (downloadValue)
//                     Container(
//                       color: Colors.black.withOpacity(0.8),
//                       child: const Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           CustomLoader(color: MyColors.whiteColor),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//             );
//           } else {
//             return const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   ParagraphText("Video is Loading"),
//                   vSizedBox,
//                   CustomLoader(),
//                 ],
//               ),
//             );
//           }
//         },
//       ), /*ValueListenableBuilder(
//         valueListenable: playerWidget,
//         builder: (context, value, child) {
//           return value;
//         },
//       ),*/
//     );
//   }
//
// }
