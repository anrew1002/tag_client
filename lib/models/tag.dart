import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
class Tag {
  String ID;
  String? alias;
  // String pass;
  Tag({
    required this.ID,
    this.alias
    // required this.pass,
  });
  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
        ID: json["tag_id"],
        alias: json["alias"],
        // pass: json["pass"]
    );
  }
  factory Tag.fromNfcTag(NFCTag nfcTag) {
    return Tag(
      ID: nfcTag.id,
      // pass: json["pass"]
    );
  }
  Map<String, dynamic> toJson() => {
    "tag_id": ID,
    // "pass": pass,
  };
}