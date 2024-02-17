import 'package:flutter/material.dart';
import 'package:it_book/service/SearchBookAPI.dart';
import '../models/Book.dart';

class SearchBookScreen extends StatefulWidget {
  const SearchBookScreen({Key? key, required this.title}) : super(key: key);

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
  bool _loading = false;

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
                contentPadding: EdgeInsets.only(top: 5),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _searchBooks(_searchInputController.text);
              showFoundBooksText = true;
            },
            child: const Text('Search book'),
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
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!_loading &&
                    scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  _loadMoreBooks();
                  return true;
                }
                return false;
              },
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
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  Future<void> _searchBooks(String query, {int page = 1}) async {
    try {
      if (_loading) {
        return;
      }

      setState(() {
        _loading = true;
      });

      final data = await _searchBookAPI.searchBooks(query, page: page);

      setState(() {
        _numOfSearchedBooks = int.parse(data['total']);
        _searchedBooks = _searchBookAPI.parseBooks(data);
        printInfoAboutBooksList(_searchedBooks);
      });
    } catch (e) {
      throw Exception('Failed to load books: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _loadMoreBooks() async {
    setState(() {
      _loading = true;
    });

    try {
      final data = await _searchBookAPI.searchBooks(
        _searchInputController.text,
        page: _currentPage + 1,
      );

      setState(() {
        _searchedBooks.addAll(_searchBookAPI.parseBooks(data));
        _currentPage += 1;
      });
    } catch (e) {
      print('Failed to load more books: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void printInfoAboutBooksList(List<Book> result) {
    print('Number of books: ${result.length}');

    for (int i = 0; i < _searchedBooks.length; i++) {
      print('Book ${i + 1}:');
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
