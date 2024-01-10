import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Book.dart';

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
      home: const SearchBookScreen(title: 'IT Book Search'),
    );
  }
}

class SearchBookScreen extends StatefulWidget {
  const SearchBookScreen({super.key, required this.title});

  final String title;

  @override
  State<SearchBookScreen> createState() => _SearchBookScreenState();
}

class _SearchBookScreenState extends State<SearchBookScreen> {
  TextEditingController _searchInputController = TextEditingController();
  List<Book> _searchedBooks = [];
  bool showFoundBooksText = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown, // Farba pre AppBar
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          SearchBookTextInput(controller: _searchInputController),
          SearchBookButton(
            onButtonPressed: () {
              _searchBooks(_searchInputController.text);
              showFoundBooksText = true;
            },
          ),
          const SizedBox(height: 16), // Vzdialenosť medzi tlačidlom a textom
          Visibility(
            visible: showFoundBooksText && _searchedBooks.isNotEmpty,
            child: Text(
              'Found ${_searchedBooks.length} books:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Visibility(
            visible: showFoundBooksText && _searchedBooks.isEmpty,
            child: const Text(
              'Found 0 books.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
              child: SearchedBooksList(
                searchResults: _searchedBooks,
                onBookTap: (index) => {
                  print("Index of clicked book: " + index.toString())
                },
              )
          )
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  Future<void> _searchBooks(String query) async {
    final response = await http.get(Uri.parse('https://api.itbook.store/1.0/search/$query'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _searchedBooks = (data['books'] as List).map((book) => Book.fromJson(book)).toList();
        printInfoAboutBooksList(_searchedBooks);
      });
    } else {
      throw Exception('Failed to load books.');
    }
  }

  void printInfoAboutBooksList(List<Book> result) {
    print('Number of books: ${result.length}');
    //print('List of books: $result');

    for (int i = 0; i < _searchedBooks.length; i++) {
      print('Book ${i+1}:');
      print('Title: ${_searchedBooks[i].title}');
      print('Subtitle: ${_searchedBooks[i].subtitle}');
      print('ISBN-13: ${_searchedBooks[i].isbn13}');
      print('Price: ${_searchedBooks[i].price}');
      print('Image: ${_searchedBooks[i].image}');
      print('\n');
    }
  }
}

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

class SearchBookButton extends StatelessWidget {
  final VoidCallback onButtonPressed;

  SearchBookButton({required this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onButtonPressed, child: Text('Search book'));
  }
}

class SearchedBooksList extends StatelessWidget {
  final List<Book> searchResults;
  final Function(int) onBookTap;

  SearchedBooksList({required this.searchResults, required this.onBookTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(searchResults[index].title),
          onTap: () => onBookTap(index),
        );
      },
    );
  }
}
