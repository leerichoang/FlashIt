import 'package:flutter/material.dart';
import 'viewcard.dart';
import 'textstorage.dart';
import 'dart:async';
import 'dart:io';
import 'viewdeck.dart';
import 'homescreen.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

class AddCard extends StatefulWidget {
  final TextStorage storage;
  final String filename; 
  AddCard({Key key, @required this.storage, this.filename}) : super(key: key);

  @override
  _AddCardState createState() => _AddCardState();
  
}

class _SystemPadding extends StatelessWidget {
  final Widget child;
  _SystemPadding({Key key, this.child }) : super(key: key);

  @override
  Widget build (BuildContext context){
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(padding: mediaQuery.viewInsets,
    duration: const Duration(milliseconds: 300),
    child:child);
  }
}

class _AddCardState extends State<AddCard> {
  TextEditingController _questionField = new TextEditingController();
  TextEditingController _answerField = new TextEditingController();
  String _content = '';
  int n = -1;
  List<String> _question = new List();
  List<String> _answer = new List();

  addQuestion(String text){
    _question.add(text); 
  }

  addAnswer(String text){
    _answer.add(text);
    n++;
  }

  clearArray(){
    _question.clear();
    _answer.clear();
    n = -1;
  }

  @override
  void initState() {
    super.initState();
    widget.storage.readDeck(widget.filename).then((String text) {
      setState(() {
        _content = text;
      });
    });
  }

 _showDialog() async{
   await showDialog<String>(
    context: context,
    child : new _SystemPadding (child: new AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: new Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              controller: _answerField,
              decoration: new InputDecoration(
                labelText: 'Enter Answer',),
              ),
              )
        ],
        ),
        actions: <Widget> [
          new FlatButton (
            child: const Text('CANCEL'),
            onPressed: () {
              _answerField.clear(); 
              Navigator.pop(context);
            }
          ),
          new FlatButton(
            child: const Text('SAVE'),
            onPressed: () {
              //_writeStringToTextFile(_questionField.text);
              addQuestion(_questionField.text);
              addAnswer(_answerField.text);
             // _writeStringToTextFile(_answerField.text); 
             _writeStringToTextFile(_question[n], widget.filename);
              return showDialog(
                context: context,
                   builder: (context) {
                    return AlertDialog(
                      content: new Text(
                        "Successfully saved!"),
                          actions: <Widget>[
                            new FlatButton(
                                child: new Text("OK"),
                                onPressed: () {
                                  _writeStringToTextFile(_answerField.text, widget.filename); 
                                  _questionField.clear();
                                  _answerField.clear();
                                   Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>HomeScreen()),
                                  );  
                                 // Navigator.push(context,
                                 //   MaterialPageRoute(builder: (context) => ViewCard(storage: TextStorage(), filename:widget.filename)),
                                 // );
                                },
                            ),
                          ]
                    );
                   }
              );
            }
            )
        ],
        ),
        ),
   );
 }


  Future<File> _writeStringToTextFile(String text, String deckname) async {
    setState(() {
      _content += text;
    });
    return widget.storage.writeDeck(text,deckname);
  }
  
  Future<File> _clearContentsInTextFile() async {
    setState(() {
      _content = '';
    });
    return widget.storage.cleanFile();
  }

  Future <bool>_onWillPop() async {      
    Navigator.pop(context);
    Navigator.pop(context);
      return true;
  }

  @override
  Widget build(BuildContext context) {
    //int count = 0;
    String current;
    return new WillPopScope(
    child: new Scaffold(
      appBar: AppBar(
        title: Text('Create Flashcard'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: <Widget>[
            Text('Question: '),
            TextField(
              controller: _questionField,
            ),
            // TextField(
            //   controller: _answerField,
            // ),
            // Text('Answer'),
            Padding ( 
              padding: EdgeInsets.all(20.0),
              child: RaisedButton(
                child:Text('Enter Answer',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blueAccent,
              onPressed: _showDialog,
              ),
              ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: RaisedButton(
                child: Text(
                  'Clear Contents',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.redAccent,
                onPressed: () {
                  clearArray();
                  //_clearContentsInTextFile();
                },
              ),
            ),
            // Expanded(                                                        //TESTING INPUT
            //   flex: 1,
            //   child: new SingleChildScrollView(
            //     child: Text(
            //       //'${_question[n]}',
            //       '$_question' + '  '+ '$_answer',
            //       //'$_content',
            //       style: TextStyle(
            //         color: Colors.black,
            //         fontSize: 22.0,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    bottomNavigationBar: new BottomAppBar(
      color: Colors.blue,
      child: new Row(
        mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            //bottom app functionality here
            
            IconButton(
              icon: Icon(Icons.save), //save the current card
              tooltip: 'Save Flashcard',
              onPressed: () {
                return showDialog(
                context: context,
                   builder: (context) {
                    return AlertDialog(
                      content: new Text(
                        "Would you like to save this flashcard?"),
                          actions: <Widget>[
                            new FlatButton(
                                child: new Text("Yes"),
                                onPressed: () {
                                  // if (_questionField.text.isNotEmpty && _answerField.text.isNotEmpty) {
                                  //   addQuestion(_questionField.text);
                                  //   _writeStringToTextFile(_questionField.text);
                                  //   addAnswer(_answerField.text);
                                  
                                  // }
                                  Navigator.pop(context);
                                return showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: new Text(
                                        "Successfully added flashcard!"),
                                        actions: <Widget>[
                                      new FlatButton(
                                      child: new Text("OK"),
                                onPressed: () {
                                  //save here
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  
                                }),
                                ]);
                              },
                             );
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
                icon: Icon(
                    Icons.delete_outline), //delete current card in progress
                tooltip: 'Delete current Flashcard',
                onPressed: () {
                  return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          content: new Text(
                              "Are you sure you would like to delete this flashcard?"),
                          actions: <Widget>[
                            new FlatButton(
                                child: new Text("Yes"),
                                onPressed: () {
                                  //save here
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
                icon: Icon(Icons.home), //return home
                tooltip: 'Home',
                onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    
                }
              ),
            ],
          )),
    )
    );
  }
}
