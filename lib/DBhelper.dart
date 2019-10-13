import 'dart:io';
    import 'package:path/path.dart';
    import 'package:sqflite/sqflite.dart';
    import 'package:path_provider/path_provider.dart';

    // database table and column names
    final String tableWords = 'cards';

    final String columnId = '_id';
    final String columnWord = 'name';
    final String columnvno = 'vno';
    final String columnDate = 'date';
    // data model class
    class Word {

      int id;
      String word;
      String vno;
      String date;
      int c =0;
      Word();

      // convenience constructor to create a Word object
      Word.fromMap(Map<String, dynamic> map) {
        id = map[columnId];
        word = map[columnWord];
        vno = map[columnvno];
        date = map[columnDate];
      }

      // convenience method to create a Map from this Word object
      Map<String, dynamic> toMap() {
        var map = <String, dynamic>{
          columnWord: word,
          columnvno: vno,
          columnDate: date
        };
        if (id != null) {
          map[columnId] = id;
        }
        return map;
      }
    }

    // singleton class to manage the database
    class DatabaseHelper {

      // This is the actual database filename that is saved in the docs directory.
      static final _databaseName = "MyDatabase.db";
      // Increment this version when you need to change the schema.
      static final _databaseVersion = 1;

      // Make this a singleton class.
      DatabaseHelper._privateConstructor();
      static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

      // Only allow a single open connection to the database.
      static Database _database;
      Future<Database> get database async {
        if (_database != null) return _database;
        _database = await _initDatabase();
        return _database;
      }

      // open the database
      _initDatabase() async {
        // The path_provider plugin gets the right directory for Android or iOS.
        Directory documentsDirectory = await getApplicationDocumentsDirectory();
        String path = join(documentsDirectory.path, _databaseName);
        // Open the database. Can also add an onUpdate callback parameter.
        return await openDatabase(path,
            version: _databaseVersion,
            onCreate: _onCreate);
      }

      // SQL string to create the database 
      Future _onCreate(Database db, int version) async {
        await db.execute('''
              CREATE TABLE $tableWords (
                $columnId INTEGER PRIMARY KEY,
                $columnWord TEXT NOT NULL,
                $columnvno TEXT ,
                $columnDate TEXT NOT NULL
              )
              ''');
      }

      // Database helper methods:

      Future<int> insert(Word word) async {
        Database db = await database;
        int id = await db.insert(tableWords, word.toMap());
        return id;
        
      }


       Future<int> update(int id,Word word) async {
        Database db = await database;
        int i = await db.update(tableWords, word.toMap(),
            where: '$columnId = ?',
            whereArgs: [id]
            );
        return i;
        
      }


      
       Future<int> delete(int id) async {
        Database db = await database;
       
        int i = await db.delete(tableWords, 
            where: '$columnId = ?',
            whereArgs: [id]
            );
        return i;
        
      }

      Future<Word> queryWord(int id) async {
        Database db = await database;
        List<Map> maps = await db.query(tableWords,
            columns: [columnId, columnWord, columnvno ,columnDate],
            where: '$columnId = ?',
            whereArgs: [id]);
        if (maps.length > 0) {
        // return maps;
          print(' lengh = ${maps.length}');
          return Word.fromMap(maps.first);
        }
        return null;
      }


      Future<int> getCount() async {
      //database connection
        Database db = await database;
        List<Map> list = await db.rawQuery('SELECT * FROM $tableWords');
        int count = list.length;
        return count;
      }

      // TODO: queryAllWords()
      // TODO: delete(int id)
      // TODO: update(Word word)
    }
