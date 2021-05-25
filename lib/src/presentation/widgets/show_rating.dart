import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ShowRating extends StatefulWidget {
  ShowRating(
      {this.star,
      this.minRating = 1,
      this.ratingDirection = Axis.horizontal,
      this.allowHalfRating = true,
      this.starCount = 5,
      this.starSize,
      this.starColor = Colors.amber,
      this.permitRating = false,
      this.onRatingUpdate});

  double star;
  double minRating;
  Axis ratingDirection;
  bool allowHalfRating;
  int starCount;
  double starSize;
  Color starColor;
  bool permitRating;
  Function onRatingUpdate;

  @override
  ShowRatingState createState() => ShowRatingState();
}

class ShowRatingState extends State<ShowRating> {
  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: widget.star,
      minRating: widget.minRating,
      direction: widget.ratingDirection,
      allowHalfRating: widget.allowHalfRating,
      itemCount: widget.starCount,
      itemSize: widget.starSize,
      itemBuilder: (context, _) => Icon(
        Icons.star_rounded,
        color: widget.starColor,
      ),
      onRatingUpdate: widget.permitRating
          ? (rating) {
              widget.onRatingUpdate();
            }
          : null,
    );
  }
}
