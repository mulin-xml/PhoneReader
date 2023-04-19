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

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  int cid = 1506;
  int pid = 5;

  double anchorX = 0;
  double currentX = 0;
  double movingDir = 0;
  bool onListen = false;
  final List<FileSystemEntity> list = [];

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    controller.addStatusListener((status) {
      if (onListen) {
        if (status == AnimationStatus.completed) {
          pid += 1;
          // setState(() => movingDir = 0);
        } else if (status == AnimationStatus.dismissed) {
          //
        }
        onListen = false;
        setState(() => movingDir = 0);
      }
    });
    list.clear();
    list.addAll(Directory('${u.extDir.path}/1506').listSync());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      onHorizontalDragUpdate: (details) {
        currentX = details.globalPosition.dx;
        if (movingDir.isNegative) {
          controller.value = (anchorX - currentX) / context.size!.width;
        } else {
          controller.value = 1 - details.globalPosition.dx / context.size!.width;
        }
      },
      onHorizontalDragDown: (details) {
        anchorX = details.globalPosition.dx;
      },
      onHorizontalDragStart: (details) {
        print('s');
        setState(() => movingDir = details.globalPosition.dx - anchorX);
      },
      onHorizontalDragEnd: (details) {
        onListen = true;
        ((currentX - anchorX) * movingDir).isNegative ? controller.reverse() : controller.forward();
      },
      child: movingDir != 0 ? moveWidget() : Image.file(File(list[pid].path)),
    );
  }

  Widget moveWidget() {
    final nd = movingDir.isNegative ? pid : pid - 1;
    return Stack(children: [
      Image.file(File(list[nd + 1].path)),
      SlideTransition(
        position: Tween<Offset>(end: Offset(movingDir.sign, 0), begin: Offset.zero).animate(controller),
        child: Image.file(File(list[nd].path)),
      ),
    ]);
  }

  next() {
    if (pid + 1 < list.length) {
      return list[pid + 1].path;
    } else {
      final l = Directory('${u.extDir.path}/1506').listSync();
      return l[pid + 1].path;
    }
  }
}

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Utils();
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MyPage()));
    });
    return const Scaffold(
      body: Center(child: FlutterLogo()),
    );
  }
}
