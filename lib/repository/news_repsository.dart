import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:news_api_app/models/categories_news_model.dart';
import 'package:news_api_app/models/news_channel_headline_model.dart';



class NewsRepsository {
  Future<NewsChannelHeadlinesModel> fetchNewsChannelHeadlinesApi(
      countryCode) async {
    String url =
        'https://newsapi.org/v2/top-headlines?country=$countryCode&apiKey=bb15e14a47044a9ba9811bf014caedde';

    final response = await http.get(
      Uri.parse(url),
    );
    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelHeadlinesModel.fromJson(body);
    }
    throw Exception('Error');
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(categoryCode) async {
    String url =
        'https://newsapi.org/v2/everything?q=$categoryCode&apiKey=bb15e14a47044a9ba9811bf014caedde';

    final response = await http.get(
      Uri.parse(url),
    );
    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }
    throw Exception('Error');
  }
}
