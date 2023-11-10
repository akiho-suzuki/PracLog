import 'package:flutter/material.dart';
import 'package:praclog_v2/constants.dart';
import 'package:praclog_v2/ui/widgets/rounded_white_card.dart';

class RatingScale extends StatefulWidget {
  final String title;
  final Icon icon;
  final ValueChanged<int> onChanged;
  final int? initialValue;
  const RatingScale({
    Key? key,
    required this.icon,
    required this.title,
    required this.onChanged,
    this.initialValue,
  }) : super(key: key);

  @override
  State<RatingScale> createState() => _RatingScaleState();
}

class _RatingScaleState extends State<RatingScale> {
  int? _selectedValue;
  bool _isExpanded = false;

  List<RatingButton> buildRatingButtonList() {
    List<RatingButton> list = [];
    for (int i in [1, 2, 3, 4, 5]) {
      list.add(RatingButton(
        isSelected: _selectedValue == i,
        number: i,
        onPressed: () {
          setState(() {
            _selectedValue = i;
          });
          widget.onChanged(i);
        },
      ));
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return RoundedWhiteCard(
      padding: const EdgeInsets.all(0.0),
      child: ExpansionTile(
        initiallyExpanded: widget.initialValue != null,
        leading: widget.icon,
        trailing: _isExpanded
            ? null
            : (_selectedValue != null ? Text(_selectedValue.toString()) : null),
        title: Text(widget.title),
        textColor: kMainTextColor,
        iconColor: kLightTextColor,
        onExpansionChanged: (bool value) {
          setState(() {
            _isExpanded = value;
          });
        },
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: buildRatingButtonList())
        ],
      ),
    );
  }
}

class RatingButton extends StatelessWidget {
  final int number;
  final VoidCallback onPressed;
  final bool isSelected;
  const RatingButton({
    Key? key,
    required this.number,
    required this.onPressed,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 2.0,
        bottom: 2.0,
      ),
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: isSelected
              ? MaterialStateProperty.all(Colors.blue[200])
              : MaterialStateProperty.all(
                  Colors.grey[200],
                ),
        ),
        child: Text(
          number.toString(),
          style: TextStyle(
            color: isSelected ? kPrimaryColor : kLightTextColor,
          ),
        ),
      ),
    );
  }
}
