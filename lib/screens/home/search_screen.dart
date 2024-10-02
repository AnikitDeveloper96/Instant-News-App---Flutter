import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:instantnews/date_extension.dart';
import 'package:share_plus/share_plus.dart';

import '../../arguments/news_arguments.dart';
import '../../blocs/search_bloc.dart';
import '../../constants/colors.dart';
import '../../handlers/api_response.dart';
import '../../models/responseModels/news_response_model.dart';
import '../../widgets/textStyles.dart';
import 'headlines_details.dart';

class SearchScreen extends StatefulWidget {
  static const String searchscreen = "searchscreen";
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _text = TextEditingController();
  bool _validate = false;

  AppTextStyles appTextStyles = AppTextStyles();

  SearchNewsBloc searchNewsBloc = SearchNewsBloc();

  /// share content
  void _onShare(BuildContext context, String shareLink) async {
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(shareLink,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          title: TextField(
            controller: _text,
            decoration: InputDecoration(
              hintText: 'Search for topics...',
              errorText: _validate ? "Feild cant be empty !" : null,
              hintStyle: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
              border: InputBorder.none,
            ),
            maxLines: null,
            style: const TextStyle(
              color: Colors.black,
            ),
            onChanged: (String onchanges) {
              setState(() {
                _validate = true;
                onchanges = _text.text;
              });
              onchanges.isNotEmpty
                  ? searchNewsBloc.searchNewsResponse(onchanges)
                  : "";
            },
          ),
        ),
        body: StreamBuilder<ApiResponse<NewsResponseModel>>(
          stream: searchNewsBloc.searchNewsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status) {
                case Status.loading:
                  return Container(
                    color: Colors.white,
                    child: const Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFF0D0821))),
                  );

                case Status.completed:
                  var getSnapshotdata = snapshot.data?.data;
                  print("For you inside data");

                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.separated(
                        itemBuilder: (context, snapshotIndex) {
                          var getSnapshot = snapshot.data?.data?.articles;
                          return GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                context, HeadlinesDetails.headlinesDetails,
                                arguments: NewsArguments(
                                    newsArguments:
                                        getSnapshot[snapshotIndex].url)),
                            child: Card(
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 12.0,
                                    right: 12.0,
                                    top: 12.0,
                                    bottom: 12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: Image.network(getSnapshot![
                                                  snapshotIndex]
                                              .urlToImage ??
                                          "https://www.washingtonpost.com/wp-apps/imrs.php?src=https://arc-anglerfish-washpost-prod-washpost.s3.amazonaws.com/public/2P74XVEMRAI63ODKFY5HOM3LRY_size-normalized.jpg&w=1440"),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 12.0, bottom: 12.0, right: 20.0),
                                      child: Text(
                                        getSnapshot[snapshotIndex]
                                                .source
                                                .name
                                                .toString()
                                                .isNotEmpty
                                            ? getSnapshot[snapshotIndex]
                                                .source
                                                .name
                                                .toString()
                                            : "",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        textAlign: TextAlign.justify,
                                        textScaleFactor: 1.3,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 12.0, bottom: 12.0, right: 20.0),
                                      child: Text(
                                        getSnapshot[snapshotIndex].title,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        textAlign: TextAlign.justify,
                                        textScaleFactor: 1.3,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          const EdgeInsets.only(bottom: 12.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(getSnapshot[snapshotIndex]
                                              .publishedAt
                                              .timeAgo(numericDates: true)),
                                          IconButton(
                                              onPressed: () {
                                                showModalBottomSheet<void>(
                                                  context: context,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          // <-- SEE HERE
                                                          borderRadius:
                                                              BorderRadius
                                                                  .vertical(
                                                    top: Radius.circular(12.0),
                                                  )),
                                                  builder:
                                                      (BuildContext context) {
                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        ListTile(
                                                          onTap: () => _onShare(
                                                              context,
                                                              getSnapshot[
                                                                      snapshotIndex]
                                                                  .url),
                                                          leading: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top:
                                                                          12.0),
                                                              child: const Icon(
                                                                Icons.share,
                                                                size: 24.0,
                                                                color: Colors
                                                                    .black,
                                                              )),
                                                          title: const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 12.0),
                                                            child: Text(
                                                              "Share",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        ListTile(
                                                          onTap: () => Navigator.pushNamed(
                                                              context,
                                                              HeadlinesDetails
                                                                  .headlinesDetails,
                                                              arguments: NewsArguments(
                                                                  newsArguments:
                                                                      getSnapshot[
                                                                              snapshotIndex]
                                                                          .url)),
                                                          leading: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top:
                                                                          12.0),
                                                              child: const Icon(
                                                                Icons
                                                                    .webhook_sharp,
                                                                size: 24.0,
                                                                color: Colors
                                                                    .black,
                                                              )),
                                                          title: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 12.0),
                                                            child: Text(
                                                              "Go to ${getSnapshot[snapshotIndex].source.name.toString()}",
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              icon: Icon(
                                                Icons.more_vert,
                                                color: AppColors.blackColor,
                                                size: 20.0,
                                              ))
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => Navigator.pushNamed(context,
                                          HeadlinesDetails.headlinesDetails,
                                          arguments: NewsArguments(
                                              newsArguments:
                                                  getSnapshot[snapshotIndex]
                                                      .url)),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.whiteColor,
                                          border: Border.all(
                                              color: AppColors.greyColor),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.newspaper,
                                                color: AppColors.blueColor,
                                                size: 20.0,
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.all(12.0),
                                                child: Text(
                                                  "Full Coverage of this Story",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: snapshot.data?.data?.articles.length ?? 0),
                  );

                case Status.error:
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(snapshot.error.toString(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0)),
                      ]);
              }
            } else {
              return Container();
            }
          },
        ));
  }
}
