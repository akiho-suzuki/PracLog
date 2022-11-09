import 'package:flutter/material.dart';
import 'package:praclog/helpers/shared_pref_refs.dart';
import 'package:praclog/ui/constants.dart';
import 'package:praclog/models/piece.dart';
import 'package:praclog/services/auth_manager.dart';
import 'package:praclog/services/database/repertoire_database.dart';
import 'package:praclog/ui/repertoire/widgets/movement_alert_dialog.dart';
import 'package:praclog/ui/theme/custom_colors.dart';
import 'package:praclog/ui/widgets/main_button.dart';
import 'package:praclog/ui/widgets/rounded_white_card.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _titleEmptyErrorMsg = 'Title cannot be blank';
const String _composerEmptyErrorMsg = 'Composer cannot be blank';
const String _movementEditWarningMsg =
    'Number of movements cannot be changed later';
const TextStyle _numberDisplayStyle = TextStyle(fontSize: 20.0);
const TextStyle _movementEditWarningStyle =
    TextStyle(fontSize: 10.0, color: CustomColors.lightTextColor);
const Icon _warningIcon =
    Icon(Icons.info, size: 14.0, color: CustomColors.lightTextColor);

class AddPieceBottomSheet extends StatefulWidget {
  const AddPieceBottomSheet({Key? key}) : super(key: key);

  @override
  State<AddPieceBottomSheet> createState() => _AddPieceBottomSheetState();
}

class _AddPieceBottomSheetState extends State<AddPieceBottomSheet> {
  // For the form
  final formKey = GlobalKey<FormState>();
  final composerController = TextEditingController();
  final titleController = TextEditingController();
  int _mvtNo = 0;

  Future _onSubmit() async {
    AuthManager authManager = context.read<AuthManager>();
    // Show warning about movement edits (if necessary)
    // Check if it needs to be shown
    final prefs = await SharedPreferences.getInstance();
    final bool showWarning =
        prefs.getBool(SharedPrefRefs.noShowMvtWarning) ?? false;
    if (showWarning == false) {
      bool? response = await showDialog(
          context: context, builder: (context) => const MovementAlertDialog());
      if (response == null || response == false) {
        return;
      }
    }

    // Create the piece
    List<String>? movements;
    if (_mvtNo > 0) {
      movements = [];
      for (int i = 1; i <= _mvtNo; i++) {
        movements.add('Movement $i');
      }
    }
    Piece piece = Piece(
        composer: composerController.text,
        title: titleController.text,
        movements: movements);

    RepertoireDatabase(
            repertoireCollection: authManager.userRepertoireCollection)
        .addPiece(piece);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  /// Increases `_mvtNo` by 1.
  void _incCounter() => setState(() {
        _mvtNo++;
      });

  /// Decreases `_mvtNo` by 1.
  void _decCounter() {
    if (_mvtNo > 0) {
      setState(() {
        _mvtNo--;
      });
    }
  }

  @override
  void dispose() {
    composerController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: CustomColors.backgroundColor),
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            const Center(
              child: Text(
                'Add a new piece',
                style: kBottomSheetTitle,
              ),
            ),
            const SizedBox(height: 15.0),
            RoundedWhiteCard(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Composer textfield
                  const Text('Composer'),
                  TextFormField(
                    controller: composerController,
                    validator: (value) => (value == null || value.isEmpty)
                        ? _composerEmptyErrorMsg
                        : null,
                  ),
                  const SizedBox(height: 15.0),

                  // Title textfield
                  const Text('Title'),
                  TextFormField(
                    controller: titleController,
                    validator: (value) => (value == null || value.isEmpty)
                        ? _titleEmptyErrorMsg
                        : null,
                  ),
                  const SizedBox(height: 15.0),

                  // Movement number picker
                  Row(
                    children: [
                      const Text('Number of movements'),
                      const SizedBox(width: 20.0),
                      // - decrement button
                      _IncrementButton(
                        onPressed: () => _decCounter(),
                        icon: Icons.remove,
                      ),
                      // Number display
                      Text(
                        _mvtNo.toString(),
                        style: _numberDisplayStyle,
                      ),
                      // + increment button
                      _IncrementButton(
                          onPressed: () => _incCounter(), icon: Icons.add),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  // Movement number edit warning
                  Row(
                    children: const [
                      _warningIcon,
                      SizedBox(width: 15.0),
                      Text(
                        _movementEditWarningMsg,
                        style: _movementEditWarningStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15.0),
            // Submit button
            MainButton(
              text: 'Save',
              onPressed: () {
                if (formKey.currentState!.validate() && (_mvtNo >= 0)) {
                  _onSubmit();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _IncrementButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  const _IncrementButton({
    Key? key,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          elevation: 0.0,
          side: const BorderSide(color: CustomColors.primaryColor),
          primary: Colors.white,
          onPrimary: CustomColors.primaryColor),
      onPressed: onPressed,
      child: Icon(icon, color: CustomColors.primaryColor),
    );
  }
}
