

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_contact_list_app/Modal/contacts.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StorageHelper {

  static const String KEY = "CONTACTS";

  static Future<String> getFromPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY) ?? null;
  }

  static Future<bool> saveImageToPreferences(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(KEY, value);
  }

  static String encode(List<ContactSaved> contact_saved) => json.encode(
    contact_saved
        .map<Map<String, dynamic>>((contact_saved) =>ContactSaved.toMap(contact_saved))
        .toList(),
  );

  static List<ContactSaved> decode(String savedContact) =>
      (json.decode(savedContact) as List<dynamic>)
          .map<ContactSaved>((item) =>ContactSaved.fromJson(item))
          .toList();


  static save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    String encoded = StorageHelper.encode(value);
    prefs.setString(key, encoded);
  }

  static read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getString(key) == null  ){
      return null;
    }
    List<ContactSaved> decode = StorageHelper.decode(prefs.getString(key));
    return decode;
  }
}