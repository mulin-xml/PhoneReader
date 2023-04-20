// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:phone_reader/utils.dart';

class PageImgCache {
  PageImgCache(this.current)
      : last = current.last(),
        next = current.next();

  PageImg? last;
  PageImg current;
  PageImg? next;

  forward() {
    if (next != null) {
      last = current;
      current = next!;
      next = next?.next();
      _save();
    }
  }

  reverse() {
    if (last != null) {
      next = current;
      current = last!;
      last = last?.last();
      _save();
    }
  }

  _save() {
    u.sp.setInt('cid', current.cid);
    u.sp.setInt('pid', current.pid);
  }
}

class PageImg {
  PageImg(this.cid, this.pid, this.list);

  final List<FileSystemEntity> list;
  final int cid;
  final int pid;

  PageImg? next() {
    final n = Directory('${u.extDir.path}/${cid + 1}');
    if (pid + 1 < list.length) {
      return PageImg(cid, pid + 1, list);
    } else if (n.existsSync()) {
      return PageImg(cid + 1, 0, n.listSync());
    } else {
      return null;
    }
  }

  PageImg? last() {
    final l = Directory('${u.extDir.path}/${cid - 1}');
    if (pid > 0) {
      return PageImg(cid, pid - 1, list);
    } else if (l.existsSync()) {
      final ll = l.listSync();
      return PageImg(cid - 1, ll.length - 1, ll);
    } else {
      return null;
    }
  }

  Widget get widget {
    return pid < list.length ? Image.file(File(list[pid].path)) : Container(height: 500, alignment: Alignment.center, child: const Text('Error'));
  }
}
