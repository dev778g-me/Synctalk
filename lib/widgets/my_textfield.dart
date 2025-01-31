import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final String labeltext;
  final TextEditingController controller;
  final Widget leading;
  final Widget? trailing;
  final bool? isShowing;
  final TextInputType? keyboardType;
  final TextInputAction? action;

  const MyTextfield(
      {super.key,
      required this.labeltext,
      required this.controller,
      required this.leading,
      this.trailing,
      this.isShowing,
      this.keyboardType,
      this.action});

  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: action,
      keyboardType: keyboardType,
      obscureText: isShowing ?? false,
      controller: controller,
      style: TextStyle(color: Theme.of(context).colorScheme.primaryFixed),
      decoration: InputDecoration(
          suffixIcon: trailing,
          prefixIcon: leading,
          labelText: labeltext,
          border: const OutlineInputBorder()),
    );
  }
}
