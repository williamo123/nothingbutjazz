import 'package:flutter/material.dart';
import 'package:nothingbutjazz/pages/search_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Nothing But Jazz',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          scaffoldBackgroundColor: Color.fromARGB(255, 75, 0, 130),
        ),
        initialRoute: 'home',
        routes: {
          'home': (context) => MyHomePage(),
          'searchpage': (context) => SearchPage(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text('Nothing But Jazz'),
        ),
        body: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(10),
          children: [
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, 'searchpage');
              },
              child: Card(
                shadowColor: Colors.yellow,
                elevation: 20,
                child: GridTile(
                    child: Image.asset('assets/images/search.png'),
                    footer: GridTileBar(
                      title: Text(
                        'Search',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
            )
          ],
        ));
  }
}
