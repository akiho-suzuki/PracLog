import 'package:flutter/material.dart';
import 'package:praclog/ui/repertoire/widgets/repertoire_list.dart';

class PastRepertoireScreen extends StatelessWidget {
  const PastRepertoireScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Past pieces'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(15.0),
        child: RepertoireList(showCurrent: false),
      ),
    );
  }
}
