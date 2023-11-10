import 'package:flutter/material.dart';
import 'package:praclog_v2/collections/piece.dart';
import 'package:praclog_v2/constants.dart';
import 'package:praclog_v2/ui/widgets/rounded_white_card.dart';

class PieceInfoTile extends StatelessWidget {
  final Piece piece;
  final int? movementIndex;
  PieceInfoTile({
    Key? key,
    required this.piece,
    this.movementIndex,
  })  :
        // If it's a movement, the piece must contain movements
        assert(movementIndex != null ? piece.movements != null : true),
        super(key: key);

  Widget getMovementInfo() {
    if (movementIndex != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5.0),
          Text('${movementIndex! + 1}. ${piece.movements![movementIndex!]}',
              style: const TextStyle(color: kLightTextColor)),
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
          Text('${piece.composer}: ${piece.title}',
              style: kMainButtonTextStyle),
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
          color: kLightTextColor,
        ),
        title: Text('$duration minutes', style: kMainButtonTextStyle),
        subtitle:
            const Text('duration', style: TextStyle(color: kLightTextColor)),
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
