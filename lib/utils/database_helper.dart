import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_sqflite/model/note.dart';


class DatabaseHelper{
  
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriorty = 'priority';
  String colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper(){
    
    _databaseHelper ??= DatabaseHelper._createInstance();
    
    return _databaseHelper!;
  }

  Future<Database?> get database async{
    
    _database ??= await initializeDataBase();

      return _database;
    }
  

  Future<Database> initializeDataBase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    var notesDatabase  = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT,'
    '$colDescription TEXT, $colPriorty INTEGER, $colDate TEXT)');
  }

  // Fetch Operation
  Future<List<Map<String, dynamic>>?> getNoteMapList()async {
    Database? db = await this.database;

    var result = await db?.query(noteTable, orderBy: '$colPriorty ASC');
    return result;
  }

  // insert operation
  Future<int?> insertNote(Note note) async {
    Database? db = await this.database;
    var result = await db?.insert(noteTable, note.toMap());
    return result;
  }
  
  // update operation
  Future<int?> update(Note note) async {
    Database? db = await this.database;
    var result = await db?.update(noteTable,note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  // delete operation
  Future<int?> deleteNote(int id)async {
    Database? db = await this.database;
    var result = await db?.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }

  // count Note object
  Future<int?> getCount()async{
    Database? db = await this.database;
    List<Map<String, dynamic>> x = await db!.rawQuery('SELECT COUNT (*) FROM $noteTable');
    int? result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get th map list and convert them Note list
  Future <List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList();
    int count = noteMapList!.length;

    List<Note> noteList =[];

    for(int i = 0; i < count; i++){
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }

    return noteList;
  } 
}