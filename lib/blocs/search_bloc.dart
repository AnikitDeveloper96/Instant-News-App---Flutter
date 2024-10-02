import 'dart:async';

import '../handlers/api_response.dart';
import '../models/responseModels/news_response_model.dart';
import '../repos/foryou_repo.dart';
import '../repos/search_repo.dart';

class SearchNewsBloc {
  SearchNewsRepo? _searchNewsRepo;
  final _searchNewsStreamController =
      StreamController<ApiResponse<NewsResponseModel>>.broadcast();

  StreamSink<ApiResponse<NewsResponseModel>> get _searchNewsSink =>
      _searchNewsStreamController.sink;
  Stream<ApiResponse<NewsResponseModel>> get searchNewsStream =>
      _searchNewsStreamController.stream;

  SearchNewsBloc() {
    _searchNewsRepo = SearchNewsRepo();
  }

  searchNewsResponse(String searchString) async {
    _searchNewsSink.add(ApiResponse.loading(("Fetching Booking Data...")));

    try {
      NewsResponseModel _model =
          await _searchNewsRepo!.searchewsRequest(searchString);
      _searchNewsSink.add(ApiResponse.completed(_model));
    } catch (exception) {
      _searchNewsSink.add(ApiResponse.error(exception.toString()));
    }
  }

  dispose() {
    _searchNewsStreamController.close();
  }
}
