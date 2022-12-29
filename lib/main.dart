// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_go_router/navigator_observer.dart';
import 'package:test_go_router/alo.dart' as alo;

/// This sample app shows an app with two screens.
///
/// The first route '/' is mapped to [HomeScreen], and the second route
/// '/details' is mapped to [DetailsScreen].
///
/// The buttons use context.go() to navigate to each destination. On mobile
/// devices, each destination is deep-linkable and on the web, can be navigated
/// to using the address bar.
///
/// SCREEN_A/SCRAB_B/SCRAN_C_D
void main() => runApp(const MyApp());

/// The route configuration.
final GoRouter _router = GoRouter(
  observers: [CommonNavigatorObserver()],
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'home_screen',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'screen_A',
          name: 'screen_A',
          builder: (BuildContext context, GoRouterState state) {
            return const ScreenA();
          },
          routes: [
            GoRoute(
              path: 'screen_B',
              name: 'screen_B',
              builder: (BuildContext context, GoRouterState state) {
                final String name = state.queryParams['name'] ?? "defaultValue";
                return ScreenB(name: name);
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'screen_C_B',
                  name: 'screen_C_B',
                  builder: (BuildContext context, GoRouterState state) {
                    return const ScreenC();
                  },),
              ]
            ),
            GoRoute(
              path: 'screen_D',
              name: 'screen_D',
              builder: (BuildContext context, GoRouterState state) {
                return const ScreenD();
              },
              routes: [
                GoRoute(
                  path: 'screen_C_D',
                  name: 'screen_C_D',
                  builder: (BuildContext context, GoRouterState state) {
                    return const ScreenC();
                  },),
              ]
            )
          ]
        ),
      ],
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (BuildContext context, GoRouterState state) {
        return const ProfileScreen();
      },),
  ],
);

/// The main app.
class MyApp extends StatelessWidget {
  /// Constructs a [MyApp]
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,

    );
  }
}

/// The home screen
class HomeScreen extends StatelessWidget {
  /// Constructs a [HomeScreen]
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => context.go('/screen_A'),
              child: const Text('Go to the Screen A'),
            ),
            ElevatedButton(
              onPressed: () {
                context.push('profile');
              },
              child: const Text('Push to the Profile screen'),
            ),
          ],
        ),
      ),
    );
  }
}

class ScreenA extends StatefulWidget {
  const ScreenA({Key? key}) : super(key: key);

  @override
  State<ScreenA> createState() => _ScreenAState();
}

class _ScreenAState extends State<ScreenA> {
  String text = "default value";
  int count = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        text = "jump here";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Screen A')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(text, style: TextStyle(fontSize: 20),),
              Text('count: $count', style: TextStyle(fontSize: 20)),
              ElevatedButton(
                onPressed: () => context.push('/screen_A/screen_B'),
                child: const Text('go to screen B (push method)'),
              ),
              ElevatedButton(
                onPressed: () => context.go('/screen_A/screen_D'),
                child: const Text('go to screen D (go method)'),
              ),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go back to the previous screen'),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(context: context, builder: (context) {
                    return Container(
                      child:  ElevatedButton(
                        onPressed: () {
                          //Navigator.popUntil(context, ModalRoute.withName('home_screen'));
                          context.pop();
                        },
                        child: const Text('This is a Dialog'),
                      ),
                    );
                  });
                },
                child: const Text('show popup '),
              ),
              ElevatedButton(
                onPressed: () {
                  setState((){
                    count++;
                  });

                },
                child: const Text('tap++'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// class ScreenA extends StatelessWidget {
//
//   /// Constructs a [DetailsScreen]
//   const ScreenA({Key? key}) : super(key: key);
//
//
// }

class ScreenB extends StatelessWidget {
  final String name;
  /// Constructs a [DetailsScreen]
  const ScreenB({Key? key,required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screen B')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Value: $name'),
            ElevatedButton(
              onPressed: () => context.goNamed('screen_C_B'),
              child: const Text('Go to Screen C'),
            ),
          ],
        ),
      ),
    );
  }
}

class ScreenC extends StatelessWidget {
  /// Constructs a [DetailsScreen]
  const ScreenC({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screen C')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <ElevatedButton>[
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go back to the home screen'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/screen_A'),
              child: const Text('Go back To Screen A'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('screen_A'));
              },
              child: const Text('popUntil to screen A using navigator'),
            ),
          ],
        ),
      ),
    );
  }
}

class ScreenD extends StatelessWidget {
  /// Constructs a [DetailsScreen]
  const ScreenD({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screen D')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <ElevatedButton>[
            ElevatedButton(
              onPressed: () => context.goNamed('screen_C_D'),
              child: const Text('go to screen C'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go back to the home screen'),
            ),
            ElevatedButton(
              onPressed: () => context.push('/screen_A/screen_B'),
              child: const Text('go to screen B (push method)'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/screen_A/screen_B'),
              child: const Text('go to screen B (go method)'),
            ),
          ],
        ),
      ),
    );
  }
}


/// The profile details screen
class ProfileScreen extends StatelessWidget {
  /// Constructs a [DetailsScreen]
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <ElevatedButton>[
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go back to the Home screen'),
            ),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Go back to the previous screen'),
            ),
          ],
        ),
      ),
    );
  }
}