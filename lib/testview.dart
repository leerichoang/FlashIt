import 'package:flutter/material.dart';
import 'textstorage.dart';
import 'begintest.dart';

// Can be a Stateless Widget
// This page will be used to view decks and select which one to self test
// This page will also retrieve the decks and store them in separate arrays
// User chooses which one to pass into the selftest

// Class initialization
class TestCards extends StatefulWidget {
  final TextStorage storage;
  final String filename;
  final TextStorage scorefile;
  TestCards({Key key, @required this.storage, this.filename, this.scorefile})
      : super(key: key);

  @override
  _TestCards createState() => _TestCards();
}

class _TestCards extends State<TestCards> {
  String _deckName;
  String filename;
  final Set<String> _saved = new Set<String>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
  List<String> deck = [];
  List<String> deckSets = [];
  int deckCount = 0;
  String _ans;
  int n = 0;
  int i = 0;

  @override
  void initState() {
    super.initState();

    widget.storage.readFile().then((String text) {
      setState(() {
        _deckName = text; // pulls text from file
      });
      deckSets = _deckName.split('\n'); // split string to array
      deckCount++;
    });
  }

  // Widget for building app page
  // Will implement dynamic creation of buttons for every file that is created

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose a deck'),
      ),
      body: _buildTest(),
      bottomNavigationBar: new BottomAppBar(
          color: Colors.blue,
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.create),
                tooltip: 'Create a Flashcard',
                onPressed: () {
                  //createButton();
                },
              ),
              IconButton(
                icon: Icon(Icons.folder_open),
                tooltip: 'Manage Flashcards',
                onPressed: () {
                  //manageButton();
                },
              ),
              IconButton(
                icon: Icon(Icons.school),
                tooltip: 'Test Flashcards',
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {},
              ),
            ],
          )),
    );
  }

  testSelf(String deckNam) {
    widget.storage.readDeck(deckNam).then((String text) {
      setState(() {
        _ans = text; // pulls text from file
      });
      deck = _ans.split('\n'); // split string to array
    });
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BeginTest(deck: deck, filename: deckNam)),
    );
  }

  resultData() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            content: new Text('You have scored a 100% 3/5 times on this deck!'),
            actions: <Widget>[
              new FlatButton(
                  child: new Text("Ok"),
                  onPressed: () {
                    //save here
                    Navigator.pop(context);
                  }),
            ]);
      },
    );
  }

  Widget _buildTest() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (BuildContext _context, int i) {
          if (i != deckSets.length) {
            return _buildTestRow(deckSets[i], i);
          }
        });
  }

  Widget _buildTestRow(String deckName, int i) {
    return Column(
      children: <Widget>[
        new Divider(color: Colors.black, indent: 1.0),
        new ListTile(
          title: new Text(
            '$deckName',
            style: _biggerFont,
            textAlign: TextAlign.center,
          ),
          onTap: () {
            testSelf(deckSets[i]);
          },
          onLongPress: () {
            resultData();
          },
        ),
      ],
    );
  }
/*
  createButton() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddCard(storage: TextStorage())),
    );
  }

  manageButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ViewCard(storage: TextStorage(), filename:filename)),
    );
  }*/

}

/*
  @override
  Widget build(BuildContext context){
    final bool alreadySaved = _saved.contains(deckSets[0]);
    return new ListTile(
      title: new Text(
        '$_deckName[0]',
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.check_box : Icons.check_box_outline_blank,
        color: alreadySaved ? Colors.blue : null,
      ),
      onLongPress: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(deckSets[0]);
          } else {
            _saved.add(deckSets[0]);
          }
        });
      },
      onTap: () {
        testSelf(deckSets[0])
      },
    );
  }
*/
