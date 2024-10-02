import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';

import '../../arguments/news_arguments.dart';
import '../../blocs/news_bloc.dart';
import '../../constants/colors.dart';
import '../../handlers/api_response.dart';
import '../../models/responseModels/news_response_model.dart';
import '../../widgets/appbar.dart';
import '../../widgets/textStyles.dart';
import 'headlines_details.dart';

extension DateTimeExtension on DateTime {
  String timeAgo({bool numericDates = true}) {
    final date2 = DateTime.now();
    final difference = date2.difference(this);

    if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}

class Headlines extends StatefulWidget {
  // const Headlines({Key? key, required User user})
  //     : _user = user,
  //       super(key: key);

  // final User _user;
  @override
  _HeadlinesState createState() => _HeadlinesState();
}

class _HeadlinesState extends State<Headlines>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  int _selectedIndex = 0;

  AppTextStyles appTextStyles = AppTextStyles();

  HeadlinesNewsBloc headlinesNewsBloc = HeadlinesNewsBloc();

  List<String> categories = [
    "Business",
    "Technology",
    "Entertainment",
    "Sports",
    "Science",
    "Health"
  ];
  late User _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // _user = widget._user;
    // Create TabController for getting the index of current tab
    _controller = TabController(
        length: categories.length, vsync: this, initialIndex: _selectedIndex);
    headlinesNewsBloc.newsDataResponse("in", categories[0]);
    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;

