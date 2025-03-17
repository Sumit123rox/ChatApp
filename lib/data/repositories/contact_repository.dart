import 'dart:developer';

import 'package:chat_app/data/models/user_model.dart';
import 'package:chat_app/data/repositories/base_repository.dart';
import 'package:chat_app/data/services/service.locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactRepository extends BaseRepository {
  final FirebaseFirestore _firestore = locator<FirebaseFirestore>();

  Future<bool> checkPermission() async {
    return await FlutterContacts.requestPermission();
  }

  Future<List<Map<String, dynamic>>> getContacts() async {
    try {

      // Check if we have permission to access contacts
      final hasPermission = await checkPermission();
      if (!hasPermission) {
        log('Contact permission denied');
        return [];
      }


      // Get all contacts
      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
      );

      // Extract the Contacts and Normalize them
      final normalizedContacts =
          contacts
              .where((contact) => contact.phones.isNotEmpty)
              .map(
                (contacts) => {
                  'name': contacts.displayName,
                  'phoneNumber': contacts.phones.first.number.replaceAll(
                    RegExp(r'\s+'),
                    "".trim(),
                  ),
                  'photo': contacts.photo,
                },
              )
              .toList();

      // Get the Contacts from Firebase
      final firebaseContacts = await _firestore.collection('users').get();
      final firebaseContactsList =
          firebaseContacts.docs
              .map((doc) => UserModel.fromFirestore(doc))
              .toList();

      // Match the Contacts with Firebase Contacts
      final matchedContacts =
          normalizedContacts
              .where(
                (contact) => firebaseContactsList.any(
                  (firebaseContact) =>
                      firebaseContact.phoneNumber == contact['phoneNumber'] &&
                      firebaseContact.uid != uid,
                ),
              )
              .map((contact) {
                final registeredUser = firebaseContactsList.firstWhere(
                  (user) => user.phoneNumber == contact['phoneNumber'],
                );
                return {
                  'id': registeredUser.uid,
                  'name': contact['name'],
                  'phoneNumber': contact['phoneNumber'],
                  'photo': contact['photo'],
                };
              })
              .toList();

      return matchedContacts;
    } catch (e) {
      log('Error getting contacts: $e');
      return [];
    }
  }
}
