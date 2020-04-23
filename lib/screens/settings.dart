import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences_settings/shared_preferences_settings.dart';

class KomgaSettings extends StatefulWidget {
  @override
  _KomgaSettingsState createState() => _KomgaSettingsState();
}

class _KomgaSettingsState extends State<KomgaSettings> {
  final storage = new FlutterSecureStorage();
  Map<String, String> secItems;
  Future<Null> _readStorage() async {
    secItems = await storage.readAll();
  }
  //String existingUsername = async () await storage.read(key: 'username');

  Widget build(BuildContext context) {
    // TODO: implement build
    _readStorage();
    return Scaffold(
      appBar: AppBar(
        title: Text('Server Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Server Address'),
            subtitle: TextField(
              decoration: InputDecoration(
                //border: OutlineInputBorder(),
                hintText: "Enter your server address here",
              ),
              onSubmitted: (String value) async => await storage.write(
                  key: 'serverAddress',
                  value: value
              ),
            ),
          ),
          ListTile(
            title: Text('Username'),
            subtitle: TextField(
              decoration: InputDecoration(
                //border: OutlineInputBorder(),
                hintText: "Enter your username here",
              ),
              onSubmitted: (String value) async => await storage.write(
                  key: 'userName',
                  value: value
              ),
            ),
          ),
          ListTile(
            title: Text('Password'),
            subtitle: TextField(
              decoration: InputDecoration(
                //border: OutlineInputBorder(),
                hintText: "Enter your password here",
              ),
              obscureText: true,
              controller: TextEditingController(
                text: secItems ??  ""
              ),
              onSubmitted: (String value) async => await storage.write(
                  key: 'password',
                  value: value
              ),
            ),
          ),
        ],
      ),

    );
//    return SettingsScreen(
//      title: 'Server Settings',
//      children: [
//        TextFieldModalSettingsTile(
//          settingKey: 'server-address',
//          title: 'Server Address',
//          cancelCaption: 'Cancel',
//          okCaption: 'Save Address',
//          keyboardType: TextInputType.url,
//        ),
//        TextFieldModalSettingsTile(
//          settingKey: 'username',
//          title: 'Username',
//          cancelCaption: 'Cancel',
//          okCaption: 'Save Username',
//          keyboardType: TextInputType.emailAddress,
//        ),
//        TextFieldModalSettingsTile(
//          settingKey: 'password',
//          title: 'Password',
//          cancelCaption: 'Cancel',
//          okCaption: 'Save Password',
//          obscureText: true,
//        ),
//      ],
//
//    );
  }
}