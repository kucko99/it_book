import 'package:flutter/material.dart';
import 'package:it_book/screens/BookDataScreen.dart';
import 'package:it_book/service/SearchBookAPI.dart';

import '../models/Book.dart';

class SearchBookScreen extends StatefulWidget {
  const SearchBookScreen({super.key, required this.title});

  final String title;

  @override
  State<SearchBookScreen> createState() => _SearchBookScreenState();
}

class _SearchBookScreenState extends State<SearchBookScreen> {
  final TextEditingController _searchInputController = TextEditingController();
  final SearchBookAPI _searchBookAPI = SearchBookAPI();
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            child: TextField(
              controller: _searchInputController,
              decoration: const InputDecoration(
                  labelText: 'Enter name of search book',
                  contentPadding: EdgeInsets.only(top: 5)
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                _searchBooks(_searchInputController.text);
                showFoundBooksText = true;
              },
              child: const Text('Search book')
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
              child: ListView.builder(
                itemCount: _searchedBooks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_searchedBooks[index].title),
                    onTap: () => {
                      print("Index of clicked book: " + index.toString()),
                      Navigator.pushNamed(context, '/bookDetail', arguments: _searchedBooks[index])
                  },
                  );
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
    try {
      final data = await _searchBookAPI.searchBooks(query, page: page);
      setState(() {
        _numOfSearchedBooks = int.parse(data['total']);
        _searchedBooks = _searchBookAPI.parseBooks(data);
        printInfoAboutBooksList(_searchedBooks);
      });
    } catch (e) {
      throw Exception('Failed to load books: $e');
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