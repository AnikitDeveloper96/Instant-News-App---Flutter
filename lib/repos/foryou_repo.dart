import 'dart:convert';

import '../handlers/endpoints.dart';
import '../handlers/response_channel.dart';
import '../models/responseModels/news_response_model.dart';

class ForYouNewsRepo {
  ApiEndpoints apiEndpoints = ApiEndpoints();
  final ResponseChannel _responseChannel = ResponseChannel();

  Future<NewsResponseModel> foryounewsRequest(String country) async {
    try {
      final response =
          await _responseChannel.doGet(apiEndpoints.homeNews(country));
      print("News api response ------> $response");

      Map<String, dynamic> dynamicResponse = json.decode(response);

      return NewsResponseModel.fromJson(dynamicResponse);
    } catch (e) {
      print("Error in foryounewsRequest: $e");
      // Handle the error appropriately, e.g., by returning a default response or rethrowing the error
      return NewsResponseModel(
          articles: [], status: e.toString(), totalResults: 0);
    }
  }
}
