import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../arguments/news_arguments.dart';
import '../../constants/colors.dart';

class HeadlinesDetails extends StatefulWidget {
  static String headlinesDetails = "headlinesDetails";
  const HeadlinesDetails({super.key});

  @override
  State<HeadlinesDetails> createState() => _HeadlinesDetailsState();
}

class _HeadlinesDetailsState extends State<HeadlinesDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as NewsArguments;
    late final WebViewController controller;

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(args.newsArguments),
      );
    print("Getting arguments from url is ${args.newsArguments.toString()} ");
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
          elevation: 3.0,
          backgroundColor: AppColors.whiteColor,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFF0D0821),
              size: 20.0,
            ),
          ),
          title: RichText(
            text: TextSpan(
              text: 'Instant ',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D0821),
                  fontSize: 20.0),
              children: <TextSpan>[
                TextSpan(
                    text: 'News',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D0821),
                        fontSize: 20.0)),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          actions: [
            Container(
                margin: const EdgeInsets.only(right: 12.0),
                child: Tooltip(
                  message: "Share Page",
                  child: IconButton(
                      onPressed: () {
                        // final RenderObject? box = context.findRenderObject();
                        Share.share(
                          args.newsArguments.toString(),
                          // sharePositionOrigin:
                          //     box.localToGlobal(Offset.zero) & box.size);
                        );
                      },
                      icon: Icon(
                        Icons.share,
                        color: AppColors.blackColor,
                        size: 20.0,
                      )),
                )),
          ]),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
