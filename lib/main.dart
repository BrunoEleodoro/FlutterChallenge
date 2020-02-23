import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:flutter_challenge/globals.dart' as globals;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Name Meaning',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
//        primarySwatch: Colors.orange,
//        primaryTextTheme: Typography(platform: TargetPlatform.android).white,
//        textTheme: Typography(platform: TargetPlatform.android).black,
          brightness: Brightness.dark),
      home: MyHomePage(title: 'Name Meaning'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool l = false;
  String m = "";
  var _controller = TextEditingController();

  a() async {
    setState(() {
      l = true;
    });
    var response = await http
        .get("https://www.behindthename.com/name/" + _controller.text);
    var document = parse(response.body);
    var section = document.querySelectorAll('section');
    l = false;
    m = section.length > 0 ? section[0].text : "Not Found";
    globals.m = m;
    globals.n = _controller.text;

    setState(() {});
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new Visualizar()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _controller,
                  textCapitalization: TextCapitalization.characters,
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Container(
                height: 50,
                child: (l)
                    ? SpinKitThreeBounce(
                        color: Colors.white,
                      )
                    : Text(''),
              ),
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: a,
        child: Icon(Icons.search),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class Visualizar extends StatefulWidget {
  @override
  _VisualizarState createState() => _VisualizarState();
}

class _VisualizarState extends State<Visualizar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(globals.n),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Card(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  globals.m,
                  softWrap: true,
                  textAlign: TextAlign.justify,
                  style: TextStyle(wordSpacing: 10, fontSize: 16, inherit: true),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
