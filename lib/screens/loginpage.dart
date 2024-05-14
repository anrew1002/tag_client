import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tag_client/screens/scanpage.dart';

import '../tag_provider/api.dart';
import '../models/key.dart';

final storage = FlutterSecureStorage();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final myController = TextEditingController();
  String message = "";
  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    ifAlreadyAuth();
  }

  Future<void> ifAlreadyAuth() async {
  var key = await storage.read(key: "apikey");
  key = null;
  // developer.log("checking key $key", name: 'my.app.LoginPage');
  if (key!=null){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ScanPage(storage: storage)),
    );
  }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ Text(message,style:const TextStyle(color: Colors.red)), const SizedBox(height: 20),
          TextField(
            controller: myController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Ваше ФИО',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            // When the user presses the button, show an alert dialog containing
            // the text that the user has entered into the text field.
            onPressed: () {
              onPressed(myController, context);
            },
            child: Text("Зарегестрироваться"),
          ),
        ],
      ),
    )));
  }
  void onPressed(TextEditingController controller, BuildContext context) async {
    var response = await KeysApi().getApiKey(controller.text);
    if (response != null) {
      if (response.statusCode == 409){
        setState((){
          message = "Имя уже занято";
        });
      }
      var key = ApiKey.fromJson(
          json.decode(const Utf8Decoder().convert(response.bodyBytes)));

      storage.write(key: "apikey", value: key.key);
      developer.log(jsonEncode(key), name: 'my.app.LoginPage');
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => ScanPage(storage: storage)),
      );
    }
  }
}


