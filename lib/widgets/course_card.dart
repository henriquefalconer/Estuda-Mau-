import 'package:estuda_maua/utilities/constants.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  CourseCard({
    @required this.courseName,
    this.imageURL,
    this.onCoursePress,
    this.onFavoritedLongPress,
    this.backgroundColor = kCourseCardBackgroundColor,
    this.favorited = false,
  });

  final String courseName;
  final String imageURL;
  final Function onCoursePress;
  final Function onFavoritedLongPress;
  final Color backgroundColor;
  final bool favorited;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCoursePress,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 10.0,
        ),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(kCardBorderRadius),
          child: Column(
            children: <Widget>[
              Container(
                height: kCardVerticalSpace - kCardTextVerticalSpace,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(kCardBorderRadius),
                  child: imageURL == null
                      ? Container(
                          color: Colors.grey[400],
                        )
                      : Image.network(
                          imageURL,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        left: kOuterStarHorizontalPaddingSize,
                        right: kInnerStarHorizontalPaddingSize),
                    child: Icon(
                      Icons.star,
                      color: Colors.transparent,
                      size: kStarIconSize,
                    ),
                  ),
                  Container(
                    height: kCardTextVerticalSpace,
                  ),
                  Expanded(
                    flex: 10,
                    child: Text(
                      courseName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: kCourseTextSize, color: kCourseTextColor),
                      overflow: TextOverflow.ellipsis,
                      maxLines: kMaxNumberOfCardTextLines,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: kOuterStarHorizontalPaddingSize,
                        left: kInnerStarHorizontalPaddingSize),
                    child: GestureDetector(
                      onLongPress: onFavoritedLongPress,
                      child: Icon(
                        Icons.star,
                        color:
                            favorited ? kActiveStarColor : kInactiveStarColor,
                        size: kStarIconSize,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
