import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'package:tag_client/models/tag.dart';


class TagApi {
  Future<Tag?> postTagID(Tag tag) async {
    developer.log('starting getTags request with ${tag.ID}', name: 'my.app.TagApi');
    var client = http.Client();
    var payload = jsonEncode(tag.toJson());
    var uri = Uri.parse('http://192.168.1.127:1090/api/v1/tags');
    var response = await client.post(uri,body: payload);

    if (response.statusCode == 200) {
      developer.log("Success! ${response.statusCode}", name: 'my.app.TagApi');
      return Tag.fromJson(json.decode(const Utf8Decoder().convert(response.bodyBytes)));
    } else{
      developer.log("Fail! ${response.statusCode}", name: 'my.app.TagApi');
    }
    return null;
  }
}