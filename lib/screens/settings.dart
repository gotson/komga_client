import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_validator/string_validator.dart';
import 'package:http/http.dart' as http;
import 'package:komgaclient/util/servertest.dart' as st;

class KomgaSettings extends StatefulWidget {
  @override
  _KomgaSettingsState createState() => _KomgaSettingsState();
}

class _KomgaSettingsState extends State<KomgaSettings> {


  String username;
  String password;
  String address;

  Future<bool> _restoreSettings() async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
      address = _prefs.getString('address') ?? '';
      username = _prefs.getString('user') ?? '';
      password = _prefs.getString('pass') ?? '';
      return true;
  }

  void save(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<bool> _serverWorks;

  void testServer() {
    setState(() {
      _serverWorks = st.serverWorking();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _restoreSettings(),
      builder: (context, snapshot) {
        if (snapshot.hasData){
          return Scaffold(
            appBar: AppBar(
              title: Text('Server Settings'),
            ),
            body: ListView(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.cloud),
                  title: Text('Server Address'),
                  subtitle: TextFormField(
                    initialValue: address,
                    decoration: InputDecoration(
                      hintText: "Enter your server address here",
                        helperText: " " //this stops validation from altering height
                    ),
                    onChanged: (String value)  => save('address', value),
                    validator: (String value) => isURL(value) ? null : "Not a valid URL",
                    autovalidate: true,
                    enableSuggestions: false,
                    keyboardType: TextInputType.url,
                    autocorrect: false,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Username'),
                  subtitle: TextFormField(
                    initialValue: username,
                    decoration: InputDecoration(
                      hintText: "Enter your username here",
                        helperText: " " //this stops validation from altering height
                    ),
                    onChanged: (String value)  => save('user', value),
                    validator: (String value) => isEmail(value) ? null : "Not a valid username",
                    enableSuggestions: false,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.lock),
                  title: Text('Password'),
                  subtitle: TextFormField(
                    initialValue: password,
                    decoration: InputDecoration(
                      //border: OutlineInputBorder(),
                      hintText: "Enter your password here",
                    ),
                    obscureText: true,
                    onChanged: (String value)  => save('pass', value),
                    enableSuggestions: false,
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                  ),
                ),
                ListTile(
                  title: RaisedButton(
                    child: Text("Test server"),
                    onPressed: () => testServer()

                  ),
                  trailing: FutureBuilder(
                    future: _serverWorks,
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                        if (snapshot.data == true){
                           return Icon(Icons.check, color: Colors.lightGreen,);
                          }else{
                           return Icon(Icons.error_outline, color: Colors.red);
                        }
                      }else{
                        return Icon(Icons.remove);
                      }

                  }
                  ),

                ),
              ],
            ),

          );

        } else {
          return CircularProgressIndicator();
        }
      }


    );
  }
}