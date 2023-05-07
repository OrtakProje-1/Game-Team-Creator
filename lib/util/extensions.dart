import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  Future<T?> push<T>(Widget page) {
    return Navigator.push<T>(this, MaterialPageRoute(builder: (_) => page));
  }

  Future<T?> pushAndRemoveUntil<T>(Widget page) {
    return Navigator.pushAndRemoveUntil<T>(
        this, MaterialPageRoute(builder: (_) => page), (route) => false);
  }
}

extension NumberWidgetExtensions on num {
  Widget get width => SizedBox(width: toDouble());
  Widget get height => SizedBox(height: toDouble());
}

extension QuerySnapshotExt<T> on QuerySnapshot<T> {
  List<T> getDatas() {
    return docs.map((e) => e.data()).toList();
  }
}

extension CollectionReferenceExt<T> on CollectionReference<T> {
  Future<List<T>> getDatas() async {
    return (await get()).docs.map((e) => e.data()).toList();
  }
}

extension StatefulWidgetExt on BuildContext {
  MediaQueryData get query => MediaQuery.of(this);
  void showSnackbar(String text, {int second = 3}) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(text),
      duration: Duration(seconds: second),
    ));
  }
}
