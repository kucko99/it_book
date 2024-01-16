import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:it_book/screens/BookDataScreen.dart';

import '../components/SearchBookButton.dart';
import '../components/SearchBookTextInput.dart';
import '../components/SearchedBooksList.dart';
import '../models/Book.dart';

class SearchBookScreen extends StatefulWidget {
  const SearchBookScreen({super.key, required this.title});

  final String title;

  @override
  State<SearchBookScreen> createState() => _SearchBookScreenState();
}

class _SearchBookScreenState extends State<SearchBookScreen> {
  TextEditingController _searchInputController = TextEditingController();
  List<Book> _searchedBooks = [];
  int _numOfSearchedBooks = 0;
  int _currentPage = 1;
  bool showFoundBooksText = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
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
          const SizedBox(height: 16),
          Visibility(
            visible: showFoundBooksText,
            child: Text(
              'Found $_numOfSearchedBooks book${_numOfSearchedBooks != 1 ? 's' : ''}.',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
              child: SearchedBooksList(
                searchResults: _searchedBooks,
                onBookTap: (index) => {
                  print("Index of clicked book: " + index.toString()),
                  Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => BookDataScreen(book: _searchedBooks[index]))
                  )
                },
              )
          ),
          Visibility(
            visible: showFoundBooksText,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _currentPage > 1 ? () => _changePage(-1) : null,
                  child: const Text('Previous Page'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _changePage(1),
                  child: const Text('Next Page'),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  Future<void> _searchBooks(String query, {int page = 1}) async {
    final response = await http.get(
      Uri.parse('https://api.itbook.store/1.0/search/$query/$page'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _numOfSearchedBooks = int.parse(data['total']);
        _searchedBooks = (data['books'] as List).map((book) => Book.fromJson(book)).toList();
        printInfoAboutBooksList(_searchedBooks);
      });
    } else {
      throw Exception('Failed to load books.');
    }
  }

  void _changePage(int increment) {
    setState(() {
      _currentPage += increment;
      _searchBooks(_searchInputController.text, page: _currentPage);
    });
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
      print('Url: ${_searchedBooks[i].url}');
      print('\n');
    }
  }
}