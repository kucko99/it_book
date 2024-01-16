import 'package:flutter/material.dart';

class SearchBookButton extends StatelessWidget {
  final VoidCallback onButtonPressed;

  SearchBookButton({required this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onButtonPressed, child: Text('Search book'));
  }
}