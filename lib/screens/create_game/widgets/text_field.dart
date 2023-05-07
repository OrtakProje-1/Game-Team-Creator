import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? placeholder;
  final bool? isReadOnly;
  final bool? obscureText;
  const CustomTextField(
      {super.key,
      this.controller,
      this.placeholder,
      this.isReadOnly,
      this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TextField(
          readOnly: isReadOnly ?? false,
          controller: controller,
          obscureText: obscureText ?? false,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: placeholder,
            hintStyle: Theme.of(context).textTheme.titleSmall!.apply(
                  color: Colors.black12,
                ),
          ),
        ),
      ),
    );
  }
}
