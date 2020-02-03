import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWordsState extends State<RandomWords>{
  final List<WordPair> suggestions = <WordPair>[];
  final Set<WordPair> saved = Set<WordPair>();
  final bigFont = const TextStyle(fontSize: 18.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.arrow_forward), onPressed: pushSaved,)
        ],
      ),
      body: buildsuggestions(),
    );
  }
  Widget buildsuggestions(){
    return ListView.builder(padding: const EdgeInsets.all(16.0),
    itemBuilder: (context,i){
      if(i.isOdd){
        return Divider();
      }
      final index = i~/2;
      if(index>=suggestions.length){
        suggestions.addAll(generateWordPairs().take(10));
      }
      return buildRow(suggestions[index]);
    });
  }
  Widget buildRow(WordPair pair){
    final bool alreadySaved = saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: bigFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red:null,
      ),
      onTap: (){
        setState(() {
          if(alreadySaved){
            saved.remove(pair);
          }else{
            saved.add(pair);
          }
        });
      },
    );
  }
  
  void pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context){
          final Iterable<ListTile> tiles = saved.map(
              (WordPair pair){
                return ListTile(
                  title: Text(
                    pair.asPascalCase,
                    style: bigFont,
                  ),
                );
              }
          );
          final List<Widget> divided = ListTile.divideTiles(
              context: context,
              tiles: tiles).toList();
          return Scaffold(         // Add 6 lines from here...
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        }
      )
    );

  }

}

class RandomWords extends StatefulWidget{
  @override
  RandomWordsState createState() => RandomWordsState();
}