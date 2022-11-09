import 'package:flutter/material.dart';
import 'package:praclog/ui/constants.dart';
import 'package:praclog/ui/theme/custom_colors.dart';
import 'package:praclog/ui/widgets/rounded_white_card.dart';

class PieceInfoTile extends StatelessWidget {
  final String title;
  final String composer;
  final int? movementIndex;
  final String? movementTitle;
  const PieceInfoTile({
    Key? key,
    required this.title,
    required this.composer,
    this.movementIndex,
    this.movementTitle,
  })  :
        // If it's a movement, both movementIndex AND movementTitle must be supplied
        assert(movementIndex != null ? movementTitle != null : true),
        super(key: key);

  Widget getMovementInfo() {
    if (movementIndex != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5.0),
          Text('${movementIndex! + 1}. $movementTitle',
              style: const TextStyle(color: CustomColors.lightTextColor)),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RoundedWhiteCard(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$composer: $title', style: kMainButtonTextStyle),
          getMovementInfo(),
        ],
      ),
    );
  }
}

class DurationListTile extends StatelessWidget {
  final int duration;
  final VoidCallback? onPressEdit;
  const DurationListTile({
    Key? key,
    required this.duration,
    this.onPressEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedWhiteCard(
      padding: const EdgeInsets.all(0.0),
      child: ListTile(
        leading: const Icon(
          kTimeIcon,
          color: CustomColors.lightTextColor,
        ),
        title: Text('$duration minutes', style: kMainButtonTextStyle),
        subtitle: const Text('duration',
            style: TextStyle(color: CustomColors.lightTextColor)),
        trailing: onPressEdit == null
            ? null
            : IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => onPressEdit!(),
              ),
      ),
    );
  }
}
