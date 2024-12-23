import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../constants/my_colors.dart';
import '../constants/my_image_url.dart';

class CustomRating extends StatelessWidget {
  final Color? fillColor;
  final Color? disableColor;
  final double? rating;
  final double? itemSize;
  final bool ignoreGestures;
  final Function(double)? onRatingUpdate;

  const CustomRating(
      {super.key,
      this.fillColor,
      this.disableColor,
      this.rating,
      this.itemSize,
      this.onRatingUpdate,
      this.ignoreGestures = true});

  @override
  Widget build(BuildContext context) {
    return RatingBar(
      initialRating: rating ?? 3,
      minRating: 1,
      ignoreGestures: ignoreGestures,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: itemSize ?? 12,
      ratingWidget: RatingWidget(
        full: Image.asset(
          MyImagesUrl.star,
          color: fillColor ?? const Color(0xFFFBBC04),
        ),
        half: Image.asset(MyImagesUrl.star),
        empty: Image.asset(
          MyImagesUrl.star,
          color: disableColor ?? MyColors.color969696,
        ),
      ),
      onRatingUpdate: onRatingUpdate ?? (rating) {},
    );
  }
}
