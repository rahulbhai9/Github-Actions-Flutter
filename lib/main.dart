// pm v1test
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Poeam> fetchPoeam({required String poeamPath}) async {
  final response = await http
      .get(Uri.parse('https://poetrydb.org/${poeamPath}'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Poeam.fromJson(jsonDecode(response.body)[0]);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load poeam');
  }
}

class Poeam {
  final String title;

  final String author;
  final List lines;
  Poeam({
    required this.title,

    required this.author,

    required this.lines,
  });

  factory Poeam.fromJson(Map<String, dynamic> json) {
    return Poeam(
      title: json['title'],
      author: json['author'],
      lines: json['lines'],
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
debugShowCheckedModeBanner:false,
      title: 'Pohub',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Pohub'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
ElevatedButton(
          child: Text('Browse all authors'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AuthorList()),
            );
          },
        ),
PoeamPage(poeamPath:"random"),

          ],
        ),
      ),

    );
  }
}
class PoeamPage extends StatefulWidget {
final String poeamPath;
   PoeamPage({required poeamPath,}) : super();

  @override
  _ PoeamPageState createState() => _ PoeamPageState();
}

class _ PoeamPageState extends State<PoeamPage> {
late   Future<Poeam> futurePoeam;

  @override
  void initState() {
    super.initState();
    futurePoeam = fetchPoeam(poeamPath:Widget.poeamPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Poeam'),
        ),
        body: Center(
          child: FutureBuilder<Poeam>(
            future: futurePoeam,
            builder: (context, snapshot) {
          List<Widget> children;

    if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
          List poeamLines = snapshot.data!.lines.map <List<Widget>>((line) => Text(line)).toList();
            children = <Widget>[

Text("Title: ${snapshot.data!.title}"),
Text("Author: ${snapshot.data!.author}"),
...? poeamLines,
ElevatedButton(
          child: const Text('More by ${snapshot.data.!author}'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PoeamList()),
            );
          },
        ),
            ];
              } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
              } else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting poeam...'),
              )
            ];
          }

} else{
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('waiting'),
              )
            ];
              }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
            },
          ),
        ),
    );
  }
}
class PoeamList extends StatelessWidget {
  PoeamList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Poeams by'),
      ),
      body: Center(
        child: Text("List of Poeams"),
      ),
    );
  }
}
class AuthorList extends StatelessWidget {
  AuthorList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Author'),
      ),
      body: Center(
        child: Text("List of authors"),
      ),
    );
  }
}
