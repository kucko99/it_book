import 'package:flutter/material.dart';

import '../models/Book.dart';

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