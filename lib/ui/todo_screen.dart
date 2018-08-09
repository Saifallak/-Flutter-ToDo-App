import 'package:flutter/material.dart';
import 'package:simple_to_do_app/model/todo_item.dart';
import 'package:simple_to_do_app/util/database_client.dart';
import '../util/date_formatter.dart';

class ToDoScreen extends StatefulWidget {
  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final List<ToDoItem> _itemList = <ToDoItem>[];
  TextEditingController _textEditingController = TextEditingController();
  var db = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _readToDoItems();
  }

  _readToDoItems() async {
    List items = await db.getItems();
    items.forEach((item) {
      setState(() {
        _itemList.add(ToDoItem.map(item));
      });
    });
  }

  void _handleSubmit(String text) async {
    ToDoItem toDoItem = ToDoItem(text, dateFormatted());
    int savedItemId = await db.saveItem(toDoItem);
    ToDoItem addedItem = await db.getItem(savedItemId);
    debugPrint("Item Saved With id : $savedItemId");

    setState(() {
      _itemList.insert(0, addedItem);
    });
  }

  void _showFormDialog() {
    var alert = AlertDialog(
      content: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textEditingController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "New Item",
                hintText: "Item wants to Do ex: Learn Flutter Developing",
                icon: Icon(Icons.note_add),
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            _handleSubmit(_textEditingController.text);
            _textEditingController.clear();
            Navigator.pop(context);
          },
          child: Text("Save"),
        ),
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel")),
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _updateItem(ToDoItem toDoItem, int index) async {
    var alert = AlertDialog(
      title: Text("Updating Item"),
      content: Row(
        children: <Widget>[
          Expanded(
              child: TextField(
            controller: _textEditingController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: "Item",
              hintText: "eg, Upgrade Flutter to V2",
              icon: Icon(Icons.update),
            ),
          ))
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () async {
              ToDoItem updatedItem = ToDoItem.fromMap({
                "itemName": _textEditingController.text,
                "dateCreated": dateFormatted(),
                "id": toDoItem.id
              });
              _handleSubmitUpdated(updatedItem, index);
              await db.updateItem(updatedItem);
              setState(() {
                _readToDoItems();
              });
              _textEditingController.clear();
              Navigator.pop(context);
            },
            child: Text("Save")),
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel")),
      ],
    );

    _textEditingController.text= toDoItem.itemName;
    showDialog(context: context, builder: (_) => alert);
  }

  _handleSubmitUpdated(ToDoItem toDoItem, int index) async {
    setState(() {
      _itemList.removeWhere((element) {
        _itemList[index].itemName == toDoItem.itemName;
      });
    });
  }

  _deleteItem(int id, int index) async {
    debugPrint("Deleted Item");
    await db.deleteItem(id);
    setState(() {
      _itemList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: false,
              itemCount: _itemList.length,
              itemBuilder: (_, int index) {
                return Card(
                  color: Colors.white10,
                  child: ListTile(
                    title: _itemList[index],
                    onLongPress: () => _updateItem(_itemList[index], index),
                    trailing: Listener(
                      key: Key(_itemList[index].itemName),
                      child: Icon(
                        Icons.remove_circle,
                        color: Colors.redAccent,
                      ),
                      onPointerDown: (pointerEvent) =>
                          _deleteItem(_itemList[index].id, index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add ToDo",
        onPressed: _showFormDialog,
        backgroundColor: Colors.redAccent,
        child: ListTile(
          title: Icon(Icons.add),
        ),
      ),
    );
  }
}
