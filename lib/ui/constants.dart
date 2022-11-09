import 'package:flutter/material.dart';
import 'package:praclog/ui/theme/custom_colors.dart';

// Border radius: for rounded corners
BorderRadius customBorderRadius = BorderRadius.circular(18.0);

/// To add space at the bottom of screens so that the + FAB (to start practice) does not cover content
const SizedBox kPageBottomSpace = SizedBox(
  height: 30.0,
);

const Widget kUpperSpacing = SizedBox(height: 15.0);
const Widget kLowerSpacing = SizedBox(height: 10.0);

// Text styles
const TextStyle kSubheading = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.bold,
);

const TextStyle kMainButtonTextStyle = TextStyle(
  fontSize: 16.0,
);

const TextStyle kBottomSheetTitle = TextStyle(
  fontSize: 20.0,
);

const TextStyle kRatingsInfoTitle = TextStyle(
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
);

/// For the date on `LogCard`
const TextStyle kDateTextStyle = TextStyle(
  fontSize: 15.0,
  fontWeight: FontWeight.bold,
  color: CustomColors.primaryColor,
);

const kVerticalSeparator = VerticalDivider(
  thickness: 1.0,
  color: CustomColors.lightTextColor,
);

const kVerticalSpace = SizedBox(width: 3.0);

// Icons
const kSatisfactionIcon = Icons.sentiment_satisfied_alt;
const kFocusIcon = Icons.psychology;
const kProgressIcon = Icons.trending_up;
const kTimeIcon = Icons.timer_outlined;
