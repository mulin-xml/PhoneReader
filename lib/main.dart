// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_reader/utils.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Utils();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      title: 'title',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var cid = 615;
  var pid = 0;
  @override
  Widget build(BuildContext context) {
    ff();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 231, 193),
      body: Container(
        alignment: Alignment.topCenter,
        child: Image.file(
          File('${u.extDir.path}/img_book/$cid/1.webp'),
        ),
      ),
    );
  }

  ff() async {
    final a = Directory('${u.extDir.path}/img_book/615').listSync();
    print(a.length);
    for (final i in a) {
      print(i);
    }
    print(u.extDir);
  }
}

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Utils();
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MyHomePage()));
    });
    return const Center(
      child: FlutterLogo(),
    );
  }
}
