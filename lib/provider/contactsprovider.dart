import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class Contactsprovider extends ChangeNotifier {
  List<Contact> _contact = [];
  List<Contact> get contacts => _contact;
  Future<void> fetchcontacts() async {
    if (await FlutterContacts.requestPermission()) {
      _contact = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      notifyListeners();
    } else {
      print("denied contacts permission");
    }
  }
}
