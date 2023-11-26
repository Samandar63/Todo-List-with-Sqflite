import 'package:flutter/material.dart';
import 'package:todo_sqflite/model/note.dart';
import 'package:todo_sqflite/utils/database_helper.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail({super.key, required this.note, required this.appBarTitle});

  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  
  DatabaseHelper helper = DatabaseHelper();
  static var _priorities = ['High', "Low"];
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController= TextEditingController();

  
  @override

  Widget build(BuildContext context) {

    titleController.text = widget.note.title!;
    subtitleController.text = widget.note.description!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),

      body: Padding(
        padding: EdgeInsets.only(top: 15, right: 10, left: 10),
        child: ListView(
          children: [

            // first element
            ListTile(
              title: DropdownButton(
                items: _priorities.map((String dropDownStringItem){
                return DropdownMenuItem(
                  value: dropDownStringItem,
                  child: Text('$dropDownStringItem'));
              }).toList(), 
                
                value: getPriorityAsString(widget.note.priority!),

                onChanged: (selectedByUser){
                  setState(() {
                    debugPrint("User Selected: $selectedByUser");
                    updatePriorityAsInt(selectedByUser!);
                  });
                },
              )
            ),

            // second element
            Padding(
              padding: EdgeInsets.only(bottom: 15, top: 15),
              child: TextField(

                controller: titleController,
                onChanged: (value) {
                  updateTitle();
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: "title"
                  )
                ),
              ),
      
            // third element
            Padding(
              padding: EdgeInsets.only(bottom: 15, top: 15),
              child: TextField(
                
                controller:subtitleController,
                onChanged: (value) {
                  updateDiscreption();
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: "Description"
                  )
                ),
              ),

            // fourth element
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: [
                  Expanded(child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple
                    ),
                    onPressed: (){
                      _saveData();
                    }, 
                    child: Text("Save", textScaleFactor: 1.5,))),

                    SizedBox(width: 10,),

                    Expanded(child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple
                    ),
                    onPressed: (){
                      _delete();
                    }, 
                    child: Text("delete", textScaleFactor: 1.5,)))
                ],
              ),
              )  
          ],
        ),
      ),
    );
  }

  void updatePriorityAsInt(String value){
    switch(value){
      
      case "High":
        widget.note.priority = 1;
        break;
      
      case "Low":
        widget.note.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int value){
    String priority;
    switch(value){
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
      default :
        priority = _priorities[0];
    }
      
      return priority;
  }

  // update Title
  void updateTitle(){
    widget.note.title = titleController.text;
  }

  // update discreption
  void updateDiscreption(){
    widget.note.description = subtitleController.text;
  }

  // delete data
  void _delete()async{

    Navigator.pop(context, true);

    if(widget.note.id == null){
      _showAlertDialog("Status", "No Note was deleted");
      return;
    }

    int? result = await helper.deleteNote(widget.note.id!);

  if(result != 0){
    _showAlertDialog("Status", "Note Deleted Successfully");
  }else{
    _showAlertDialog("Status", "Error Occured while Deleting note");
  }
  }

  // save data

  void _saveData() async {

    Navigator.pop(context, true);
    
    widget.note.date = DateTime.now().toString();

    int? result;
    if(widget.note.id != null){
       result = await helper.update(widget.note);
    }
    else{
       result = await helper.insertNote(widget.note);
    }

    if(result != 0){
      _showAlertDialog("Status", "Note saved successfully");
    }else{
      _showAlertDialog("Status", "Problem saving note");
    }
  }
  
  void _showAlertDialog(String title, String message){
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );

    showDialog(
      context: context, 
      builder: (_) => alertDialog);
  }
}