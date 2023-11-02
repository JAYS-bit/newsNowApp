
import 'package:news_now/models/news_channels_headlines_model.dart';

import '../models/categories_news_model.dart';
import '../repository/news_repository.dart';

class NewsViewModel{

  final _repo =NewsRepository();
  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesApi( String channelName) async{
    final response=  await _repo.fetchNewsChannelHeadlinesApi(channelName);
    return response;
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async{

    final response=  await _repo.fetchCategoriesNewsApi(category);
    return response;

}

}