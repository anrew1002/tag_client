import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:developer' as developer;
import 'package:tag_client/models/tag.dart';

import '../models/key.dart';

class TagApi {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<Tag?> postTagID(Tag tag) async {

    developer.log('starting getTags request with ${tag.ID}',
        name: 'my.app.TagApi');
    var client = http.Client();
    var payload = jsonEncode(tag.toJson());

    var key = await storage.read(key: "apikey");

    var uri = Uri.parse('http://192.168.1.127:1090/api/v1/tags');
    // var response = await client.post(uri, body: payload);
    Response response;
    try {
      // var response =
       response = await client.post(uri, body: payload, headers:  {'Authorization': 'Bearer $key'});
      if (response.statusCode == 200) {
        developer.log("Success! ${response.statusCode}", name: 'my.app.TagApi');
        return Tag.fromJson(
            json.decode(const Utf8Decoder().convert(response.bodyBytes)));
      } else {
        developer.log("Fail! ${response.statusCode}", name: 'my.app.TagApi');
      }
    } on ClientException catch (e) {
      developer.log('Error: $e');
    } on Error catch (e) {
      developer.log('Error: $e');
    }
    return null;
  }
}
class KeysApi {
  Future<ApiKey?> getApiKey(String login) async{
    developer.log('starting getApiKey request with $login}',
        name: 'my.app.TagApi');
    var client = http.Client();
    var uri = Uri.parse('http://192.168.1.127:1090/api/v1/apikeys/$login');
    Response response;
    try {
      // var response =
      response = await client.get(uri);
      if (response.statusCode == 200) {
        developer.log("Success! ${response.statusCode}", name: 'my.app.TagApi');
        return ApiKey.fromJson(
            json.decode(const Utf8Decoder().convert(response.bodyBytes)));
      } else {
        developer.log("Fail! ${response.statusCode}", name: 'my.app.TagApi');
      }
    } on ClientException catch (e) {
      developer.log('Error: $e');
    } on Error catch (e) {
      developer.log('Error: $e');
    }
    return null;
  }
}
