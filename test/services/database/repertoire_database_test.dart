import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:praclog/custom_error.dart';
import 'package:praclog/helpers/label.dart';
import 'package:praclog/models/piece.dart';
import 'package:praclog/services/database/repertoire_database.dart';

import '../../test_data.dart';

void main() {
  // Set-up
  late CollectionReference fakeRepertoireCollection;
  late RepertoireDatabase repertoireDatabase;

  // Adds testPiece to fake collection, returns the added Piece
  Future<Piece> addTestPiece(
      CollectionReference fakeRepertoireCollection) async {
    DocumentReference doc = await fakeRepertoireCollection.add({
      Label.composer: testPieceComposer,
      Label.title: testPieceTitle,
      Label.isCurrent: true,
    });
    return Piece(
      composer: testPieceComposer,
      title: testPieceTitle,
      id: doc.id,
    );
  }

  // Adds testPiece to fake collection (as a past piece), returns the added Piece
  Future<Piece> addTestPieceNotCurrent(
      CollectionReference fakeRepertoireCollection) async {
    DocumentReference doc = await fakeRepertoireCollection.add({
      Label.composer: testPieceComposer,
      Label.title: testPieceTitle,
      Label.isCurrent: false,
    });
    return Piece(
      composer: testPieceComposer,
      title: testPieceTitle,
      id: doc.id,
    );
  }

  // Before each test, reset the fake collection and start a new RepertoireDatbase
  setUp(() {
    return Future(() async {
      fakeRepertoireCollection =
          FakeFirebaseFirestore().collection(Label.repertoire);
      repertoireDatabase =
          RepertoireDatabase(repertoireCollection: fakeRepertoireCollection);
    });
  });

  group('Adds piece', () {
    test('with no movement correctly', () async {
      await repertoireDatabase.addPiece(testPiece);
      var result = await fakeRepertoireCollection.get();
      expect(result.docs.length, 1);
      expect(result.docs.first[Label.composer], equals(testPieceComposer));
      expect(result.docs.first[Label.title], equals(testPieceTitle));
    });

    test('with movement correctly', () async {
      await repertoireDatabase.addPiece(testPieceWithMovements);
      var result = await fakeRepertoireCollection.get();
      expect(result.docs.length, 1);
      expect(result.docs.first[Label.composer], equals(testPieceComposer));
      expect(result.docs.first[Label.title], equals(testPieceTitle));
      expect(result.docs.first[Label.movements], equals(testPieceMovementList));
    });
  });

  group('Deletes piece', () {
    test('correctly', () async {
      // Add piece directly to fake collection
      Piece addedPiece = await addTestPiece(fakeRepertoireCollection);
      var result = await fakeRepertoireCollection.get();
      expect(result.docs.length, 1);

      // Delete
      await repertoireDatabase.deletePiece(addedPiece);

      // Check that it's deleted
      result = await fakeRepertoireCollection.get();
      expect(result.docs.length, 0);
    });
  });

  group('Edits piece', () {
    test('edits piece', () async {
      // Add piece directly to fake collection
      Piece addedPiece = await addTestPiece(fakeRepertoireCollection);

      // Before editing
      var result = await fakeRepertoireCollection.get();
      var doc = result.docs.first;
      expect(doc[Label.composer], equals(testPieceComposer));
      expect(doc[Label.title], equals(testPieceTitle));

      // Edit
      const newTitle = 'New title';
      const newComposer = 'Another dead white man';

      Piece newPiece = Piece(
        title: newTitle,
        composer: newComposer,
        id: addedPiece.id,
      );

      await repertoireDatabase.editPiece(newPiece);

      // Check that it's edited
      result = await fakeRepertoireCollection.get();
      doc = result.docs.first;
      expect(doc[Label.composer], equals(newComposer));
      expect(doc[Label.title], equals(newTitle));
    });
  });

  group('Toggles piece status between current and past', () {
    test('toggles status of piece from current to past', () async {
      var addedPiece = await addTestPiece(fakeRepertoireCollection);

      // Before toggling
      var result = await fakeRepertoireCollection.get();
      var doc = result.docs.first;
      expect(doc[Label.isCurrent], equals(true));

      // Toggle state to past
      await repertoireDatabase.toggleIsCurrent(addedPiece);

      // Check that it has been toggled
      result = await fakeRepertoireCollection.get();
      doc = result.docs.first;
      expect(doc[Label.isCurrent], equals(false));
    });
    // TODO test for when piece is not found.
  });

  group('Gets piece from ID:', () {
    test('returns piece', () async {
      Piece addedPiece = await addTestPiece(fakeRepertoireCollection);
      final id = addedPiece.id;
      Piece retrievedPiece = await repertoireDatabase.getPieceById(id!);
      expect(retrievedPiece.id, equals(id));
      expect(retrievedPiece.composer, equals(testPieceComposer));
      expect(retrievedPiece.title, equals(testPieceTitle));
    });

    test('throws exception if piece does not exist', () async {
      var result = await repertoireDatabase.getPieceById(testPieceId);
      expect(result, isA<CustomError>());
    });
  });

//   test('Returns one-time read of pieces', () async {
//     for (int i = 0; i < 5; i++) {
//       await addTestPiece(fakeRepertoireCollection);
//     }
//     List<Piece>? result = await repertoireDatabase.repertoireList;
//     expect(result!.length, equals(5));
//     expect(result.last.composer, equals(testPieceComposer));
//   });

//   test('Returns one-time read of current pieces', () async {
//     for (int i = 0; i < 5; i++) {
//       await addTestPiece(fakeRepertoireCollection);
//     }

//     for (int i = 0; i < 5; i++) {
//       await addTestPieceNotCurrent(fakeRepertoireCollection);
//     }

//     List<Piece>? result = await repertoireDatabase.currentRepertoireList;
//     expect(result!.length, equals(5));
//     expect(result.last.composer, equals(testPieceComposer));
//   });

//   test('Deletes logs associated with piece', () async {
//     // Setting up fake log collection
//     CollectionReference fakeLogCollection =
//         FakeFirebaseFirestore().collection(Label.logs);

//     List<String> dummyLogContent = ['aaa', 'bbb', 'ccc', 'ddd', 'eee'];
//     var piece = await addTestPiece(fakeRepertoireCollection);

//     for (String data in dummyLogContent) {
//       // Create fake logs using dummy data
//       var dummyLog = await fakeLogCollection.add({'dummyContent': data});

//       // Add the IDs of fake logs to the PieceLogList
//       fakeRepertoireCollection
//           .doc(piece.id)
//           .collection(Label.pieceLogList)
//           .add({Label.logId: dummyLog.id});
//     }

//     var logs = await fakeLogCollection.get();
//     expect(logs.docs.length, equals(5));

//     // Delete logs
//     await repertoireDatabase.deletePieceLogs(piece.id!, fakeLogCollection);

//     // Check
//     logs = await fakeLogCollection.get();
//     expect(logs.docs.length, equals(0));
//   });
}
