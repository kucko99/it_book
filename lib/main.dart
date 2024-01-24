import 'package:flutter/material.dart';
import 'package:it_book/models/Book.dart';
import 'package:it_book/screens/BookDataScreen.dart';
import 'package:it_book/screens/SearchBookScreen.dart';

void main() {
  runApp(const ITBookApp());
}

class ITBookApp extends StatelessWidget {
  const ITBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IT Book',
      theme: ThemeData(
        primaryColor: Colors.brown
      ),
      initialRoute: '/search',
      routes: {
        '/search': (context) => const SearchBookScreen(title: 'IT Book Search'),
        '/bookDetail': (context) => BookDataScreen(book: ModalRoute.of(context)!.settings.arguments as Book),
      },
    );
  }
}
