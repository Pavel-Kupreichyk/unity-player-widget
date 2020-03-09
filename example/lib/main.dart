import 'dart:math';

import 'package:flutter/material.dart';
import 'package:unity_player_widget/unity_player_widget.dart';
import 'dart:io' show Platform;

void main() async {
  runApp(MyApp());
  await UnityPlayer.init(pauseDelay: Duration(seconds: 3));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Menu(),
        '/unity': (context) => UnityScreen(),
      },
    );
  }
}

class UnityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unity Player Demo'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 500,
                child: UnityPlayer(
                  willCreateUnityPlayer: () {
                    if (Platform.isIOS) {
//                        UnityPlayer.sendMessage(
//                            objectName: 'MessageReceiver',
//                            method: 'ChangeARSessionState',
//                            message: 'true');
                    }
                  },
                  willDisposeUnityPlayer: () {
                    if (Platform.isIOS) {
//                        UnityPlayer.sendMessage(
//                            objectName: 'MessageReceiver',
//                            method: 'ChangeARSessionState',
//                            message: 'false');
                    }
                  },
                ),
              ),
              Container(color: Colors.cyan, height: 500),
              Container(color: Colors.deepPurple, height: 500),
            ],
          ),
        ),
      ),
    );
  }
}

class Menu extends StatelessWidget {
  final Random random = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          ListView.builder(
            itemCount: 150,
            itemBuilder: (_, __) {
              return Container(
                height: 200,
                color: Color.fromARGB(255, random.nextInt(255),
                    random.nextInt(255), random.nextInt(255)),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
            child: MaterialButton(
              child: Text(
                'Unity Player Demo',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              color: Colors.grey[200],
              onPressed: () => Navigator.pushNamed(context, '/unity'),
            ),
          ),
        ],
      ),
    );
  }
}
