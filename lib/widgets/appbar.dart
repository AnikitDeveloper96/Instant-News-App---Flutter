import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../screens/home/search_screen.dart';
import 'textStyles.dart';

class CustomAppbar {
  AppTextStyles appTextStyles = AppTextStyles();

  customAppBar(BuildContext context, int index, User? user,
      [TabController? controller, List<String>? categories]) {
    return SliverAppBar(
      elevation: 1.0,
      backgroundColor: Colors.white,
      centerTitle: true,
      actions: [
        user?.photoURL != null
            ? ClipOval(
                child: Material(
                  color: Colors.grey.withOpacity(0.3),
                  child: Image.network(
                    user?.photoURL ?? "",
                    fit: BoxFit.fitHeight,
                  ),
                ),
              )
            : ClipOval(
                child: Material(
                  color: Colors.grey.withOpacity(0.3),
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                          "${user?.displayName?.substring(0).toString()}")),
                ),
              )
      ],
      pinned: index == 0 ? false : true,
      floating: index == 0 ? false : true,
      leading: IconButton(
          onPressed: () => Navigator.pushReplacementNamed(
              context, SearchScreen.searchscreen),
          icon: const Icon(Icons.search, color: Colors.black, size: 24.0)),
      title: index == 0
          ? RichText(
              text: TextSpan(
                text: 'Instant ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                    fontSize: 20.0),
                children: <TextSpan>[
                  TextSpan(
                      text: 'News',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.blueColor,
                          fontSize: 20.0)),
                ],
              ),
            )
          : const Text("Headlines"),
      titleTextStyle: TextStyle(
          color: AppColors.blackColor,
          fontSize: 16.0,
          fontWeight: FontWeight.bold),
      bottom: index == 0
          ? PreferredSize(
              preferredSize: const Size.fromHeight(100), child: Container())
          : TabBar(
              controller: controller,
              labelColor: Colors.blue,
              dividerColor: AppColors.blueColor,
              indicatorColor: AppColors.blueColor,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3.0,
              isScrollable: true,
              padding: const EdgeInsets.only(right: 14.0),
              labelPadding: const EdgeInsets.only(left: 14.0),
              indicatorPadding: const EdgeInsets.only(left: 12.0),
              labelStyle:
                  appTextStyles.commonTextStyle(true, true, true, false),
              unselectedLabelStyle:
                  appTextStyles.commonTextStyle(true, true, false, false),
              unselectedLabelColor: Colors.black,
              onTap: (int selectedindex) {},
              tabs: List.generate(
                  categories!.length,
                  (index) => Tab(
                        child: Text(
                          categories[index],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ))),
    );
  }
}
