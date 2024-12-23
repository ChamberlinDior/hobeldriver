import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/my_image_url.dart';
import 'custom_loader.dart';

enum CustomFileType { asset, network, file }

class CustomImage extends StatelessWidget {
  final double height;
  final double width;
  final double? borderRadius;
  final String imageUrl;
  final CustomFileType fileType;
  final Color? overlayColor;
  final File? image;
  final BoxFit? fit;
  final Border? border;
  final String staticBlurImage;
  final bool showLoader;
  final bool isBackgroundImage;

  const CustomImage({
    super.key,
    required this.imageUrl,
    this.image,
    this.height = 115,
    this.isBackgroundImage = true,
    this.width = 115,
    this.borderRadius,
    this.overlayColor,
    this.border,
    this.staticBlurImage = MyImagesUrl.logout,
    this.fileType = CustomFileType.network,
    this.fit = BoxFit.cover,
    this.showLoader = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height,
          width: width,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            border: border,
            borderRadius: BorderRadius.circular(borderRadius ?? height),
            image: fileType != CustomFileType.network
                ? null
                : isBackgroundImage
                    ? DecorationImage(
                        image: AssetImage(staticBlurImage), fit: BoxFit.cover)
                    : null,
          ),
          child: fileType != CustomFileType.network
              ? null
              : const Center(
                  child: CustomLoader(),
                ),
        ),
        Container(
          height: height,
          width: width,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              // color: Colors.grey,
              // border: border,
              borderRadius: BorderRadius.circular(borderRadius ?? height),
              image: fileType == CustomFileType.asset
                  ? DecorationImage(fit: fit, image: AssetImage(imageUrl))
                  : fileType == CustomFileType.file
                      ? DecorationImage(
                          image: FileImage(image!),
                          fit: fit ?? BoxFit.cover,
                        ) :
                      null),
          child: fileType == CustomFileType.network
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: fit ?? BoxFit.cover,
                  placeholder: (context, url) {
                    return Stack(
                      children: [
                        Image.asset(
                          staticBlurImage,
                          fit: BoxFit.cover,
                          height: height,
                          width: width,
                        ),
                        if(showLoader)
                        const Center(child: CustomLoader())
                      ],
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Image.asset(
                      staticBlurImage,
                      fit: BoxFit.cover,
                      height: height,
                      width: width,
                    );
                  },
                )
              : null,
        ),
      ],
    );

  }
}

