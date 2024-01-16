import 'package:flutter/material.dart';

class SearchBookTextInput extends StatelessWidget {
  final TextEditingController controller;

  SearchBookTextInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
            labelText: 'Enter name of search book',
            contentPadding: EdgeInsets.only(top: 5)
        ),
      ),
    );
  }
}