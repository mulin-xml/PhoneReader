// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      title: 'Path Provider',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    
    ff();
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        child: Image.file(
          File('/storage/emulated/0/Android/data/com.example.phone_reader/files/book_img/531-1.webp'),
        ),
      ),
    );
  }

  ff() async {
    // final j = Permission.storage.request();

    final a = Directory('/storage/emulated/0/Android/data/com.example.phone_reader/files/book_img').listSync(recursive: true);
    // final b = File('/storage/emulated/0/xml/531-2.webp').re;
    print(a.length);
    for (final i in a) {
      print(i);
    }
  }
}
