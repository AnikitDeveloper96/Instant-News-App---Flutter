import 'dart:convert';

import '../handlers/endpoints.dart';
import '../handlers/response_channel.dart';
import '../models/responseModels/news_response_model.dart';

class HeadlinesNewsRepo {
  ApiEndpoints apiEndpoints = ApiEndpoints();
  final ResponseChannel _responseChannel = ResponseChannel();

  Future<NewsResponseModel> newsRequest(String country, String category) async {
    try {
      final response = await _responseChannel
          .doGet(apiEndpoints.newsEndPoint(country, category));
      print("News api response for headlines ------> ${response.toString()}");

      Map<String, dynamic> dynamicResponse = json.decode(response);
      print("Dynamic response is ${dynamicResponse.toString()}");

      return NewsResponseModel.fromJson(dynamicResponse);
    } catch (e) {
      print("Error in newsRequest: $e");
      // Handle the error appropriately, e.g., by returning a default response or rethrowing the error
      return NewsResponseModel(
          articles: [], status: e.toString(), totalResults: 0);
    }
  }
}
