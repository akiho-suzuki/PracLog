import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:praclog/custom_error.dart';
import '../../models/piece.dart';
import '../../helpers/label.dart';

/// Repertoire list sorting options (`title` or `composer`)
enum RepertoireListSortBy { title, composer }

class RepertoireDatabase {
  final CollectionReference repertoireCollection;
  RepertoireDatabase({required this.repertoireCollection});

  CollectionReference get convertedRepertoireCollection =>
      repertoireCollection.withConverter<Piece>(
        fromFirestore: (snapshot, _) =>
            Piece.fromJson(snapshot.id, snapshot.data()!),
        toFirestore: (piece, _) => piece.toJson(),
      );

  // Add piece
  Future addPiece(Piece piece) async {
    try {
      await convertedRepertoireCollection.add(piece);
    } on FirebaseException catch (e) {
      print(e);
      return e;
    }
  }

  // Delete piece
  Future deletePiece(Piece piece) async {
    try {
      await repertoireCollection.doc(piece.id).delete();
    } on FirebaseException catch (e) {
      print(e);
      return e;
    }
  }

  /// Edits piece. Finds the current piece via its ID then overwrites it with the new piece
  ///
  /// Note: Users cannot change the number of movements after initial creation of piece.
  Future editPiece(Piece piece) async {
    try {
      await convertedRepertoireCollection.doc(piece.id).set(piece);
    } on FirebaseException catch (e) {
      print(e);
      return e;
    }
  }

  // Toggle current/past status
  Future toggleIsCurrent(Piece piece) async {
    try {
      await repertoireCollection
          .doc(piece.id)
          .update({Label.isCurrent: piece.isCurrent ? false : true});
    } on FirebaseException catch (e) {
      await FirebaseCrashlytics.instance
          .recordError(e, e.stackTrace, reason: 'a non-fatal error');
      return e;
    }
  }

  /// Get piece by id. Throws an exception if no document with the ID is found, which is caught and reported to Crashlytics
  Future getPieceById(String id) async {
    try {
      DocumentSnapshot snapshot =
          await convertedRepertoireCollection.doc(id).get();
      if (!snapshot.exists) {
        throw CustomError('Piece not found. ID: $id');
      }
      return snapshot.data() as Piece;
    } on FirebaseException catch (e) {
      return e;
    }
  }

  // Get movements as a list of strings (from List<dynamic> from QuerySnapshot)
  List<String>? _movementList(List<dynamic> data) {
    List<String>? list = [];
    for (var entry in data) {
      list.add(entry.toString());
    }
    return list;
  }

  // Turn repertoire querysnapshot into a list of pieces
  List<Piece>? _getPiecesFromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => Piece(
              id: doc.id,
              title: doc[Label.title],
              composer: doc[Label.composer],
              isCurrent: doc[Label.isCurrent],
              movements: doc[Label.movements] != null
                  ? _movementList(doc[Label.movements])
                  : null,
            ))
        .toList();
  }

  /// Get user's repertoire as a stream of list of pieces
  Stream<List<Piece>?> getSortedPiecesStream(RepertoireListSortBy sortBy,
      {bool showCurrent = true}) {
    return repertoireCollection
        .where(Label.isCurrent, isEqualTo: showCurrent)
        .orderBy(
            sortBy == RepertoireListSortBy.title ? Label.title : Label.composer)
        .snapshots()
        .map(
          (snapshot) => _getPiecesFromSnapshots(snapshot),
        );
  }
}
