import 'dart:convert';

import 'package:mis_libros/models/result.dart';
import 'package:http/http.dart' as http;

class BookApi {
  Future<Result> getBooks(String parameter) async {
    final response = await http.get(
        Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$parameter'));

    if (response.statusCode == 200) {
      return Result.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Fallo al cargar los libros1');
    }
  }
}
