import 'package:flutter/material.dart';
import 'package:praclog/models/piece.dart';
import 'package:praclog/services/auth_manager.dart';
import 'package:praclog/services/database/log_database.dart';
import 'package:praclog/services/database/repertoire_database.dart';
import 'package:praclog/ui/repertoire/piece_info_screen.dart';
import 'package:praclog/ui/theme/custom_colors.dart';
import 'package:praclog/ui/widgets/custom_scaffold.dart';
import 'package:praclog/ui/widgets/main_button.dart';
import 'package:praclog/ui/widgets/rounded_white_card.dart';
import 'package:provider/provider.dart';
import '../../helpers/null_empty_helper.dart';

class EditPieceScreen extends StatefulWidget {
  final Piece piece;
  const EditPieceScreen({
    Key? key,
    required this.piece,
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

  void _onSubmit(BuildContext context) {
    if (formKey.currentState!.validate()) {
      // Get all the movements currently held in controllers
      List<String> newMovements = [];
      for (TextEditingController controller in movementControllers) {
        newMovements.add(controller.text);
      }

      // Create a piece with new info
      Piece newPiece = Piece(
        id: widget.piece.id,
        title: titleController.text,
        composer: composerController.text,
        movements: newMovements,
        isCurrent: widget.piece.isCurrent,
      );

      AuthManager authManager = context.read<AuthManager>();

      Piece.editPiece(
          piece: newPiece,
          logDatabase:
              LogDatabase(logCollection: authManager.userLogCollection),
          repertoireDatabase: RepertoireDatabase(
              repertoireCollection: authManager.userRepertoireCollection));

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => PieceInfoScreen(piece: newPiece),
          ),
          (route) => route.isFirst);
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
      icon: const Icon(
        Icons.undo,
        size: 20.0,
        color: CustomColors.lightTextColor,
      ),
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
