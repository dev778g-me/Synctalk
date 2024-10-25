import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final String labeltext;
  final TextEditingController controller;
  final Widget leading;

  const MyTextfield(
      {super.key,
      required this.labeltext,
      required this.controller,
      required this.leading});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Theme.of(context).colorScheme.primaryFixed),
      decoration: InputDecoration(
          prefixIcon: leading,
          labelText: labeltext,
          border: OutlineInputBorder()),
    );
  }
}
