import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

class TextStorage {
  Future<String> get _qlocalPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _qlocalFile async {
    final path = await _qlocalPath; 
    return File('$path/decks.txt');
  }

  Future<String> readFile() async {
    try {
      final file = await _qlocalFile;

      String content = await file.readAsString();
      return content;
    } catch (e) {
      return '';
    }
  }

  Future<File> writeFile(String text) async {
    final file = await _qlocalFile;
    return file.writeAsString('$text\n', mode: FileMode.append);
  }

  Future<File> cleanFile() async {
    final file = await _qlocalFile;
    return file.writeAsString('');
  }

  Future<File>  fileLocation (String name) async
  {
    final path = await _qlocalPath;
    return File('$path/$name.txt'); 
  }

  Future<String> readDeck(String filename) async {
    try {
      final path = await _qlocalPath;
      var file = new File ('$path/$filename.txt'); 
      String content = await file.readAsString();
      return content;
    } catch (e) {
      return '';
    }
  }

  Future<File> writeDeck(String text, String deckname) async
  {
   final path = await _qlocalPath;
   var file = new File ('$path/$deckname.txt'); 
   return file.writeAsString('$text\r\n', mode: FileMode.append); 
  }

  Future<File> clearDeck(String deckname) async{
    final path = await _qlocalPath;
    var file = new File('$path/$deckname.txt');
    return file.writeAsString('');
  }

} 
