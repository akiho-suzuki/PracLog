import 'package:flutter/material.dart';
import 'package:praclog/ui/repertoire/widgets/repertoire_list.dart';

class RepertoireScreen extends StatelessWidget {
  const RepertoireScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const RepertoireList(showCurrent: true);
  }
}
