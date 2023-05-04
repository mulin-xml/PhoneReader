// ignore_for_file: avoid_print

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static getInstance() => _instance;
  static final _instance = Utils._internal();
  factory Utils() => getInstance();
  Utils._internal() {
    // _initAsync();
  }

  Directory? _extDir;
  SharedPreferences? _sharedPreferences;
  List<String> menuList = [];

  Future<bool> initAsync() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _extDir = await getExternalStorageDirectory();
    print('Utils prepare ready.');
    menuList = Directory(u.extDir.path).listSync().map((e) => e.path.split('/').last).toList()..sort();
    print(menuList);
    return true;
  }

  SharedPreferences get sp => _sharedPreferences!;
  Directory get extDir => _extDir!;
}

final u = Utils();
