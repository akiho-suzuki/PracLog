import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:praclog/helpers/label.dart';

class AuthManager {
  /// Firebase authentication (pass `FirebaseAuth.instance`)
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  AuthManager(this._auth, this._googleSignIn);

  /// Returns current user.
  ///
  /// NOTE: Only to be called when user is signed in (therefore should never be `null`)
  User get currentUser => _auth.currentUser!;

  /// A stream that listens to authentication state changes.
  Stream<User?> get authChangeStream => _auth.authStateChanges();

  bool get userEmailVerified => currentUser.emailVerified;

  DateTime? get accountCreationDate => currentUser.metadata.creationTime;

  /// Returns current user's repertoire collection. Should only be called when user is logged in.
  CollectionReference get userRepertoireCollection => FirebaseFirestore.instance
      .collection(Label.users)
      .doc(currentUser.uid)
      .collection(Label.repertoire);

  /// Returns current user's log collection. Should only be called when user is logged in.
  CollectionReference get userLogCollection => FirebaseFirestore.instance
      .collection(Label.users)
      .doc(currentUser.uid)
      .collection(Label.logs);

  /// Returns current user's pieceStats collection for a piece with `pieceId`.
  CollectionReference userPieceStatsCollection(String pieceId) =>
      userRepertoireCollection.doc(pieceId).collection(Label.pieceStats);

  /// Returns current user's log collection. Should only be called when user is logged in.
  CollectionReference get userWeekDataCollection => FirebaseFirestore.instance
      .collection(Label.users)
      .doc(currentUser.uid)
      .collection(Label.weekData);

  /// Returns true if current user is signed in with Google.
  bool get signedInWithGoogle {
    if (_auth.currentUser != null) {
      List<String> providerIdList = [];
      for (final providerProfile in currentUser.providerData) {
        // Get ID of the provider (google.com, apple.cpm, etc.) and add to providerIdList
        providerIdList.add(providerProfile.providerId);
      }
      return providerIdList.contains('google.com') ? true : false;
    } else {
      return false;
    }
  }

  /// Returns current user's Google account
  GoogleSignInAccount? get googleAccount {
    return _googleSignIn.currentUser;
  }

  /// Registers a new user with email and password. Returns error if there is one; otherwise returns `null`.
  Future registerWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (result.user != null) {
        await sendEmailVerification();
        return null;
      }
    } on FirebaseAuthException catch (e) {
      return e;
    }
  }

  /// Log in with email and password. Returns error if there is one; otherwise returns `null`.
  Future logInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      return e;
    }
  }

  Future<String?> sendEmailVerification() async {
    try {
      if (_auth.currentUser != null) {
        await _auth.currentUser!.sendEmailVerification();
        return 'Email verification sent!';
      } else {
        return null;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<OAuthCredential?> _getGoogleAuthCredential() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create and return new credential
      return GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
    } catch (e) {
      return null;
    }
  }

  // Google sign in
  Future signInWithGoogle() async {
    try {
      // Get google oAuth credential
      final credential = await _getGoogleAuthCredential();
      if (credential != null) {
        // Sign in
        await _auth.signInWithCredential(credential);
      }
    } catch (e) {
      return e;
    }
  }

  // Sign out
  Future signOut() async {
    try {
      if (signedInWithGoogle) {
        await _googleSignIn.disconnect();
      }
      await _auth.signOut();
      return null;
    } catch (e) {
      return e;
    }
  }

  /// Delete account. Returns `FirebaseException` if there is one.
  ///
  /// Should only be called when user is signed in.
  Future deleteAccount(String? password, {bool googleUser = false}) async {
    // For non-google accounts (i.e. email/password), password cannot be null
    if (!googleUser && password == null) {
      throw ArgumentError(
          'Password should not be null for an email/password account');
    }
    try {
      AuthCredential? credential;
      // Get credential
      if (signedInWithGoogle) {
        // Get google oAuth credential
        credential = await _getGoogleAuthCredential();
      } else {
        credential = EmailAuthProvider.credential(
            email: currentUser.email!, password: password!);
      }

      // Reauthenticate
      if (credential != null) {
        await currentUser.reauthenticateWithCredential(credential);
      }

      // Delete
      await currentUser.delete();
      if (googleUser) {
        await _googleSignIn.disconnect();
      } else {
        await _auth.signOut();
      }
    } on FirebaseException catch (e) {
      return e;
    }
  }

  Future updatePassword(String oldPassword, String newPassword) async {
    try {
      // Reauthenticate
      AuthCredential credential = EmailAuthProvider.credential(
          email: currentUser.email!, password: oldPassword);
      await currentUser.reauthenticateWithCredential(credential);
      // Update password
      await currentUser.updatePassword(newPassword);
    } on FirebaseException catch (e) {
      return e;
    }
  }

  Future sendResetPasswordEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseException catch (e) {
      return e;
    }
  }
}
