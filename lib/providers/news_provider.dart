import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsProvider with ChangeNotifier {
  List<dynamic> _articles = [];
  List<dynamic> get articles => _articles;

  List<dynamic> _favorites = [];
  List<dynamic> get favorites => _favorites;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _currentCategory = 'General';
  String get currentCategory => _currentCategory;

  void setCategory(String category) {
    _currentCategory = category[0].toUpperCase() + category.substring(1);
    notifyListeners();
  }

  Future<void> fetchNews({String? category, String? query}) async {
    final apiKey = 'acd304098d6045d98aeec96852ce0898';
    String url = 'https://newsapi.org/v2/top-headlines?apiKey=$apiKey&country=us';

    if (category != null) {
      url += '&category=$category';
      _currentCategory = category[0].toUpperCase() + category.substring(1);
    }

    if (query != null && query.isNotEmpty) {
      url += '&q=$query';
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _articles = data['articles'];
      } else {
        _articles = [];
      }
    } catch (error) {
      _articles = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void toggleFavorite(dynamic article) {
    if (_favorites.contains(article)) {
      _favorites.remove(article);
    } else {
      _favorites.add(article);
    }
    notifyListeners();
  }

  bool isFavorite(dynamic article) {
    return _favorites.contains(article);
  }
}
