// pm v1test
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
Future<Poeam> fetchPoeam({required String poeamPath}) async {
  final response = await http.get(Uri.parse(Uri.encodeFull('https://poetrydb.org/$poeamPath')));
  if (response.statusCode == 200) {
    return Poeam.fromJson(jsonDecode(response.body)[0]);
  } else {
    throw Exception('Failed to load poeam');
  }
}
Future<List<String>> fetchAuthors() async {
  final response = await http.get(Uri.parse('https://poetrydb.org/author'));
  if (response.statusCode == 200) {
Map<String, dynamic> data = jsonDecode(response.body);
return List<String>.from(data['authors']);
  } else {
    throw Exception('Failed to load authors');
  }
}
Future<List<Poeam>> fetchPoeamsByAuthor({required String authorName}) async {
  final response = await http.get(Uri.parse(Uri.encodeFull('https://poetrydb.org/author/$authorName')));

  if (response.statusCode == 200) {
List<Poeam> poeams = [];
final data = jsonDecode(response.body);
poeams = data.map<Poeam>((m)=>Poeam.fromJson(Map<String, dynamic>.from(m))).toList();

return poeams;
  } else {
    throw Exception('Failed to load poeams');
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
  final String title;
  MyHomePage({Key? key, required this.title}) : super(key: key);



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
              MaterialPageRoute(builder: (context) => AllAuthorsPage()),
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
   PoeamPage({required this.poeamPath,}) : super();

  @override
  _PoeamPageState createState() => _PoeamPageState();
}

class _PoeamPageState extends State<PoeamPage> {
late final Future<Poeam> futurePoeam;
  @override
  void initState() {
    super.initState();
    futurePoeam = fetchPoeam(poeamPath: widget.poeamPath);
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
          List<Widget> poeamLines = [];
for(int l=0;l<snapshot.data!.lines.length;l++){
poeamLines.add(Text(snapshot.data!.lines[l]));
}
            children = <Widget>[

Text("Title: ${snapshot.data!.title}"),
Text("Author: ${snapshot.data!.author}"),
...poeamLines,
ElevatedButton(
          child: Text('More by ${snapshot.data!.author}'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PoeamsByAuthorPage(authorName:snapshot.data!.author)),
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
            children = <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting poeam...'),
              ),
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

          return Expanded(
            child: SingleChildScrollView(
        child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          ),
);
            },
          ),
        ),
    );
  }
}
class AllAuthorsPage extends StatefulWidget {
   AllAuthorsPage() : super();

  @override
  _AllAuthorsPageState createState() => _AllAuthorsPageState();
}

class _AllAuthorsPageState extends State<AllAuthorsPage> {
late final Future<List<String>> futureAllAuthors;
  @override
  void initState() {
    super.initState();
    futureAllAuthors = fetchAuthors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('All authors'),
        ),
        body: Center(
          child: FutureBuilder<List<String>>(
            future: futureAllAuthors,
            builder: (context, snapshot) {
          List<Widget> children;

    if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
//add listbulder
            children = <Widget>[
ListView.builder(
  itemCount: snapshot.data!.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(snapshot.data![index]),
onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PoeamsByAuthorPage(authorName: snapshot.data![index])),
            );
},
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
            children = <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting authors...'),
              ),
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
                child: Text('loading...'),
              )
            ];
              }

          return Expanded(
            child: SingleChildScrollView(
        child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          ),
);
            },
          ),
        ),
    );
  }
}
class PoeamsByAuthorPage extends StatefulWidget {

final String authorName;
   PoeamsByAuthorPage({required this.authorName}) : super();

  @override
  _PoeamsByAuthorPageState createState() => _PoeamsByAuthorPageState();
}

class _PoeamsByAuthorPageState extends State<PoeamsByAuthorPage> {
late final Future<List<Poeam>> futureAllPoeams;
  @override
  void initState() {
    super.initState();
    futureAllPoeams = fetchPoeamsByAuthor(authorName: widget.authorName); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Poeams by ${widget.authorName}'),
        ),
        body: Center(
          child: FutureBuilder<List<Poeam>>(
            future: futureAllPoeams,
            builder: (context, snapshot) {
          List<Widget> children;

    if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
//add listbulder
            children = <Widget>[
ListView.builder(
  itemCount: snapshot.data!.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(snapshot.data![index].title),
onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PoeamPage(poeamPath: "title/${snapshot.data![index].title}")),
            );
},
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
            children = <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting poeams...'),
              ),
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
                child: Text('loading...'),
              )
            ];
              }

          return Expanded(
            child: SingleChildScrollView(
        child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          ),
);
            },
          ),
        ),
    );
  }
}
