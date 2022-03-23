// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class SiteModel {
  final String apiKey;
  final Timestamp mainten1;
  final Timestamp mainten2;
  final Timestamp mainten3;
  final String name;
  final String pinCode;
  SiteModel({
    required this.apiKey,
    required this.mainten1,
    required this.mainten2,
    required this.mainten3,
    required this.name,
    required this.pinCode,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'apiKey': apiKey,
      'mainten1': mainten1,
      'mainten2': mainten2,
      'mainten3': mainten3,
      'name': name,
      'pinCode': pinCode,
    };
  }

  factory SiteModel.fromMap(Map<String, dynamic> map) {
    return SiteModel(
      apiKey: (map['apiKey'] ?? '') as String,
      mainten1: (map['mainten1']),
      mainten2: (map['mainten2']),
      mainten3: (map['mainten3']),
      name: (map['name'] ?? '') as String,
      pinCode: (map['pinCode'] ?? '') as String,
    );
  }

  factory SiteModel.fromJson(String source) =>
      SiteModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
