import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'episodes.dart';
import 'package:provider/provider.dart';

class PodcastPage extends StatefulWidget {
  PodcastPage({this.item});
  final RssItem item;

  @override
  _PodcastPageState createState() => _PodcastPageState();
}

class _PodcastPageState extends State<PodcastPage> {

  @override
  Widget build(BuildContext context) {

    final playItem = Provider.of<Podcast>(context).playItem;
    final selectedItem = Provider.of<Podcast>(context).selectedItem;

    return Scaffold(
      appBar: AppBar(title: Text('Episode')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
            child: Column(
              children: <Widget>[
                Text(playItem.title,
                  style: TextStyle(
                    fontFamily: 'Nunito-Bold',
                    letterSpacing: 1.0,
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 15.0,),
                Text(playItem.description,
                  style: TextStyle(
                      fontFamily: 'Nunito-Bold',
                      letterSpacing: 1.0,
                      fontSize: 15,
                      color: Colors.black54,
                      fontWeight: FontWeight.normal
                  ),
                ),
              ],
            )
          ),
          AudioControls(),
          CheckboxListTile(
            value: selectedItem != null && selectedItem == playItem ? true : false,
            onChanged: ((bool value) {
              if (value == true) {
                Provider.of<Podcast>(context).selectedItem = playItem;
              }
             else {
                Provider.of<Podcast>(context).selectedItem = null;
              }
            }),
            title: Text("Select as alarm",
              style: TextStyle(
                  fontFamily: 'Nunito-Bold',
              ),),
            controlAffinity: ListTileControlAffinity.leading,
            secondary: Icon(Icons.archive),
            activeColor: Colors.red,
          ),
        ],
      ),
    );
  }
}

class AudioControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
            child: PlaybackButtons(),
        )
      ],
    );
  }

}

class PlaybackButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        PlaybackButton(),
      ],
    );
  }

}

// PLAY BUTTON
class PlaybackButton extends StatefulWidget {
  @override
  _PlaybackButtonState createState() => _PlaybackButtonState();
}

class _PlaybackButtonState extends State<PlaybackButton>{
  bool _isPlaying = false;
  FlutterSound _sound;
  double _playPosition;
  Stream<PlayStatus> _playerSubscription;

  @override
  void initState() {
    super.initState();
    _sound = FlutterSound();
    _playPosition = 0;
  }

  void _stop() async {
    await _sound.stopPlayer();
    setState(() => _isPlaying = false);
  }

  void _play(String url) async {
    await _sound.startPlayer(url);
    _playerSubscription = _sound.onPlayerStateChanged..listen((e) {
      if (e != null) {
        setState(() => _playPosition = (e.currentPosition / e.duration));
      }
    });
    setState(() => _isPlaying = true);
  }

  @override
  Widget build(BuildContext context) {
    final item = Provider.of<Podcast>(context).playItem;
    return
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [
            Slider(value: _playPosition, onChanged: null,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                IconButton(icon: Icon(Icons.fast_rewind), onPressed:null),
                IconButton(
                icon: _isPlaying ? Icon(Icons.stop) : Icon(Icons.play_arrow),
                onPressed: () {
                  if (_isPlaying) {
                    _stop();
                  }
                  else {
                    _play(item.guid);
                  }
                },
                ),
                IconButton(icon: Icon(Icons.fast_forward), onPressed:null),
              ]
            )]
    );
  }
}