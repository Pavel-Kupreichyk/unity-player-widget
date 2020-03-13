import 'dart:math';

import 'package:flutter/material.dart';
import 'package:unity_player_widget/unity_player_widget.dart';

void main() async {
  runApp(MyApp());
  await UnityPlayer.init(pauseDelay: Duration(seconds: 3));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Menu(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => Menu());
          case '/unity':
            return UnityRoute(builder: (_) => UnityScreen());
          default:
            throw '';
        }
      },
    );
  }
}

class UnityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await UnityPlayer.pause(PlayerPlatform.iOS);
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            UnityPlayer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 40, 0, 0),
              child: IconButton(
                icon: Icon(Icons.arrow_back, size: 30, color: Colors.white),
                onPressed: () async {
                  await UnityPlayer.pause(PlayerPlatform.iOS);
                  Navigator.pop(context);
                },
              ),
            )
          ],
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
              onPressed: () {
                Navigator.pushNamed(context, '/unity');
              },
            ),
          ),
        ],
      ),
    );
  }
}

class UnityRoute extends MaterialPageRoute {
  UnityRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
      builder: builder,
      settings: settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        UnityPlayer.resume(PlayerPlatform.iOS);
      }
    });
    return super
        .buildTransitions(context, animation, secondaryAnimation, child);
  }
}