        print("Selected Index: ${_controller.index}");
      });
      headlinesNewsBloc.newsDataResponse("in", categories[_selectedIndex]);
    });
  }

  /// share content
  void _onShare(BuildContext context, String shareLink) async {
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(shareLink,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  // Custom appbar

  CustomAppbar customAppbar = CustomAppbar();

  late final User? user;
  @override
  Widget build(BuildContext context) {
    return const CustomSliverAppbar();
    // DefaultTabController(
    //   length: 2,
    //   child: Scaffold(
    //     backgroundColor: Colors.white,
    //     body: NestedScrollView(
    //       // This builds the scrollable content above the body
    //       headerSliverBuilder: (context, innerBoxIsScrolled) => [
    //         SliverAppBar(
    //           floating: false,
    //           pinned: false,
    //           //  primary: true,
    //           forceElevated: innerBoxIsScrolled,
    //           bottom: const TabBar(tabs: [
    //             Tab(text: 'Tab 1'),
    //             Tab(text: 'Tab 2'),
    //           ]),
    //         ),
    //       ],
    //       body: TabBarView(
    //         children: [
    //           ListView.builder(
    //             itemBuilder: (context, index) => ListTile(
    //               title: Text(
    //                 'Tab 1 content $index',
    //               ),
    //             ),
    //           ),
    //           ListView.builder(
    //             itemBuilder: (context, index) => ListTile(
    //               title: Text(
    //                 'Tab 2 content $index',
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}

class CustomSliverAppbar extends StatefulWidget {
  const CustomSliverAppbar({super.key});

  @override
  _CustomSliverAppbarState createState() => _CustomSliverAppbarState();
}

class _CustomSliverAppbarState extends State<CustomSliverAppbar>
    with SingleTickerProviderStateMixin {
  List<String> categories = [
    "Business",
    "Technology",
    "Entertainment",
    "Sports",
    "Science",
    "Health"
  ];
  int _selectedIndex = 0;
  late TabController _tabController;

  HeadlinesNewsBloc headlinesNewsBloc = HeadlinesNewsBloc();

  late User _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Create TabController for getting the index of current tab
    _tabController = TabController(
        length: categories.length, vsync: this, initialIndex: _selectedIndex);
    headlinesNewsBloc.newsDataResponse("in", categories[0]);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;

        print("Selected Index: ${_tabController.index}");
      });
      headlinesNewsBloc.newsDataResponse("in", categories[_selectedIndex]);
    });
  }

  /// share content
  void _onShare(BuildContext context, String shareLink) async {
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(shareLink,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  final GlobalKey<LiquidPullToRefreshState> refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  Future<void> refreshData() async {
    // Simulating an API request or data refresh
    await Future.delayed(const Duration(milliseconds: 5))
        .then((value) => setState(() {
              headlinesNewsBloc.newsDataResponse(
                  "in", categories[_selectedIndex]);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      strokeWidth: 3,
      key: refreshIndicatorKey,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: refreshData,
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                pinned: true,
                forceElevated: innerBoxIsScrolled,
                backgroundColor: Colors.white,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: TabBar(
                    controller: _tabController,
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(
                        width: 3.0,
                        color: Color(0xFF0D0821),
                      ),
                      insets: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    indicatorSize:
                        TabBarIndicatorSize.tab, // Highlight only the label
                    isScrollable: true,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 14.0),
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          18.0, // Increase the font size for the selected tab
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0, // Smaller font size for unselected tabs
                    ),
                    unselectedLabelColor:
                        Color(0xFF757575), // Lighter color for unselected tabs
                    labelColor:
                        Color(0xFF0D0821), // Darker color for the selected tab
                    tabs: List.generate(
                      categories.length,
                      (index) => Tab(
                        text: categories[index],
                      ),
                    ),
                  ),
                ),
                floating: true,
              )
            ];
          },
          body: TabBarView(
              controller: _tabController,
              children: List.generate(
                  categories.length,
                  (index) => StreamBuilder<ApiResponse<NewsResponseModel>>(
                        stream: headlinesNewsBloc.newsDataStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            switch (snapshot.data!.status) {
                              case Status.loading:
                                return const Center(
                                    child: CircularProgressIndicator(
                                        color: Color(0xFF0D0821)));

                              case Status.completed:
                                List getSnapshotdata =
                                    snapshot.data?.data?.articles ?? [];
                                print("For you inside data");

                                String formattedDate = DateFormat("EEEE, d MMM")
                                    .format(DateTime.now());

                                return getSnapshotdata.isEmpty
                                    ? Column(
                                        children: [
                                          Text(
                                            "No News Found",
                                            style: const TextStyle(
                                              color: Color(0xFF0D0821),
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      )
                                    : ListView.separated(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          var article = getSnapshotdata[index];
                                          return GestureDetector(
                                            onTap: () => Navigator.pushNamed(
                                                context,
                                                HeadlinesDetails
                                                    .headlinesDetails,
                                                arguments: NewsArguments(
                                                    newsArguments:
                                                        article.url)),
                                            child: Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                      child: CachedNetworkImage(
                                                        imageUrl: article
                                                                .urlToImage ??
                                                            "https://mcdn.wallpapersafari.com/medium/87/17/VF4DQk.jpg",
                                                        placeholder: (context,
                                                                url) =>
                                                            Center(
                                                                child: CircularProgressIndicator(
                                                                    color: Color(
                                                                        0xFF0D0821))),
                                                      ),
                                                    ),
                                                    SizedBox(height: 8.0),
                                                    Text(
                                                      article.source.name ?? "",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF0D0821),
                                                          fontSize: 22.0,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    SizedBox(height: 8.0),
                                                    Text(
                                                      article.title ?? "",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 3,
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF0D0821),
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    article.description == null
                                                        ? Container()
                                                        : SizedBox(height: 8.0),
                                                    article.description == null
                                                        ? Container()
                                                        : Text(
                                                            article.description ??
                                                                "",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 3,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF0D0821),
                                                                fontSize: 14.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                    SizedBox(height: 8.0),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          formattedDate,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 18.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        IconButton(
                                                          onPressed: () {
                                                            showModalBottomSheet<
                                                                void>(
                                                              context: context,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.vertical(
                                                                          top: Radius.circular(
                                                                              12.0))),
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <Widget>[
                                                                    ListTile(
                                                                      onTap: () => _onShare(
                                                                          context,
                                                                          article
                                                                              .url),
                                                                      leading: Icon(
                                                                          Icons
                                                                              .share,
                                                                          size:
                                                                              24.0,
                                                                          color:
                                                                              Colors.black),
                                                                      title: Text(
                                                                          "Share",
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 18.0,
                                                                              fontWeight: FontWeight.w500)),
                                                                    ),
                                                                    ListTile(
                                                                      onTap: () => Navigator.pushNamed(
                                                                          context,
                                                                          HeadlinesDetails
                                                                              .headlinesDetails,
                                                                          arguments:
                                                                              NewsArguments(newsArguments: article.url)),
                                                                      leading: Icon(
                                                                          Icons
                                                                              .webhook_sharp,
                                                                          size:
                                                                              24.0,
                                                                          color:
                                                                              Colors.black),
                                                                      title: Text(
                                                                          "Go to ${article.source.name}",
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 18.0,
                                                                              fontWeight: FontWeight.w500)),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          },
                                                          icon: Icon(
                                                              Icons.more_vert,
                                                              size: 24.0,
                                                              color:
                                                                  Colors.black),
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
                                                                        article
                                                                            .url)),
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 8.0,
                                                                      right:
                                                                          12.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColors
                                                                    .whiteColor,
                                                                border: Border.all(
                                                                    color: AppColors
                                                                        .greyColor),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                              ),
                                                              child: Center(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          12.0),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Icon(Icons.newspaper,
                                                                          color: Color(
                                                                              0xFF0D0821),
                                                                          size:
                                                                              24.0),
                                                                      SizedBox(
                                                                          width:
                                                                              8.0),
                                                                      Text(
                                                                        "Full Coverage of this Story",
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize:
                                                                                18.0,
                                                                            fontWeight:
                                                                                FontWeight.bold),
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
                                        separatorBuilder: (context, index) =>
                                            Container(),
                                        itemCount: getSnapshotdata.length,
                                      );

                              case Status.error:
                                return Center(
                                  child: CircularProgressIndicator(
                                      color: Color(0xFF0D0821)),
                                );
                            }
                          } else {
                            return Center(
                                child: CircularProgressIndicator(
                                    color: Color(0xFF0D0821)));
                          }
                        },
                      ))),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class TabA extends StatelessWidget {
  const TabA({super.key});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.separated(
        separatorBuilder: (context, child) => const Divider(
          height: 1,
        ),
        padding: const EdgeInsets.all(0.0),
        itemCount: 30,
        itemBuilder: (context, i) {
          return const SizedBox(
            height: 100,
            width: double.infinity,
          );
        },
      ),
    );
  }
}
