// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'episodes.dart';
import 'alarm.dart';
import 'podcast_player.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'test.dart';
import 'test2.dart';

// https://thecyberwire.libsyn.com/rss
final url = 'https://podcast.npo.nl/feed/met-het-oog-op-morgen.xml';
//'https://podcasts.files.bbci.co.uk/p02nq0gn.rss';
//'https://itsallwidgets.com/podcast/feed';

class Podcast with ChangeNotifier {
  RssFeed _feed;
  RssItem _selectedItem;
  RssItem _playItem;


  RssFeed get feed => _feed;
  void parse(String url) async {
    final res = await http.get(url);
    final xmlStr = res.body;
    _feed = RssFeed.parse(xmlStr);
    notifyListeners();
  }

  RssItem get selectedItem => _selectedItem;
  set selectedItem(RssItem value) {
    _selectedItem = value;
    notifyListeners();
  }

  RssItem get playItem => _playItem;
  set playItem(RssItem value) {
    _playItem = value;
    notifyListeners();
  }

}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (_) => Podcast()..parse(url),
      child: MaterialApp(
      title: 'Podcast alarm',
      theme: ThemeData(          // Add the 3 lines from here...
        fontFamily: 'SourceSansPro',
        primaryColor: Color(0xff1B2C57),
        accentColor: Color(0xff65D1BA)
      ),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          bottomNavigationBar: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.library_music)), // available episodes
              Tab(icon: Icon(Icons.access_alarms)), // setting the alarm
              Tab(icon: Icon(Icons.radio)),
              Tab(icon: Icon(Icons.radio)),// playing the alarm
            ],
          ),
          body: TabBarView(
            children: [
              EpisodesPage(),
              AlarmPage(),
              TestPage(),
              Player(),
            ],
          ),
        ),
      ),
    ));
  }
}