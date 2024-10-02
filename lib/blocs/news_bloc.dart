import 'dart:async';

import '../handlers/api_response.dart';
import '../models/responseModels/news_response_model.dart';
import '../repos/news_repo.dart';

class HeadlinesNewsBloc {
  HeadlinesNewsRepo? _newsRepo;
  final _newsDataStreamController =
      StreamController<ApiResponse<NewsResponseModel>>.broadcast();

  StreamSink<ApiResponse<NewsResponseModel>> get _newsDataSink =>
      _newsDataStreamController.sink;
  Stream<ApiResponse<NewsResponseModel>> get newsDataStream =>
      _newsDataStreamController.stream;

  HeadlinesNewsBloc() {
    _newsRepo = HeadlinesNewsRepo();
  }

  newsDataResponse(String country, String category) async {
    _newsDataSink.add(ApiResponse.loading(("Fetching Booking Data...")));

    try {
      NewsResponseModel _model =
          await _newsRepo!.newsRequest(country, category);
      _newsDataSink.add(ApiResponse.completed(_model));
    } catch (exception) {
      _newsDataSink.add(ApiResponse.error(exception.toString()));
    }
  }

  dispose() {
    _newsDataStreamController.close();
  }
}
