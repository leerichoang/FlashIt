import 'package:flutter/material.dart';
import 'textstorage.dart';
import 'dart:async';
import 'dart:io';
import 'viewcard.dart';
import 'homescreen.dart';

class ViewDecks extends StatefulWidget {
  final TextStorage storage;
  ViewDecks({Key key, @required this.storage}) : super(key: key);

  @override
  _ViewDecks createState() => _ViewDecks();
}

class _ViewDecks extends State<ViewDecks> {
  List<String> _card;
  List<String> _deck;
  String _deckName;  
  String _file;
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  void initState() {
    super.initState();
    widget.storage.readFile().then((String text) {
      setState(() {
        _deckName = text;                       // pulls text from file
      });
      _deck = _deckName.split('\n');            // split string to array
    });
  }

  Future<File> _clearContentsInTextFile() async {
    setState(() {
      _file = '';
    });

    return widget.storage.cleanFile();
  }

  Future <bool>_onWillPop() async {     
      Navigator.pop(context); 
      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen()),                                                    
      );
      return true;
  }


  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        appBar: AppBar(
          title: Text('View Sets'),
          actions: <Widget>[
            //new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
          ],
          backgroundColor: Colors.blue,
        ),
        body: _buildDecks(),
      )
      );
  }

   Widget _buildDecks() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (BuildContext _context, int i) {

          if (i != _deck.length) { 
          return _buildDeckRow(_deck[i]);
        }
      },
      itemCount: _deck.length,
    );
  }

    Widget _buildDeckRow(String deckName)
  { 
    return new ListTile(
      title: new Text(
        '$deckName',
        style: _biggerFont,
      ),
      onTap: () {
      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewCard(storage: TextStorage(), filename:deckName)), 
                                                   
      );  
      }
      );
    }
}
