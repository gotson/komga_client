import 'dart:convert';

class ServerDetails {
  final String url;
  final String user;
  final String pass;
  final Map<String, String> headers;

  ServerDetails(this.url, this.user, this.pass):
  headers = {
    "authorization" : 'Basic ' + base64Encode(utf8.encode("$user:$pass"))
  };

  Map<String, String> toJson() => {
    "url" : url,
    "user" : user,
    "pass" : pass
  };
}