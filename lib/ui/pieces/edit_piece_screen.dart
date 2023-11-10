import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:praclog_v2/collections/piece.dart';
import 'package:praclog_v2/constants.dart';
import 'package:praclog_v2/helpers/null_empty_helpers.dart';
import 'package:praclog_v2/services/pieces_database.dart';
import 'package:praclog_v2/ui/pieces/piece_info_screen.dart';
import 'package:praclog_v2/ui/widgets/custom_scaffold.dart';
import 'package:praclog_v2/ui/widgets/main_button.dart';
import 'package:praclog_v2/ui/widgets/rounded_white_card.dart';

class EditPieceScreen extends StatefulWidget {
  final Piece piece;
  final Isar isar;
  const EditPieceScreen({
    Key? key,
    required this.piece,
    required this.isar,
  }) : super(key: key);

  @override
  State<EditPieceScreen> createState() => _EditPieceScreenState();
}

class _EditPieceScreenState extends State<EditPieceScreen> {
  // For the form
  final formKey = GlobalKey<FormState>();
  late final TextEditingController composerController;
  late final TextEditingController titleController;
  List<TextEditingController> movementControllers = [];

  @override
  void initState() {
    composerController = TextEditingController(text: widget.piece.composer);
    titleController = TextEditingController(text: widget.piece.title);
    super.initState();
  }

  @override
  void dispose() {
    composerController.dispose();
    titleController.dispose();
    for (TextEditingController controller in movementControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future _onSubmit(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      // Get all the movements currently held in controllers
      List<String> newMovements = [];
      for (TextEditingController controller in movementControllers) {
        newMovements.add(controller.text);
      }

      // Create a piece with new info
      final newPiece = widget.piece
        ..title = titleController.text
        ..composer = composerController.text
        ..movements = newMovements;

      // Edit the piece in db
      await PiecesDatabase(isar: widget.isar).editPiece(newPiece);

      // Go to `PieceInfoScreen` for the piece
      if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PieceInfoScreen(isar: widget.isar, piece: newPiece)),
            ((route) => route.isFirst));
      }
    }
  }

  Widget _movementList() {
    if (widget.piece.movements.isNotNullOrEmpty) {
      List<Widget> children = [const Text('Movements')];
      for (int i = 0; i < widget.piece.movements!.length; i++) {
        // Create a controller for the movement
        movementControllers
            .add(TextEditingController(text: widget.piece.movements![i]));
        // Add a TextField for the movement with the newly created controller
        children.add(
          Row(
            children: [
              Text('${i + 1}.'),
              const SizedBox(width: 4.0),
              Expanded(
                child: TextFormField(
                  controller: movementControllers[i],
                  validator: validatorFunc,
                ),
              ),
              buildUndoButton(
                  controller: movementControllers[i],
                  defaultText: widget.piece.movements![i]),
            ],
          ),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  String? Function(String?) validatorFunc = (String? value) {
    if (value == null || value.isEmpty) {
      return 'Cannot be blank';
    } else {
      return null;
    }
  };

  // Returns an 'undo' icon button that restores the value of the textfield to the initial value
  IconButton buildUndoButton(
      {required TextEditingController controller,
      required String defaultText}) {
    return IconButton(
      onPressed: () {
        controller.text = defaultText;
      },
      splashRadius: 25.0,
      icon: const Icon(Icons.undo, size: 20.0, color: kLightTextColor),
    );
  }

// For building textfield for Composer and Title, with an undo button
  Widget buildTextField(
      {required TextEditingController controller,
      required String defaultText}) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            validator: validatorFunc,
          ),
        ),
        buildUndoButton(controller: controller, defaultText: defaultText),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarTitle: 'Edit piece',
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            RoundedWhiteCard(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Composer textfield
                  const Text('Composer'),
                  buildTextField(
                      controller: composerController,
                      defaultText: widget.piece.composer),
                  const SizedBox(height: 15.0),
                  // Title textfield
                  const Text('Title'),
                  buildTextField(
                      controller: titleController,
                      defaultText: widget.piece.title),
                  const SizedBox(height: 15.0),
                  _movementList(),
                ],
              ),
            ),
            const SizedBox(height: 15.0),
            MainButton(
              text: 'Save',
              onPressed: () {
                _onSubmit(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
