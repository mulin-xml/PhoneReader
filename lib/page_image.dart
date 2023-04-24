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
    u.sp.setString('cName', u.menuList[current.cid]);
    u.sp.setInt('pid', current.pid);
  }
}

class PageImg {
  PageImg(this.cid, this.pid, this.list) {
    list.sort((a, b) => a.path.compareTo(b.path));
  }

  final List<FileSystemEntity> list;
  final int cid;
  final int pid;

  PageImg? next() {
    if (pid + 1 < list.length) {
      return PageImg(cid, pid + 1, list);
    } else if (cid + 1 < u.menuList.length) {
      return PageImg(cid + 1, 0, Directory('${u.extDir.path}/${u.menuList[cid + 1]}').listSync());
    } else {
      return null;
    }
  }

  PageImg? last() {
    if (pid > 0) {
      return PageImg(cid, pid - 1, list);
    } else if (cid > 0) {
      final ll = Directory('${u.extDir.path}/${u.menuList[cid - 1]}').listSync();
      return PageImg(cid - 1, ll.length - 1, ll);
    } else {
      return null;
    }
  }

  Widget get widget {
    return pid < list.length ? Image.file(File(list[pid].path)) : Container(height: 500, alignment: Alignment.center, child: const Text('Error'));
  }
}
