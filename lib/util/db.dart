import 'package:sqflite/sqflite.dart';
import 'package:komgaclient/models/serverdetails.dart';

class DB {

  static final String _name = "komga.db";
  static int version = 1;

  DB._();
  static final DB instance = DB._();

  static Database _db;
  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await _initDatabase();
    return _db;
  }

  _initDatabase() async {
    String _path = await getDatabasesPath() + _name;
    return await openDatabase(
      _path,
      version: version,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async =>
      await db.execute('CREATE TABLE servers (id integer PRIMARY KEY not NULL, url STRING, user STRING, pass STRING)');

  Future<void> insertNewServer(ServerDetails _sd) async {
    Database _db = await instance.db;
    await _db.insert('servers', _sd.toJson());
  }

  Future<List<ServerDetails>> getServers() async {
    Database _db = await instance.db;
    List<ServerDetails> sdl = [];
    List<Map<String, dynamic>> _sdlm = await _db.query('servers',
    columns: ["url","user","pass"],
    );
    for (var s in _sdlm){
      ServerDetails servd = ServerDetails.fromJson(s);
      sdl.add(servd);
    }
    return sdl;
  }
}