import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppButtons {
  static Widget appTextButton({
    required String name,
    required Function() onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Text(name),
    );
  }

  static Widget appElevatedButton({
    required String name,
    required Function() onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(name),
    );
  }

  static Widget appOutlinedButton({
    required String name,
    required Function() onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(name),
    );
  }

  static Widget appIconButton({
    required String name,
    required Icon icon,
    required Function() onPressed,
  }) {
    return IconButton(
      icon: icon,
      onPressed: onPressed,
      tooltip: name,
    );
  }

  static Widget appTextButtonIcon({
    required String name,
    required Icon icon,
    required Function() onPressed,
  }) {
    return TextButton.icon(
      icon: icon,
      onPressed: onPressed,
      label: Text(name),
    );
  }

  static Widget appElevatedButtonIcon({
    required String name,
    required Icon icon,
    required Function() onPressed,
  }) {
    return ElevatedButton.icon(
      icon: icon,
      onPressed: onPressed,
      label: Text(name),
    );
  }

  static Widget appOutlinedButtonIcon({
    required String name,
    required Icon icon,
    FaIcon? faIcon,
    required Function() onPressed,
  }) {
    Widget _icon = faIcon == null ? icon : faIcon;
    return OutlinedButton.icon(
      icon: _icon,
      onPressed: onPressed,
      label: Text(name),
    );
  }
}
