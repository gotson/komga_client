import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:komgaclient/models/serverdetails.dart';
import 'package:string_validator/string_validator.dart';
import 'package:http/http.dart' as http;
import 'package:komgaclient/util/db.dart';


class NewServerEntryScreen extends StatefulWidget {
  @override
  _NewServerEntryScreenState createState() => _NewServerEntryScreenState();
}

class _NewServerEntryScreenState extends State<NewServerEntryScreen>{

  String url;
  String user;
  String pass;
  ServerDetails sd;
  Future<bool> _serverReady;
  final db = DB.instance;
  final _formKey = GlobalKey<FormState>();

  void _submitServer(ServerDetails _sd) async {
    if(await _testServer(_sd)){
      await db.insertNewServer(_sd);
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  Future<bool> _testServer(ServerDetails _sd) async {
    String _testUrl = "${_sd.url}/api/v1/books/latest";
    http.Response r = await http.get(_testUrl, headers: _sd.headers);
    return r.statusCode == 200;
  }

//  void beginTestServer(ServerDetails _sd) {}



 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("Enter a new Komga server"),
     ),
     body: ListView(
       scrollDirection: Axis.vertical,
       children: <Widget>[
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: Container(
             margin: EdgeInsets.symmetric(horizontal: 20.0),
             child: Form(
               key: _formKey,
               child: ListView(
                 shrinkWrap: true,
                 children: <Widget>[
                   ListTile(
                     leading: Icon(Icons.cloud),
                     title: Text("Server Address"),
                     subtitle: TextFormField(
                       decoration: InputDecoration(
                           hintText: "Enter your server address here",
                           helperText: "Don't include the trailing slash at the end",
                       ),
                       validator: (String value) => isURL(value) ? null : "Not a valid URL",
                       enableSuggestions: false,
                       keyboardType: TextInputType.url,
                       autocorrect: false,
                       onSaved: (String value) {url = value;},
                    )
                   ),
                   ListTile(
                     leading: Icon(Icons.person),
                     title: Text("Username"),
                     subtitle: TextFormField(
                       decoration: InputDecoration(
                         hintText: "Enter your username",
                         helperText: " ", //this space stops validation from moving the fields
                       ),
                       validator: (String value) => isEmail(value) ? null : "Komga usernames look like email addresses",
                       enableSuggestions: false,
                       keyboardType: TextInputType.emailAddress,
                       autocorrect: false,
                       onSaved: (String value) {user = value;},
                     ),
                   ),
                   ListTile(
                     leading: Icon(Icons.lock),
                     title: Text("Password"),
                     subtitle: TextFormField(
                       decoration: InputDecoration(
                         hintText: "Enter your password here",
                         helperText: " ",
                       ),
                       obscureText: true,
                       onSaved: (String value) {pass = value;},
                     ),
                   ),
                   Column(
                     children: <Widget>[
                       Container(
                         child: RaisedButton(
                           child: Text("Test Server"),
                           onPressed: () {
                             final form = _formKey.currentState;
                             if (form.validate()){
                               form.save();
                               sd = ServerDetails(url, user, pass);
                               String json = jsonEncode(sd);
                               print(json);
                               setState(() {
                                 _serverReady = _testServer(sd);
                               });
                             }
                           },
                         ),
                       ),
//                     FutureBuilder
                     ],
                   ),
                   Divider(),
                   FutureBuilder(
                     future: _serverReady,
                     builder: (context, snapshot){
                       if (snapshot.hasData){
                         if(snapshot.data == true){
                           return Column(
                             children: <Widget>[
                               Icon(Icons.check, color: Colors.green,),
                               RaisedButton(
                                 child: Text("Save Server"),
                                 onPressed: () => _submitServer(sd),
                               )
                             ],
                           );
                         }else{
                           return Icon(Icons.error_outline, color: Colors.red,);
                         }
                       }else{
                         return Container();
                       }
                     },
                   ),

                 ],
             ),
            ),
           ),
         ),
       ],
     )
   );
 }
}