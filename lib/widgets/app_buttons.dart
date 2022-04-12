import 'package:flutter/material.dart';

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

  static Widget appToggleButtons({
    required List<bool> isSelected,
    required List<Widget> buttons,
    required Function(int) onPressed,
  }) {
    return ToggleButtons(
      isSelected: isSelected,
      children: buttons,
      onPressed: onPressed,
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
    required Function() onPressed,
  }) {
    return OutlinedButton.icon(
      icon: icon,
      onPressed: onPressed,
      label: Text(name),
    );
  }
}
