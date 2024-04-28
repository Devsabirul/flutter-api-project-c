import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool isPassword;
  final String hinttext;
  final String validateMsg;

  const TextFormFieldWidget({
    super.key,
    required this.controller,
    this.isPassword = false,
    required this.hinttext,
    required this.validateMsg,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(
        fontFamily: "Inter",
        color: Colors.black,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        errorMaxLines: 1,
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        hintText: hinttext,
        hintStyle: const TextStyle(
          fontFamily: "Inter",
          color: Colors.grey,
          fontSize: 16,
        ),
        contentPadding: const EdgeInsets.only(top: 15, bottom: 15, left: 20),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return validateMsg;
        }
        return null;
      },
    );
  }
}
