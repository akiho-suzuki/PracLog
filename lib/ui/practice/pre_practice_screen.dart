import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:praclog/models/mid_practice_data.dart';
import 'package:praclog/models/piece.dart';
import 'package:praclog/models/practice_goal.dart';
import 'package:praclog/services/auth_manager.dart';
import 'package:praclog/services/database/repertoire_database.dart';
import 'package:praclog/ui/constants.dart';
import 'package:praclog/ui/practice/practice_screen.dart';
import 'package:praclog/ui/practice/widgets/practice_goal_form.dart';
import 'package:praclog/ui/utils/show_add_piece_bottomsheet.dart';
import 'package:praclog/ui/widgets/loading_widget.dart';
import 'package:praclog/ui/widgets/main_button.dart';
import 'package:provider/provider.dart';

class PrePracticeScreen extends StatefulWidget {
  const PrePracticeScreen({Key? key}) : super(key: key);

  @override
  State<PrePracticeScreen> createState() => _PrePracticeScreenState();
}

class _PrePracticeScreenState extends State<PrePracticeScreen> {
  final _formKey = GlobalKey<FormState>();
  Piece? _selectedPiece;
  int? _selectedMovement;
  String? _goalInTextField;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  DropDownDecoratorProps _getDropDownDecoration(String hintText) =>
      DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: customBorderRadius,
              borderSide: BorderSide.none,
            )),
      );

  Widget Function(BuildContext context, String? string)
      get dropdownEmptyBuilder {
    return (context, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('No piece found'),
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    showAddPieceBottomSheet(context);
                  },
                  child: const Text('Add a piece to your repertoire'))
            ],
          ),
        );
  }

  Widget _buildPieceDropdownSearch(List<Piece> pieceList) {
    return DropdownSearch<Piece>(
      items: pieceList,
      selectedItem: _selectedPiece,
      onChanged: (Piece? value) {
        setState(() {
          _selectedPiece = value;
        });
        _selectedMovement = null;
      },
      popupProps: PopupProps.menu(emptyBuilder: dropdownEmptyBuilder),
      dropdownDecoratorProps: _getDropDownDecoration('Select piece'),
      validator: (Piece? value) {
        return value == null ? 'Required field' : null;
      },
    );
  }

  Widget _buildMovementList() {
    if (_selectedPiece != null &&
        _selectedPiece!.movements != null &&
        _selectedPiece!.movements!.isNotEmpty) {
      List<int> indices = [
        for (int i = 0; i <= (_selectedPiece!.movements!.length - 1); i++) i
      ];
      return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: DropdownSearch<int>(
          items: indices,
          itemAsString: (int? i) => _selectedPiece!.movements![i!],
          clearButtonProps: const ClearButtonProps(
            isVisible: true,
          ),
          dropdownDecoratorProps:
              _getDropDownDecoration('Select movement (optional)'),
          onChanged: (value) => _selectedMovement = value,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      // If there is a goal in the current textfield, add it to the goal list through GoalManager
      if (_goalInTextField != null && _goalInTextField!.isNotEmpty) {
        context
            .read<PracticeGoalManager>()
            .add(PracticeGoal(text: _goalInTextField!));
        _controller.clear();
        _goalInTextField = '';
      }
      // Go to next screen (PracticeScreen)
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PracticeScreen(
            pieceId: _selectedPiece!.id!,
            pieceComposer: _selectedPiece!.composer,
            pieceTitle: _selectedPiece!.title,
            movement: _selectedMovement,
            movementTitle: _selectedMovement != null
                ? _selectedPiece!.movements![_selectedMovement!]
                : null,
          ),
        ),
      );
      // In case user comes back to this screen
      MidPracticeData.setMidPracticeToFalse();
    }
  }

  @override
  Widget build(BuildContext context) {
    RepertoireDatabase repertoireDatabase = RepertoireDatabase(
        repertoireCollection:
            context.watch<AuthManager>().userRepertoireCollection);

    return Scaffold(
      appBar: AppBar(title: const Text('Start practice')),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 20.0, left: 15.0, right: 15.0, bottom: 15.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Column(
                children: [
                  StreamBuilder<List<Piece>?>(
                    stream: repertoireDatabase
                        .getSortedPiecesStream(RepertoireListSortBy.title),
                    initialData: null,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const LoadingWidget();
                      } else if (snapshot.hasData) {
                        return _buildPieceDropdownSearch(snapshot.data!);
                      } else {
                        return const Text('Error');
                      }
                    },
                  ),
                  _buildMovementList(),
                  const SizedBox(height: 10.0),
                  PracticeGoalForm(
                    onTextFieldChange: ((value) => _goalInTextField = value),
                    controller: _controller,
                    initialShowTextField: true,
                    goalTickEnabled: false,
                    onGoalAdd: () {
                      _goalInTextField = null;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 15.0),
              MainButton(
                text: ('Begin practice!'),
                onPressed: () {
                  _onSubmit();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
