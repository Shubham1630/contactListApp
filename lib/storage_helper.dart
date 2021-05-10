

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';


// class StorageHelper {
//
//   static const String KEY = "QR_CODE";
//
//   static Future<String> getFromPreferences() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(KEY) ?? null;
//   }
//
//   static Future<bool> saveImageToPreferences(String value) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.setString(KEY, value);
//   }
//
//   static String encode(List<Contact> saved_image) => json.encode(
//     saved_image
//         .map<Map<String, dynamic>>((saved_image) => QRCode.toMap(saved_image))
//         .toList(),
//   );
//
//   static List<QRCode> decode(String saved_images) =>
//       (json.decode(saved_images) as List<dynamic>)
//           .map<QRCode>((item) =>QRCode.fromJson(item))
//           .toList();
//
//
//   static save(String key, value) async {
//     final prefs = await SharedPreferences.getInstance();
//     String encoded = StorageHelper.encode(value);
//     prefs.setString(key, encoded);
//   }
//
//   static read(String key) async {
//     final prefs = await SharedPreferences.getInstance();
//     if(prefs.getString(key) == null  ){
//       return null;
//     }
//     List<QRCode> decode = StorageHelper.decode(prefs.getString(key));
//     return decode;
//   }
// }