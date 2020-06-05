import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'podcast_player.dart';

class EpisodesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1B2C57),
      body:
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 40.0, top: 80),
                  child: Row(
                    children: <Widget>[
                      Text('Podcast',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0)),
                      SizedBox(width: 10.0),
                      Text('Episodes',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontSize: 25.0))
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height - 190.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
                  ),
                  child: Consumer<Podcast>(
                      builder: (context, podcast, _) {
                        return podcast.feed != null
                            ? EpisodeListView(rssFeed: podcast.feed)
                            : Center(child: CircularProgressIndicator());
                      }
                  ),
                ),
              ],
            )
      );
  }

}

class EpisodeListView extends StatelessWidget {
  const EpisodeListView({Key key, @required this.rssFeed,}) : super(key: key);

  final RssFeed rssFeed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0),
      child:
        ListView(
          children: rssFeed.items
              .map(
                  (i) => ListTile(
                  onTap: () {
                    Provider.of<Podcast>(context).playItem = i;
                    Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PodcastPage(),
                        )
                    );
                  },
                  title: Text(i.title,
                    style: TextStyle(
                      height: 3,
                    ),),
                  subtitle:
                    Column(
                      children: <Widget>[
                        Text(
                          i.pubDate,
                          textAlign: TextAlign.left,
                          style: TextStyle(

                          ),
                        ),
                        SizedBox(height: 15.0,),
                        Text(
                          i.description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    //Icon(Icons.fast_forward, color: Colors.black,),
                  ),
          ).toList(),
        ),
    );
  }
}