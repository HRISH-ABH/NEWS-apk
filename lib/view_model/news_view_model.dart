import 'package:news_api_app/models/categories_news_model.dart';
import 'package:news_api_app/models/news_channel_headline_model.dart';
import 'package:news_api_app/repository/news_repsository.dart';

class NewsViewModel {
  final _repo = NewsRepsository();

  Future<NewsChannelHeadlinesModel> fetchNewsChannelHeadlinesApi(countryCode) async {
    final response = await _repo.fetchNewsChannelHeadlinesApi(countryCode);
    return response;
  }
  Future<CategoriesNewsModel> fetchCategoriesNewsApi(categoryCode) async {
    final response = await _repo.fetchCategoriesNewsApi(categoryCode);
    return response;
  }
}
