import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Welcome to Flutter',
      home: new RandomWords()
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {

  var start = 0;

  final _suggestions = <String>[];

  final _saved = new Set<String>();

  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();
        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          var i = start;
          for (; i < start + 10; i ++) {
            _suggestions.add(i.toString());
          }
          start += 10;
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(String text) {
    final alreadySaved = _saved.contains(text);
    return new ListTile(
      title: new Text(
        'title-'+text,
        style: _biggerFont
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(
          () {
            if (alreadySaved) {
              _saved.remove(text);
            } else {
              _saved.add(text);
            }
          }
        );
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(new MaterialPageRoute(
      builder: (context) {
        final tiles = _saved.map((text) {
          return new ListTile(
            title: new Text(
              'title-'+text,
              style: _biggerFont,
            ),
          );
        });
        final divided = ListTile.divideTiles(
          context: context,
          tiles: tiles
        ).toList();
        return new Scaffold(
          appBar: new AppBar(
            title: new Text('Saved Suggestions'),
          ),
          body: new ListView(children: divided),
        );
      }
    ));
  }
}
