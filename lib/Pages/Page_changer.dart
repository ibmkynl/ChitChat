import 'package:chitchat/Pages/Matches_page.dart';
import 'package:chitchat/Pages/Messages_Page.dart';
import 'package:chitchat/pages/Search_Page.dart';

import 'package:flutter/material.dart';

import '../consts.dart';

class PageChanger extends StatefulWidget {
  final userId;

  PageChanger({this.userId});

  @override
  _PageChangerState createState() => _PageChangerState();
}

class _PageChangerState extends State<PageChanger> {
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      SearchPage(
        userId: widget.userId,
      ),
      MatchesPage(
        userId: widget.userId,
      ),
      MessagesPage(
        userId: widget.userId,
      )
    ];
    return Theme(
      data: ThemeData(
          primaryColor: kScaffoldBackGroundColor,
          accentColor: Colors.white,
          scaffoldBackgroundColor: Colors.white),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            leading: Container(),
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TabBar(
                  tabs: <Widget>[
                    Tab(icon: Icon(Icons.search)),
                    Tab(icon: Icon(Icons.people)),
                    Tab(icon: Icon(Icons.message)),
                  ],
                )
              ],
            ),
          ),
          body: TabBarView(
            children: pages,
          ),
        ),
      ),
    );
  }
}
/*bottomNavigationBar: BottomBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      )*/
