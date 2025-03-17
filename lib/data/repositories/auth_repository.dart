import 'dart:async';
import 'dart:developer';

import 'package:chat_app/data/models/user_model.dart';
import 'package:chat_app/data/repositories/base_repository.dart';
import 'package:chat_app/data/services/service.locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository extends BaseRepository {
  final FirebaseAuth _auth = locator<FirebaseAuth>();
  final FirebaseFirestore _firestore = locator<FirebaseFirestore>();

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
    required String username,
    required String phone,
  }) async {
    try {
      final formattedPhoneNumber = phone.replaceAll(RegExp(r'\s+'), "".trim());

      if (await checkEmailExists(email)) {
        throw Exception('Email already exists');
      }
      if (await checkPhoneNumberExists(formattedPhoneNumber)) {
        throw Exception('Phone number already exists');
      }
      if (await checkUsernameExists(username)) {
        throw Exception('Username already exists');
      }

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        throw Exception('Failed to create user');
      }

      //Create a user model and save the user in the firebase DB.
      final user = UserModel(
        uid: userCredential.user!.uid,
        fullName: name,
        username: username,
        email: email,
        phoneNumber: formattedPhoneNumber,
      );

      await saveUserData(user);

      return user;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Failed to sign in');
      }

      if (userCredential.user == null) {
        throw Exception('User data not found');
      }

      final userModel = await getUserData(userCredential.user!.uid);

      return userModel;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  // Save user data in the firebase DB.
  Future<void> saveUserData(UserModel user) async {
    try {
      _firestore.collection('users').doc(user.uid).set(user.toMap());
    } catch (e) {
      log(e.toString());
      throw "Failed to save user data";
    }
  }

  // Get user data in the firebase DB.
  Future<UserModel> getUserData(String uid) async {
    log("Get User Data");
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        throw Exception('User data not found');
      }
      log("Userid: ${doc.id}");
      return UserModel.fromFirestore(doc);
    } catch (e) {
      log(e.toString());
      throw "Failed to get user data";
    }
  }

  // Sign Out user from App.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Check if email exists in the firebase DB.
  Future<bool> checkEmailExists(String email) async {
    try {
      final doc =
          await _firestore
              .collection('users')
              .where('email', isEqualTo: email)
              .get();
      return doc.docs.isNotEmpty;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  // Check if phone number exists in the firebase DB.
  Future<bool> checkPhoneNumberExists(String phoneNumber) async {
    try {
      final formattedPhoneNumber = phoneNumber.replaceAll(
        RegExp(r'\s+'),
        "".trim(),
      );
      final doc =
          await _firestore
              .collection('users')
              .where('phoneNumber', isEqualTo: formattedPhoneNumber)
              .get();
      return doc.docs.isNotEmpty;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  // Check if username exists in the firebase DB.
  Future<bool> checkUsernameExists(String username) async {
    try {
      final doc =
          await _firestore
              .collection('users')
              .where('username', isEqualTo: username)
              .get();
      return doc.docs.isNotEmpty;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  
}
