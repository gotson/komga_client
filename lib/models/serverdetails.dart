import 'dart:convert';

class ServerDetails {
  String url;
  String user;
  String pass;
  Map<String, String> headers;

  ServerDetails(this.url, this.user, this.pass):
  headers = {
    "authorization" : 'Basic ' + base64Encode(utf8.encode("$user:$pass"))
  };

  ServerDetails.fromJson(Map<String, dynamic> _json){
    url = _json["url"];
    user = _json["user"];
    pass = _json["pass"];
    headers = {
      "authorization" : 'Basic ' + base64Encode(utf8.encode("$user:$pass"))
    };
  }

  Map<String, String> toJson() => {
    "url" : url,
    "user" : user,
    "pass" : pass
  };

}