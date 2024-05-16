import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rakta_review_web/test.dart';
import 'package:url_strategy/url_strategy.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'RAKTA',
        initialRoute: "/",
        routes: <String, WidgetBuilder> {
          "/": (context) => ReviewPage(),
        },
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) {
              return ReviewPage(
              );
            },
          );
        }
        // home: ReviewPage(),
        );
  }
}
