// ignore: unused_import
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:dash_chat_2/dash_chat_2.dart';

class MockBot extends StatefulWidget {
  const MockBot({super.key});
  @override
  State<MockBot> createState() => _MockBotState();
}

class _MockBotState extends State<MockBot> {
  ChatUser myself = ChatUser(
    id: '1',
    firstName: 'Mayuri',
  );

  ChatUser bot = ChatUser(
    id: '2',
    firstName: 'Gemini',
  );
  List<ChatMessage> messagess = <ChatMessage>[];
  List<ChatUser> _typing = <ChatUser>[];

  final oururl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyAeDKXclYkdGC-qaJZw6fFeDEf6YeyPv9U';
  final header = {'Content-Type': 'application/json'};
  getdata(ChatMessage m) async {
    _typing.add(bot);
    messagess.insert(0, m);
    setState(() {});

    var datta = {
      "contents": [
        {
          "parts": [
            {"text": m.text}
          ]
        }
      ]
    };

    await http
        .post(Uri.parse(oururl), headers: header, body: jsonEncode(datta))
        .then((value) {
      if (value.statusCode == 200) {
        var result = jsonDecode(value.body);
        print(result['candidates'][0]['content']['parts'][0]['text']);

        ChatMessage data = ChatMessage(
          text: result['candidates'][0]['content']['parts'][0]['text'],
          user: bot,
          createdAt: DateTime.now(),
        );

        messagess.insert(0, data);
      } else {
        print("error occured");
      }
    }).catchError((e) {});
    _typing.remove(bot);
    setState(() {});

    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text('Gem ChatBot'),
      ),
      body: DashChat(
        typingUsers: _typing,
        currentUser: myself,
        onSend: (ChatMessage m) {
          getdata(m);
        },
        messages: messagess,
        inputOptions: InputOptions(
          alwaysShowSend: true,
          cursorStyle: CursorStyle(color: Colors.black),
        ),
        messageOptions: MessageOptions(
          currentUserContainerColor: Colors.black,
          // avatarBuilder: yourAvatarbuilder,
        ),
      ),
    );
  }

  Widget yourAvatarBuilder(
      ChatUser user, Function? onAvatarTap, Function? oneAvatarLongPress) {
    return Center(
        child: Image.asset(
      'C:/Users/DELL/Desktop/PROJECT/flutter_chat_bot/assest/robot-assistant.png',
      height: 100,
      width: 100,
    ));
  }
}
