import 'package:intl/intl.dart';

import '../constants/api_key.dart';

class ApiEndpoints {
  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  /// For you news
  String homeNews(String country) =>
      "https://newsapi.org/v2/top-headlines?country=$country&apiKey=$apikey&to=$currentDate";

  /// categories
  String newsEndPoint(String country, String category) =>
      "https://newsapi.org/v2/top-headlines?country=$country&category=$category&apiKey=$apikey";

  /// search news
  String searchNews(String search) =>
      "https://newsapi.org/v2/everything?q=$search&from=$currentDate&sortBy=popularity&apiKey=$apikey";
}
