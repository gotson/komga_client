import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


Future<bool> serverWorking() async {
  final SharedPreferences _prefs = await SharedPreferences.getInstance();
  String _address = _prefs.getString('address');
  String _pass = _prefs.getString('pass');
  String _user = _prefs.getString('user');

  String _basicAuth = 'Basic ' + base64Encode(utf8.encode('$_user:$_pass'));

  String _url = "$_address/api/v1/libraries";

  Map<String, String> _headers = {
    'content-type': 'application/json',
    'accept': 'application/json',
    'authorization': _basicAuth
  };

  var r = await http.get(_url, headers: _headers);
  print(r.body);
  return r.statusCode == 200;
}
