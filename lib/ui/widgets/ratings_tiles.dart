import 'package:flutter/material.dart';
import 'package:praclog_v2/constants.dart';
import 'package:praclog_v2/ui/widgets/rounded_white_card.dart';

class RatingsTilesRow extends StatelessWidget {
  final String satisfaction;
  final String focus;
  final String progress;

  const RatingsTilesRow({
    Key? key,
    required this.satisfaction,
    required this.focus,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Satisfaction
        _RatingsTile(type: RatingType.satisfaction, data: satisfaction),
        const SizedBox(width: 6.0),
        // Progress
        _RatingsTile(type: RatingType.progress, data: progress),
        const SizedBox(width: 6.0),
        _RatingsTile(type: RatingType.focus, data: focus),
      ],
    );
  }
}

enum RatingType { satisfaction, progress, focus }

class _RatingsTile extends StatelessWidget {
  final RatingType type;
  final String data;

  const _RatingsTile({
    Key? key,
    required this.type,
    required this.data,
  }) : super(key: key);

  String get title {
    if (type == RatingType.satisfaction) {
      return 'satisfaction';
    } else if (type == RatingType.focus) {
      return 'focus';
    } else {
      return 'progress';
    }
  }

  IconData get icon {
    if (type == RatingType.satisfaction) {
      return kSatisfactionIcon;
    } else if (type == RatingType.focus) {
      return kFocusIcon;
    } else {
      return kProgressIcon;
    }
  }

  Color get iconColor {
    double? dataAsDouble = double.tryParse(data);
    if (dataAsDouble == null) {
      return kLightTextColor;
    } else if (0.0 < dataAsDouble && dataAsDouble <= 1.0) {
      return kRatingOneColor;
    } else if (1.0 < dataAsDouble && dataAsDouble <= 2.0) {
      return kRatingTwoColor;
    } else if (2.0 < dataAsDouble && dataAsDouble <= 3.0) {
      return kRatingThreeColor;
    } else if (3.0 < dataAsDouble && dataAsDouble <= 4.0) {
      return kRatingFourColor;
    } else if (4.0 < dataAsDouble && dataAsDouble <= 5.0) {
      return kRatingFiveColor;
    } else {
      return kLightTextColor;
    }
  }

  Color get backgroundColor {
    double? dataAsDouble = double.tryParse(data);
    if (dataAsDouble == null) {
      return kBackgroundColor;
    } else if (0.0 < dataAsDouble && dataAsDouble <= 1.0) {
      return kRatingOneBackgroundColor;
    } else if (1.0 < dataAsDouble && dataAsDouble <= 2.0) {
      return kRatingTwoBackgroundColor;
    } else if (2.0 < dataAsDouble && dataAsDouble <= 3.0) {
      return kRatingThreeBackgroundColor;
    } else if (3.0 < dataAsDouble && dataAsDouble <= 4.0) {
      return kRatingFourBackgroundColor;
    } else if (4.0 < dataAsDouble && dataAsDouble <= 5.0) {
      return kRatingFiveBackgroundColor;
    } else {
      return kBackgroundColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: RoundedWhiteCard(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    data,
                    style: const TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: backgroundColor, shape: BoxShape.circle),
                    child: Icon(
                      icon,
                      size: 30.0,
                      color: iconColor,
                    ),
                  ),
                ],
              ),
              Text(
                title,
                style: const TextStyle(
                  color: kLightTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DurationTile extends StatelessWidget {
  final String unit;
  final String title;
  final String data;

  const DurationTile({
    Key? key,
    required this.data,
    required this.title,
    required this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedWhiteCard(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5.0),
            decoration:
                BoxDecoration(color: Colors.blue[100], shape: BoxShape.circle),
            child: const Icon(
              Icons.timer,
              size: 30.0,
              color: kPrimaryColor,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  '$data $unit',
                  style: kRatingsInfoTitle,
                ),
                Text(
                  title,
                  style: const TextStyle(color: kLightTextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
