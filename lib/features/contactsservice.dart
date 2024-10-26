import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class Contactsservice {
  Future<List<Contact>> fetchcontacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission(readonly: true)) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }
}
