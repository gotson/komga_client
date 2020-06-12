import 'dart:convert';

import 'package:komgaclient/models/serverdetails.dart';
import 'package:komgaclient/screens/newserverentry.dart';
import 'package:flutter/material.dart';
import 'package:komgaclient/screens/serverhome.dart';
import 'screens/settings.dart';
import 'package:komgaclient/util/db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(KomgaClient());
}

class KomgaClient extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Komga Client',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: "Komga Client"),
      routes: {
        '/settings': (context) => KomgaSettings(),
        '/newserver': (context) => NewServerEntryScreen(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final db = DB.instance;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Komga Client"),
      ),
      body: FutureBuilder(
        future: db.getServers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ServerDetails> servers = snapshot.data;
            return ListView.builder(
                itemCount: servers.length,
                itemBuilder: (BuildContext context, int i) {
                  return ServerCard(servers[i]);
                });
          } else {
            return Center(
              child: Text("Use the button to add a server"),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, '/newserver'),
      ),
    );
  }
}

class ServerCard extends StatelessWidget {
  final ServerDetails _sd;

  ServerCard(this._sd);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(3.0),
      child: Material(
        child: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ServerHome(sd: _sd)));
          },
          child: Card(
            child: ListTile(
              title: Text(_sd.url),
              subtitle: Text(_sd.user),
          )),
        ),
      ),
    );
  }
}
