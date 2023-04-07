// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

class MyPage extends StatelessWidget {
  const MyPage(this.cid, this.pid, {super.key});

  final int cid;
  final int pid;

  @override
  Widget build(BuildContext context) {
    final list = Directory('${u.extDir.path}/img_book/$cid').listSync();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 231, 193),
      body: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const PageScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return index < list.length ? Image.file(File(list[index].path)) : Container();
        },
      ),
    );
  }

  // ff() {
  //   Navigator.pushReplacement(
  //     context,
  //     CupertinoPageRoute(
  //       builder: (context) {
  //         if (pid + 1 < list.length) {
  //           return MyPage(cid, pid + 1);
  //         } else {
  //           return MyPage(cid + 1, 0);
  //         }
  //       },
  //     ),
  //   );
  // }
}

// class MyMove extends StatefulWidget {
//   const MyMove({super.key});

//   @override
//   State<MyMove> createState() => _MyMoveState();
// }

// class _MyMoveState extends State<MyMove> {
//   double _position = 0;
//   double _panEndPosition = 0;
//   double _panStartPosition = 0;
//   double _animateToPosition = 0;
//   double _basePosition = 0;

//   AnimationController _controller;

//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Utils();
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MyPage(615, 0)));
    });
    return const Center(
      child: FlutterLogo(),
    );
  }
}
