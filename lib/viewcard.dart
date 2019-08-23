import 'package:flutter/material.dart';
import 'textstorage.dart';
import 'dart:async';
import 'dart:io';
import 'addcard.dart';
import 'homescreen.dart';
import 'viewdeck.dart';


class ViewCard extends StatefulWidget {
  final TextStorage storage;
  final String filename; 
  ViewCard({Key key, @required this.storage, @required this.filename}) : super(key: key);

  @override
  _ViewCard createState() => _ViewCard();
}

class _ViewCard extends State<ViewCard> {
  List<String> _card;
  String _file;
  final Set<String> _saved = new Set<String>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
  TextEditingController _newAnswer = new TextEditingController();
  TextEditingController _newQuestion = new TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.storage.readDeck(widget.filename).then((String text) {
      setState(() {
        _file = text;     
        _card = _file.split('\n');                   // pulls text from file
      });
      //_card = _file.split('\n');            // split string to array
    });
  }

  Future<File> _clearContentsInTextFile() async {
    setState(() {
      _file = '';
    });
    return widget.storage.cleanFile();
  }

  Future <bool>_onWillPop() async {
      //Navigator.pop(context);
          
      return true;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
    child: new Scaffold(
      appBar: AppBar(
        title: Text('View Flashcards'),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
        ],
        backgroundColor: Colors.blue,
      ),
      body: _buildFlashCard(),
      bottomNavigationBar: new BottomAppBar(
        color: Colors.blue,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            //bottom app functionality here
           
            IconButton(
              icon:
                  Icon(Icons.delete_forever),         //delete current card in progress
              tooltip: 'Delete current Flashcard',
              onPressed: () {
                return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        content: new Text(
                            "Are you sure you would like to delete all flashcards?"),
                        actions: <Widget>[
                          new FlatButton(
                              child: new Text("Yes"),
                              onPressed: () {
                                //save here
                                _clearContentsInTextFile();
                                Navigator.pop(context);
                              }),
                          new FlatButton(
                              child: new Text("No"),
                              onPressed: () {
                                Navigator.pop(context);
                              })
                        ]);
                  },
                );
              },
            ),

            IconButton(
              icon: Icon(Icons.plus_one), //return home
              tooltip: 'Add card',
              onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddCard(storage: TextStorage(), filename:widget.filename)),
                  );
              },
            ),
          ],
        ),
      ),
    )
    );
  }

  Widget _buildFlashCard() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (BuildContext _context, int i) {
        if (i.isOdd) {
          return Divider();
        } else if (i + 1 != _card.length) {
          return _buildRow(_card[i], _card[i + 1]);
        }
      },
      itemCount: _card.length,
    );
  }

  Widget _buildAnswer(String answer, String question) {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(builder: (BuildContext context) {
        return new Scaffold(
          appBar: new AppBar(
            title: const Text('Answer: '),
            actions: <Widget>[
              new IconButton(
                icon:  Icon(Icons.delete), 
                tooltip: 'Delete Flash Card',
                onPressed: () {
                  question = "";
                  answer = "";
                },
              ),
            ],
          ),
          body: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 0.0),
                  child: RichText(
                    text: TextSpan(
                      text: "Q: $question",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 0.0),
                  child: Text("\n\nA: $answer"),
                ),
              ],
            ),
          ),
          bottomNavigationBar: new BottomAppBar(
            color: Colors.blue,
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                //bottom app functionality here
                IconButton(
                  icon: Icon(Icons.check), //save the current card
                  tooltip: 'Mark Flashcard',
                  onPressed: () {
                    _saved.add(question);
                    Navigator.pop(context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.backspace), //return home
                  tooltip: 'Back',
                  onPressed: () {
                    _saved.remove(question);
                    Navigator.pop(context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  tooltip: 'Edit Question',
                  onPressed: (){
                    showDialog<String> (context: context, 
                      child: new AlertDialog(
                        contentPadding: const EdgeInsets.all(16),
                        
                        content: new Row(children: <Widget> [
                          new Expanded (
                            child: new TextField (
                              controller: _newQuestion,
                              decoration: new InputDecoration(
                              labelText: 'Enter New Question',)
                            ),
                            )
                        ],
                        ),
                      
                      actions: <Widget> [
                        new FlatButton (
                          child: const Text('CANCEL'),
                          onPressed:() {
                            _newQuestion.clear();
                            Navigator.pop(context);
                          }
                        ),
                        new FlatButton(
                          child:const Text('ENTER'),
                          onPressed: (){
                            question = _newQuestion.text;
                            _newQuestion.clear();
                            Navigator.pop(context);
                          })
                      ],
                      ),
                      );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.font_download),
                  tooltip: 'Edit Answer',
                  onPressed: (){
                    showDialog<String> (context: context, 
                      child: new AlertDialog(
                        contentPadding: const EdgeInsets.all(16),
                        
                        content: new Row(children: <Widget> [
                          new Expanded (
                            child: new TextField (
                              controller: _newAnswer,
                              decoration: new InputDecoration(
                              labelText: 'Enter New Answer',)
                            ),
                            )
                        ],
                        ),
                      
                      actions: <Widget> [
                        new FlatButton (
                          child: const Text('CANCEL'),
                          onPressed:() {
                            _newAnswer.clear();
                            Navigator.pop(context);
                          }
                        ),
                        new FlatButton(
                          child:const Text('ENTER'),
                          onPressed: (){
                            answer = _newAnswer.text;
                            _newAnswer.clear();
                            Navigator.pop(context);
                          })
                      ],
                      ),
                      );
                  },
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildRow(String question, String answer) {
    final bool alreadySaved = _saved.contains(question);
    return new ListTile(
      title: new Text(
        '$question',
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.check_box : Icons.check_box_outline_blank,
        color: alreadySaved ? Colors.blue : null,
      ),
      onLongPress: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(question);
          } else {
            _saved.add(question);
          }
        });
      },
      onTap: () {
        _buildAnswer(answer, question);
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      // new page
      new MaterialPageRoute<void>(
        // create material
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
            (String question) {
              return new ListTile(
                title: new Text(
                  question.toString(), // print question
                  style: _biggerFont,
                ),
              );
            },
          );
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();
          return new Scaffold(
            appBar: new AppBar(
              title: const Text('Saved Questions'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }
}
