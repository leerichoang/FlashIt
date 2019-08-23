import 'package:flutter/material.dart';


class HelpScreen extends StatelessWidget {
  TextEditingController _name = new TextEditingController(); 
  String filename; 
  Brightness brightness;
  final TextStyle _biggerFont = const TextStyle(fontSize: 20.0);
  List<String> _questions = ["Q: How do i create a deck?",
                            "Q:  How do I get rid of old flash cards?", 
                            "Q:  How do I add a flash card to an existing deck?",
                            "Q:  How do I test myself?"
                            ];
  
  List<String> _answers = ["A:  First, press \"Create New Deck\" from the main menu.  Then, type a name for the deck.  Then, enter the first flash card!",
                          "A: Press \"Manage Flashcards\".  Then, select the deck you wish to delete. Next, press the delete icon.",
                          "A:  Press \"Manage Flashcards\".  Select the deck you wish to add to, then press the plus icon to add new cards to the selected deck.",
                          "A: Press the \"Test Flashcards\" button.  Then, select the deck you wish to review.  All cards in that deck will then appear, and you can confirm that you passed or failed each card."
                          ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs'),
        backgroundColor: Colors.blue,
      ),
      body: _buildFAQ(context)
    );

  
  }

  Widget _buildFAQ(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (BuildContext _context, int i) {
        if (i != _questions.length) {
           return _buildRow(_questions[i], _answers[i], context);
        }
      },
      itemCount: _questions.length,
    );
  }

  Widget _buildRow(String question, String answer, BuildContext context) {
    return new ListTile(
      title: new Text(
        '$question',
        style: _biggerFont,
      ),
      onTap: () {
        _showAnswer(answer, context);
      },
    );
  }

  void _showAnswer(String answer,BuildContext context) {
    if (answer.isEmpty) return;

    AlertDialog dialog = new AlertDialog(
      content: new Text(answer,
      ),
    );

    showDialog(context: context, child: dialog);
  }

 
}