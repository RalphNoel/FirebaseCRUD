import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todolist/Database/database.dart';

class TodoListScreenView extends StatefulWidget {
  const TodoListScreenView({Key? key}) : super(key: key);

  @override
  _TodoListScreenViewState createState() => _TodoListScreenViewState();
}

class _TodoListScreenViewState extends State<TodoListScreenView> {
  var todoController = TextEditingController();
  Database? db;
  List docs = [];
  bool isUpdate = false;

  @override
  Widget build(BuildContext context) {
    initialize();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Todo List'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
        onPressed: () {
          _modalBottomSheetMenu();
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          docs.length > 0
              ? Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return lisofData(index);
                      }),
                )
              : Column(
                  children: [
                    Image.asset(
                      'assets/list.jpg',
                      scale: 5.0,
                    ),
                    Text(
                      'There is No list, Please add the list',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget lisofData(int index) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Card(
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // if you need this
                  side: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                color: Colors.grey[100],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 18,
                        right: 18,
                        top: 18.0,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            child: Text(
                              docs[index]['todoname'][0].toUpperCase(),
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            backgroundColor: Colors.purple,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            docs[index]['todoname'],
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _modalBottomSheetMenu(
                                    index: index, isUpdate: true);
                                //todolist.removeAt(index);
                              });
                            },
                            icon: Icon(
                              Icons.edit,
                            ),
                            color: Colors.grey,
                          ),
                          IconButton(
                            onPressed: () {
                              showAlertDialog(context, index);

                            },
                            icon: Icon(
                              Icons.delete,
                            ),
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Initializing Database
   initialize() {
    db = Database();
    db!.initialise();
    db!.read().then((value) => {
          setState(() {
            if (value != null) {
              docs = value;
            }
          })
        });
  }

  //Showing Alert Dialog
  showAlertDialog(BuildContext context, int index) {
    Widget cancelButton = TextButton(
      child: Text("Yes"),
      onPressed:  () {
        setState(() {
          db!.delete(docs[index]['id']);
          Navigator.of(context).pop();
        });
      },
    );
    Widget continueButton = TextButton(
      child: Text("No"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );


    AlertDialog alert = AlertDialog(
      content: Text("Do you want to delete ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //Showing bottomSheet For adding List
  void _modalBottomSheetMenu({bool? isUpdate, int? index}) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        )),
        builder: (builder) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: new Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 5,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Adding Task',
                    style: TextStyle(fontSize: 17),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: todoController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Todo Name';
                      }
                      return null;
                    },
                    onChanged: (v) {},
                    autofocus: false,
                    style: TextStyle(fontSize: 15.0, color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      counter: new SizedBox(height: 0.0),
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.all(14.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.7)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.7), width: 1.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.7)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.withOpacity(0.7)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (isUpdate == true) {
                              db!.update(
                                  docs[index!]['id'], todoController.text);
                              Navigator.of(context).pop();
                            } else {
                              db!.create(todoController.text);
                              Navigator.of(context).pop();
                              todoController.text = '';
                            }
                          });
                        },
                        child: Text('Add'),
                        style: ElevatedButton.styleFrom(primary: Colors.purple),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                        style: ElevatedButton.styleFrom(primary: Colors.orange),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
