import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_sqflite/model/note.dart';
import 'package:todo_sqflite/screens/note_detail.dart';
import 'package:todo_sqflite/utils/database_helper.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note>? noteList;
  int count = 0;
  
  @override
  Widget build(BuildContext context) {
    if(noteList == null){
      noteList = <Note>[];
      updateListView()  ;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo list"),
      ),

      body: ListView.builder(
        itemCount: count,
        itemBuilder: (context, position){
          
          return Card(
            color: Colors.white,
            elevation: 2,
            child: ListTile(
          
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(noteList![position].priority!),
              child: getPriortyIcon(noteList![position].priority!),
            ),

            title: Text(noteList![position].title!, style: TextStyle(fontSize: 24),),

            subtitle: Text(noteList![position].description!, style: TextStyle(fontSize: 16),),

            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.grey,),
              onTap: () {
                _delete(context, noteList![position]);
              },
              ),

            onTap: () {
              moveToDetailScreen(this.noteList![position] ,"Edit Task");
            },
          ),
        );
      }),

      
      

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          moveToDetailScreen(Note('', '', 2),"Create task");
        },

        tooltip: "Add note",

        child: Icon(Icons.add),
      ),
    );
  }

  // return priorty color
  Color getPriorityColor(int priority){
    switch(priority){
      case 1:
        return Colors.red;
      case 2: 
        return Colors.yellow;

      default:
        return Colors.red;
    }
  }

  // return priorty Icon
  Icon getPriortyIcon(int priority){
    switch(priority){
      case 1:
        return Icon(Icons.play_arrow);
      case 2:
        return Icon(Icons.keyboard_arrow_right);
      default:
        return Icon(Icons.play_arrow);
    }
  }

  // delete task
  void _delete(BuildContext context, Note note) async {
    int? result = await databaseHelper.deleteNote(note.id!);
    if(result !=0){
      _showSnackbar(context, "Note deleted Successflully");
      updateListView();
    }
  }

  void _showSnackbar(BuildContext context,String message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void moveToDetailScreen(Note note, String _appBarTitle) async{
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return NoteDetail( note: note,appBarTitle: _appBarTitle);
    }));

    if(result){
      updateListView();
    }
  }

  // apdate List view
  void updateListView(){
    final Future<Database> dbFuture = databaseHelper.initializeDataBase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    } 

    );
  }
}