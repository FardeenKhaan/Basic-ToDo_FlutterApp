import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_app/item_list.dart';
import 'package:to_do_app/my_buttons.dart';
import 'package:to_do_app/todos.dart';

class ScreenUi extends StatefulWidget {
  ScreenUi({super.key});

  @override
  State<ScreenUi> createState() => _ScreenUiState();
}

class _ScreenUiState extends State<ScreenUi> {
  final todosList = ToDo.todoList();
  List<ToDo> _foundtodo = [];
  final _todocontroller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    _foundtodo = todosList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {},
                icon: Image.asset(
                  'assets/Profile-modified.png',
                ))
          ],
        ),
        drawer: Drawer(
            child: ListView(
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade700,
                    child: CircleAvatar(
                      maxRadius: 75.0,
                      backgroundImage: AssetImage(
                        'assets/Profile-modified.png',
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        )),
        floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          onPressed: CreateNewTask,
          child: Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.width * 0.08,
                  horizontal: MediaQuery.of(context).size.height * 0.05,
                ),
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: TextFormField(
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400),
                  onChanged: (value) => _runFiller(value),
                  textAlign: TextAlign.center,
                  cursorHeight: 30.0,
                  cursorColor: Colors.black54,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.grey,
                      prefixIconColor: Colors.black,
                      prefixIcon: Icon(
                        Icons.search,
                        size: 30,
                      ),
                      hintText: 'Search',
                      hintStyle:
                          TextStyle(color: Colors.black, fontSize: 20.0)),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.90,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: Text(
                              'All ToDos',
                              style: GoogleFonts.aboreto(fontSize: 40.0),
                            ),
                          ),
                          for (ToDo todoo in _foundtodo.reversed)
                            ItemList(
                              todo: todoo,
                              onDeleteItem: _deleteToDoItem,
                              onToDoChanged: _handleToDoChange,
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.09,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void CreateNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.grey[300],
              content: Container(
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // get user input
                    TextField(
                      controller: _todocontroller,
                      cursorColor: Colors.grey,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "Add a new task",
                          fillColor: Colors.black,
                          filled: true),
                    ),

                    // buttons -> save + cancel
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // save button
                        MyButton(
                            text: "Save",
                            onPressed: () {
                              _addtodoItem(_todocontroller.text);
                              _todocontroller.clear();
                              Navigator.pop(context);
                            }),

                        const SizedBox(width: 8),

                        // cancel button
                        MyButton(
                            text: "Cancel",
                            onPressed: () {
                              Navigator.pop(context);
                              _todocontroller.clear();
                            }),
                      ],
                    ),
                  ],
                ),
              ));
        });
  }

  void _runFiller(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundtodo = results;
    });
  }

  void _addtodoItem(String todo) {
    setState(() {
      todosList.add(ToDo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          todoText: todo));
    });
    _todocontroller.clear();
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDoItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });
  }
}
