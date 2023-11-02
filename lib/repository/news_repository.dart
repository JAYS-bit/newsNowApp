import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_now/models/categories_news_model.dart';
import 'package:news_now/models/news_channels_headlines_model.dart';

class NewsRepository{
  // used API Data fetching
  Future<NewsChannelsHeadlinesModel>fetchNewsChannelHeadlinesApi(String channelName) async{

    String url='https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=41218e2a393648a4827142a2b70bb576';
    final response = await http.get(Uri.parse(url));// url has been parsed into uri
    if(response.statusCode==200){
      final body =jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);
    }else{
      throw Exception('Error');
    }
  }



  Future<CategoriesNewsModel>fetchCategoriesNewsApi(String category) async{

    String url='https://newsapi.org/v2/everything?q=$category&apiKey=41218e2a393648a4827142a2b70bb576';
    final response = await http.get(Uri.parse(url));// url has been parsed into uri
    if(response.statusCode==200){
      final body =jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }else{
      throw Exception('Error');
    }
  }


}