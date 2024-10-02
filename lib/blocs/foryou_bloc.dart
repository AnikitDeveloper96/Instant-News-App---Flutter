import 'dart:async';

import '../handlers/api_response.dart';
import '../models/responseModels/news_response_model.dart';
import '../repos/foryou_repo.dart';

class ForYouNewsBloc {
  ForYouNewsRepo? _forYouNewsRepo;
  final _forYouDataStreamController =
      StreamController<ApiResponse<NewsResponseModel>>.broadcast();

  StreamSink<ApiResponse<NewsResponseModel>> get _forYouDataSink =>
      _forYouDataStreamController.sink;
  Stream<ApiResponse<NewsResponseModel>> get forYouDataStream =>
      _forYouDataStreamController.stream;

  ForYouNewsBloc() {
    _forYouNewsRepo = ForYouNewsRepo();
  }

  newsDataResponse(String country) async {
    _forYouDataSink.add(ApiResponse.loading(("Fetching Booking Data...")));

    try {
      NewsResponseModel _model =
          await _forYouNewsRepo!.foryounewsRequest(country);
      _forYouDataSink.add(ApiResponse.completed(_model));
    } catch (exception) {
      _forYouDataSink.add(ApiResponse.error(exception.toString()));
    }
  }

  dispose() {
    _forYouDataStreamController.close();
  }
}
