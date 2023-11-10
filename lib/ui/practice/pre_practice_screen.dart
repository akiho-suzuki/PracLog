import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:praclog_v2/collections/log.dart';
import 'package:praclog_v2/collections/piece.dart';
import 'package:praclog_v2/constants.dart';
import 'package:praclog_v2/helpers/practice_goal_manager.dart';
import 'package:praclog_v2/services/log_database.dart';
import 'package:praclog_v2/services/pieces_database.dart';
import 'package:praclog_v2/ui/practice/practice_screen.dart';
import 'package:praclog_v2/ui/practice/widgets/practice_goal_form.dart';
import 'package:praclog_v2/ui/widgets/loading_widget.dart';
import 'package:praclog_v2/ui/widgets/main_button.dart';
import 'package:praclog_v2/utils/show_add_piece_sheet.dart';
import 'package:provider/provider.dart';

class PrePracticeScreen extends StatefulWidget {
  final Isar isar;
  const PrePracticeScreen({super.key, required this.isar});

  @override
  State<PrePracticeScreen> createState() => _PrePracticeScreenState();
}

class _PrePracticeScreenState extends State<PrePracticeScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _goalInTextField;
  final TextEditingController _controller = TextEditingController();
  Piece? _selectedPiece;
  int? _selectedMovement;

  _onSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      PracticeGoalManager goalManager = context.read<PracticeGoalManager>();
      // If there is a goal in the current textfield, add it to the goal list through GoalManager
      if (_goalInTextField != null && _goalInTextField!.isNotEmpty) {
        PracticeGoal goal = PracticeGoal()
          ..text = _goalInTextField!
          ..isTicked = false;
        goalManager.add(goal);
        _controller.clear();
        _goalInTextField = '';
      }

      Log? savedLog = await LogDatabase(isar: widget.isar).startPractice(
          _selectedPiece!,
          DateTime.now(),
          _selectedMovement,
          goalManager.goalList);
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PracticeScreen(
              isar: widget.isar,
              log: savedLog,
              piece: _selectedPiece!,
              movement: _selectedMovement,
            ),
          ),
        );
      }
    }
  }

// Decoration for the dropdown search widget
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

  // To show in the dropdown when there is no piece in the database
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
                    showAddPieceSheet(context, widget.isar);
                  },
                  child: const Text('Add a piece to your repertoire'))
            ],
          ),
        );
  }

  // The dropdown search to select piece
  Widget _buildPieceDropdownSearch(List<Piece> pieceList) {
    return DropdownSearch<Piece>(
      items: pieceList,
      itemAsString: (piece) => "${piece.composer}: ${piece.title}",
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

  // The dropdown search to select movement
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

  @override
  Widget build(BuildContext context) {
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
                    stream: PiecesDatabase(isar: widget.isar)
                        .getSortedPiecesStream(PiecesSortBy.title),
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
                  )
                ],
              ),
              const SizedBox(height: 15.0),
              MainButton(
                text: ('Begin practice!'),
                onPressed: () {
                  _onSubmit(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
