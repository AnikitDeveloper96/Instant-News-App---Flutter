import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';

import '../../arguments/news_arguments.dart';
import '../../blocs/foryou_bloc.dart';
import '../../constants/colors.dart';
import '../../handlers/api_response.dart';
import '../../models/responseModels/news_response_model.dart';
import 'headlines_details.dart';

class ForYou extends StatefulWidget {
  @override
  State<ForYou> createState() => _ForYouState();
}

class _ForYouState extends State<ForYou> {
  final bool _isSigningOut = false;
  final String formattedDate = DateFormat("EEEE, d MMM").format(DateTime.now());
  final ForYouNewsBloc _forYouNewsBloc = ForYouNewsBloc();

  void _onShare(BuildContext context, String shareLink) async {
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(shareLink,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  @override
  void initState() {
    super.initState();
    _forYouNewsBloc.newsDataResponse("in");
  }

  Future<void> refreshData() async {
    await Future.delayed(const Duration(milliseconds: 5))
        .then((value) => setState(() {
              _forYouNewsBloc.newsDataResponse("in");
            }));
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<LiquidPullToRefreshState> refreshIndicatorKey =
        GlobalKey<LiquidPullToRefreshState>();

    return RefreshIndicator(
      strokeWidth: 3,
      key: refreshIndicatorKey,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: refreshData,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Top Stories",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        color: Color(0xFF0D0821),
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            StreamBuilder<ApiResponse<NewsResponseModel>>(
              stream: _forYouNewsBloc.forYouDataStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data!.status) {
                    case Status.loading:
                      return Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFF0D0821)));
                    case Status.completed:
                      var articles = snapshot.data?.data?.articles ?? [];
                      if (articles.isEmpty) {
                        return Center(
                            child: Text("No News Found",
                                style: TextStyle(
                                    color: Color(0xFF0D0821),
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600)));
                      } else {
                        return ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var article = articles[index];
                            return GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                  context, HeadlinesDetails.headlinesDetails,
                                  arguments: NewsArguments(
                                      newsArguments: article.url)),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        child: CachedNetworkImage(
                                          imageUrl: article.urlToImage ??
                                              "https://mcdn.wallpapersafari.com/medium/87/17/VF4DQk.jpg",
                                          placeholder: (context, url) => Center(
                                              child: CircularProgressIndicator(
                                                  color: Color(0xFF0D0821))),
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        article.source.name ?? "",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Color(0xFF0D0821),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        article.title ?? "",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style: TextStyle(
                                            color: Color(0xFF0D0821),
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      article.description == null
                                          ? Container()
                                          : SizedBox(height: 8.0),
                                      article.description == null
                                          ? Container()
                                          : Text(
                                              article.description ?? "",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                              style: TextStyle(
                                                  color: Color(0xFF0D0821),
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                      SizedBox(height: 8.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            formattedDate,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              showModalBottomSheet<void>(
                                                context: context,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                    12.0))),
                                                builder:
                                                    (BuildContext context) {
                                                  return Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      ListTile(
                                                        onTap: () => _onShare(
                                                            context,
                                                            article.url),
                                                        leading: Icon(
                                                            Icons.share,
                                                            size: 24.0,
                                                            color:
                                                                Colors.black),
                                                        title: Text("Share",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 18.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                      ),
                                                      ListTile(
                                                        onTap: () => Navigator.pushNamed(
                                                            context,
                                                            HeadlinesDetails
                                                                .headlinesDetails,
                                                            arguments: NewsArguments(
                                                                newsArguments:
                                                                    article
                                                                        .url)),
                                                        leading: Icon(
                                                            Icons.webhook_sharp,
                                                            size: 24.0,
                                                            color:
                                                                Colors.black),
                                                        title: Text(
                                                            "Go to ${article.source.name}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 18.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            icon: Icon(Icons.more_vert,
                                                size: 24.0,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      article.url.isEmpty
                                          ? Container()
                                          : GestureDetector(
                                              onTap: () => Navigator.pushNamed(
                                                  context,
                                                  HeadlinesDetails
                                                      .headlinesDetails,
                                                  arguments: NewsArguments(
                                                      newsArguments:
                                                          article.url)),
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    top: 8.0, right: 12.0),
                                                decoration: BoxDecoration(
                                                  color: AppColors.whiteColor,
                                                  border: Border.all(
                                                      color:
                                                          AppColors.greyColor),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(Icons.newspaper,
                                                            color: Color(
                                                                0xFF0D0821),
                                                            size: 24.0),
                                                        SizedBox(width: 8.0),
                                                        Text(
                                                          "Full Coverage of this Story",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 18.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
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
                          separatorBuilder: (context, index) => Container(),
                          itemCount: articles.length,
                        );
                      }
                    case Status.error:
                      return Center(
                          child: ElevatedButton(
                              onPressed: () =>
                                  _forYouNewsBloc.newsDataResponse("in"),
                              child: Text("Retry")));
                  }
                }
                return Center(
                    child: CircularProgressIndicator(color: Color(0xFF0D0821)));
              },
            ),
          ],
        ),
      ),
    );
  }
}
