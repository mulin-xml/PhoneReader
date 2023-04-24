// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:phone_reader/page_image.dart';
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

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with TickerProviderStateMixin {
  late AnimationController controller1, controller2;
  late PageImgCache lc;

  double anchorX = 0;
  double currentX = 0;
  double movingDir = 0;

  @override
  void initState() {
    super.initState();
    final c = u.menuList.indexOf(u.sp.getString('cName') ?? u.menuList.first);
    final cid = c.isNegative ? 0 : c;
    final pid = u.sp.getInt('pid') ?? 0;
    lc = PageImgCache(PageImg(cid, pid, Directory('${u.extDir.path}/${u.menuList[cid]}').listSync()));

    controller1 = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    controller1.addStatusListener(listener);
    controller2 = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    controller2.addStatusListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        movingDir = -1;
        controller1.forward();
      },
      onHorizontalDragUpdate: (details) {
        currentX = details.globalPosition.dx;
        if (movingDir.isNegative) {
          controller1.value = (anchorX - currentX) / context.size!.width;
        } else {
          controller2.value = currentX / context.size!.width;
        }
      },
      onHorizontalDragDown: (details) {
        anchorX = details.globalPosition.dx;
      },
      onHorizontalDragStart: (details) {
        movingDir = details.globalPosition.dx - anchorX;
      },
      onHorizontalDragEnd: (details) {
        if (movingDir.isNegative) {
          currentX > anchorX ? controller1.reverse() : controller1.forward();
        } else {
          currentX < anchorX ? controller2.reverse() : controller2.forward();
        }
      },
      child: Column(children: [
        Stack(children: [
          lc.next?.widget ?? Container(color: Colors.red),
          SlideTransition(
            position: Tween<Offset>(begin: Offset.zero, end: const Offset(-1, 0)).animate(controller1),
            child: lc.current.widget,
          ),
          SlideTransition(
            position: Tween<Offset>(end: Offset.zero, begin: const Offset(-1, 0)).animate(controller2),
            child: lc.last?.widget ?? Container(color: Colors.red),
          ),
        ]),
        Expanded(child: Text('${u.menuList[lc.current.cid]}  ${lc.current.pid + 1}/${lc.current.list.length}')),
      ]),
    );
  }

  listener(status) {
    if (status == AnimationStatus.completed) {
      movingDir.isNegative ? lc.forward() : lc.reverse();
      controller1.reset();
      controller2.reset();
      setState(() => movingDir = 0);
    }
  }
}
