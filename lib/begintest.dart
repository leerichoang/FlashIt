import 'package:flutter/material.dart';
import 'textstorage.dart';
import 'testview.dart';
//import 'package:url_launcher/url_launcher.dart';

// Self test on this page
// Receive results on this page

class BeginTest extends StatefulWidget {
  final List<String> deck;
  final String filename;

  // Constructor that receives a list of strings(the deck) and the name of the deck
  BeginTest({Key key, @required this.deck, @required this.filename})
      : super(key: key);

  @override
  _BeginTest createState() => new _BeginTest();
}

class _BeginTest extends State<BeginTest> {
  int n = 0;
  int size = 0;
  int result = 0;
  String filename;
  bool isCorrect = false;
  TextEditingController input = new TextEditingController();

  // List to store questions and answers separately
  List<String> questions = [];
  List<String> answers = [];
  //List<String> rewr = ["O", "O"];

  // InitState sorts separates
  void initState() {
    super.initState();
    for (int i = 0; i < widget.deck.length - 1; i++) {
      print('${widget.deck[i]}\n');
      if (i % 2 == 0) {
        questions.add(widget.deck[i]);
        size++;
      } else {
        answers.add(widget.deck[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Math'),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Calls a Card widget that passes the
            prompts(),
            Padding(
              padding: EdgeInsets.only(),
              child: RaisedButton(
                  child: Text(
                    'Exit Quiz',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    // If user would like to exit self test
                    exitButton();
                  }),
            ),
          ],
        ),
      ),
    );
  }

  /*
  if (n == size - 1) {
                      result++;
                      results();
                      print('display results');
                    }
                    else{
                      nextButton();
                      print('next question');
                    }
  */

  compareAnswer() {
    print('Show dialog revealing answer');
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            content: Text('Answer:  ${answers[n]}\nYou input: ${input.text}'),
            actions: <Widget>[
              new FlatButton(
                  child: new Text("Ok"),
                  onPressed: () {
                    if (isCorrect) {
                      Navigator.pop(context);
                      if (n == size - 1) {
                        Text("nice");
                        result++;
                        //rewr[n] = "O";
                        results();
                        print('display results');
                      } else {
                        //rewr[n] = "O";
                        nextButton();
                        print('correct, next question');
                      }
                    } else {
                      Navigator.pop(context);
                      if (n == size - 1) {
                        //rewr[n] = "X";
                        results();
                      } else {
                        //rewr[n] = "X";
                        print('incorrect answer');
                        setState(() {
                          n += 1;
                        });
                      }
                    }
                  }),
            ]);
      },
    );
  }

  // To go back to the select deck screen
  exitButton() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            content: Text('Are you sure you want to leave?'),
            actions: <Widget>[
              new FlatButton(
                  child: new Text("Yes"),
                  onPressed: () {
                    //save here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TestCards(storage: TextStorage())),
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
  }

  // Function call for revealing answer dialog
  answerButton() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            content: Text('Answer: ${answers[n]}'),
            actions: <Widget>[
              new FlatButton(
                  child: new Text("Got it!"),
                  onPressed: () {
                    if (n == size - 1) {
                      results();
                    } else {
                      setState(() {
                        n += 1;
                      });
                    }
                    Navigator.pop(context);
                  }),
            ]);
      },
    );
  }

  // Function call for pressing next question
  nextButton() {
    setState(() {
      n += 1;
      result += 1;
    });
    prompts();
  }

  // Generates "flashcard" structure
  prompts() {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new ListTile(title: Text("Question:  ${n + 1}")),
          new ListTile(
            title: Text('${questions[n]}'),
            //subtitle: Text('whats your answer?'),
          ),
          new Divider(color: Colors.blue, indent: 1.0),
          TextFormField(
            decoration: InputDecoration(labelText: "Enter your answer"),
            controller: input,
          ),
          ButtonTheme.bar(
            // make buttons use the appropriate styles for cards
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  child: Icon(Icons.lightbulb_outline),
                  onPressed: () {
                    answerButton();
                  },
                ),
                FlatButton(
                  child: Icon(Icons.check),
                  onPressed: () {
                    String ans = input.text + '\0';
                    print('${ans.length} = ${answers[n].length}');
                    if (ans.length == answers[n].length) {
                      setState(() {
                        isCorrect = true;
                      });
                      print('User input correct answer');
                    }
                    else{
                      setState(() {
                        isCorrect = false;                        
                      });
                      print('User input INCORRECT answer');
                    }
                    compareAnswer();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  results() {
    double percentage = (result / (size)) * 100;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            content: new Text("Score:"
                "${percentage.toStringAsFixed(2)}%!\n"
                "$result correct out of $size\n"
                //"1 2 3 4\n"
                //"${rewr[0]}, ${rewr[1]}, ${rewr[2]}, ${rewr[3]}"),
            ),
            actions: <Widget>[
              new FlatButton(
                  child: new Text("Thanks!"),
                  onPressed: () {
                    //save here
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }),
            ]);
      },
    );
  }
}
