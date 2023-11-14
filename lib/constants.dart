import 'package:flutter/material.dart';

// Colors ------------------------------------------
const Color kBackgroundColor = Color(0xFFE8E8E8);
const Color kPrimaryColor = Colors.blue;
Color kPrimaryColorLight = Colors.blue[200]!;
const Color kMainTextColor = Colors.black;
const Color kLightTextColor = Colors.grey;

// For ratings
const Color kRatingOneColor = Colors.red;
const Color kRatingTwoColor = Colors.orange;
Color kRatingThreeColor = Colors.yellow.shade600;
const Color kRatingFourColor = Colors.green;
const Color kRatingFiveColor = Colors.blue;

Color kRatingOneBackgroundColor = Colors.red.shade100;
Color kRatingTwoBackgroundColor = Colors.orange.shade100;
Color kRatingThreeBackgroundColor = Colors.yellow.shade100;
Color kRatingFourBackgroundColor = Colors.green.shade100;
Color kRatingFiveBackgroundColor = Colors.blue.shade100;

// For graphs
const Color kSatisfactionColor = Colors.blue;
const Color kFocusColor = Colors.orange;
const Color kProgressColor = Colors.green;

// Text styles ------------------------------------------
const TextStyle kSubheading = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.bold,
);

const TextStyle kBottomSheetTitle = TextStyle(
  fontSize: 20.0,
);

const TextStyle kMainButtonTextStyle = TextStyle(
  fontSize: 16.0,
);

/// For the date on `LogCard`
const TextStyle kDateTextStyle = TextStyle(
  fontSize: 15.0,
  fontWeight: FontWeight.bold,
  color: kPrimaryColor,
);

const TextStyle kRatingsInfoTitle = TextStyle(
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
);

// Icons ------------------------------------------
const kSatisfactionIcon = Icons.sentiment_satisfied_alt;
const kFocusIcon = Icons.psychology;
const kProgressIcon = Icons.trending_up;
const kTimeIcon = Icons.timer_outlined;

// Others ------------------------------------------
BorderRadius customBorderRadius =
    BorderRadius.circular(18.0); // for rounded corners

const kVerticalSeparator = VerticalDivider(
  thickness: 1.0,
  color: kLightTextColor,
);

const kVerticalSpace = SizedBox(width: 3.0);

/// To add space at the bottom of screens so that the + FAB (to start practice) does not cover content
const SizedBox kPageBottomSpace = SizedBox(
  height: 30.0,
);

const Widget kUpperSpacing = SizedBox(height: 15.0);
const Widget kLowerSpacing = SizedBox(height: 10.0);
