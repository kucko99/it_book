import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/Book.dart';

class SearchBookAPI {
  final String baseUrl = 'https://api.itbook.store/1.0';

  Future<Map<String, dynamic>> searchBooks(String query, {int page = 1}) async {
    final response = await http.get(Uri.parse('$baseUrl/search/$query/$page'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load books.');
    }
  }

  List<Book> parseBooks(Map<String, dynamic> data) {
    return (data['books'] as List).map((book) => Book.fromJson(book)).toList();
  }
}