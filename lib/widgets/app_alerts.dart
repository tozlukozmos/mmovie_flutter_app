import 'package:flutter/material.dart';

class AppAlerts {
  static Widget appAlert({
    required String title,
    required Color color,
    required Icon icon,
  }) {
    return Container(
      decoration: BoxDecoration(color: color),
      child: ListTile(
        leading: icon,
        title: Text(title),
      ),
    );
  }
}
