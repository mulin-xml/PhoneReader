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

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Utils();
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const BasePage()));
    });
    return const Scaffold(
      body: Center(child: FlutterLogo()),
    );
  }
}

class BasePage extends StatelessWidget {
  const BasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 231, 193),
      body: MyPage(),
    );
  }
}

class Loader {
  Loader.withList(this.cid, this.pid, this.list) {
    if (pid.isNegative) {
      pid += list.length;
    }
  }
  Loader.withoutList(this.cid, this.pid) : list = Directory('${u.extDir.path}/$cid').existsSync() ? Directory('${u.extDir.path}/$cid').listSync() : [] {
    if (pid.isNegative) {
      pid += list.length;
    }
  }

  final List<FileSystemEntity> list;
  final int cid;
  int pid;

  Loader next() {
    if (pid + 1 < list.length) {
      return Loader.withList(cid, pid + 1, list);
    } else {
      return Loader.withoutList(cid + 1, 0);
    }
  }

  Loader last() {
    if (pid > 0) {
      return Loader.withList(cid, pid - 1, list);
    } else {
      return Loader.withoutList(cid - 1, -1);
    }
  }

  Widget get widget => pid < list.length ? Image.file(File(list[pid].path)) : const Center(child: Text('No txt.'));
}

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  final t1 = Tween<Offset>(begin: Offset.zero, end: const Offset(-1, 0));
  late Loader page;
  double anchorX = 0;
  double currentX = 0;
  double movingDir = 0;

  @override
  void initState() {
    super.initState();
    page = Loader.withoutList(u.sp.getInt('cid') ?? 1589, u.sp.getInt('pid') ?? 0);
    controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        page = movingDir.isNegative ? page.next() : page.last();
        u.sp.setInt('cid', page.cid);
        u.sp.setInt('pid', page.pid);
        setState(() => movingDir = 0);
      } 
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        controller.reset();
        setState(() => movingDir = -1);
        controller.forward();
      },
      onHorizontalDragUpdate: (details) {
        currentX = details.globalPosition.dx;
        if (movingDir.isNegative) {
          controller.value = (anchorX - currentX) / context.size!.width;
        } else {
          controller.value = currentX / context.size!.width;
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
        ((currentX - anchorX) * movingDir).isNegative ? controller.reverse() : controller.forward();
      },
      child: Column(children: [
        movingDir != 0 ? moveWidget() : page.widget,
        Expanded(child: Text('${page.cid}  ${page.pid}')),
      ]),
    );
  }

  Widget moveWidget() {
    final down = movingDir.isNegative ? page.next() : page;
    final up = movingDir.isNegative ? page : page.last();
    return Stack(children: [
      down.widget,
      SlideTransition(
        position: movingDir.isNegative ? t1.animate(controller) : ReverseTween(t1).animate(controller),
        child: up.widget,
      ),
    ]);
  }
}
