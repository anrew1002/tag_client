import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer' as developer;

import 'package:tag_client/models/tag.dart';
import 'package:tag_client/tag_provider/api.dart';

class ScanPage extends StatefulWidget {
  final FlutterSecureStorage storage;
  const ScanPage({super.key, required this.storage });
  @override
  State<ScanPage> createState() => _ScanPageState();
}

enum StateIndex { ready, pending, internetTimeout ,internetConnectionFail, success }

class _ScanPageState extends State<ScanPage> {
  bool isChecked = false;
  NFCTag? tagNFC;
  String alias = "";
  StateIndex state = StateIndex.ready;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // checkTag();
  }

  Future<void> checkTag() async {
    setState(() {
      state = StateIndex.pending;
    });
    developer.log("checking tag", name: 'my.app.TagApi');
    tagNFC = await FlutterNfcKit.poll();
    if (tagNFC != null) {
      var tag = Tag.fromNfcTag(tagNFC!);
      developer.log("Tag found: ${tagNFC?.id}", name: 'my.app.TagApi');
      var timer = Timer(const Duration(seconds: 1), () {
        developer.log('Server connection time to long',
            name: 'my.app.checkTag');
          setState((){
          state = StateIndex.internetTimeout;
          });
      });
      var tagAPI = await TagApi().postTagID(tag);
      timer.cancel();

      if (tagAPI != null) {
        developer.log("Tag get: ${tagAPI.alias}", name: 'my.app.TagApi');
        setState(() {
          alias = tagAPI.alias!;
          state = StateIndex.success;
        });
      }else{
        setState(() {
          state = StateIndex.internetConnectionFail;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    Widget body;
    switch (state) {
      case StateIndex.ready:
        body = ElevatedButton(onPressed: onPressed, child: const Text('Сканировать'));
      case StateIndex.pending:
        body = const Text("Ищем метку...");
      case StateIndex.internetTimeout:
        body = const Text("Отправляем данные на сервер...");
      case StateIndex.internetConnectionFail:
        body = Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Ошибка соединения с сервером"),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: back, child: const Text('Назад'))
          ],
        );
      case StateIndex.success:
        body = Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(height: 10),
          Card(
            color: theme.colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                alias,
                style: style,
              ),
            ),
          ),
          SizedBox(height: 10),
          // Text(tagNFC!.id),
          ElevatedButton(onPressed: back, child: const Text('Back'))
        ]);

    }
    return Scaffold(
        body: SafeArea(
                child: Center(
                    child: body)));
  }

  void onPressed() {
    checkTag();
    setState(() {
      state = StateIndex.pending;
    });
  }

  void back() {
    setState(() {
      setState(() {
        state = StateIndex.ready;
        alias = "";
      });
    });
  }
}
