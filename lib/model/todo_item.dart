import 'package:flutter/material.dart';

class ToDoItem extends StatelessWidget {
  String _itemName;
  String _dateCreated;
  int _id;

  ToDoItem(this._itemName, this._dateCreated);

  ToDoItem.map(dynamic obj) {
    this._itemName = obj["itemName"];
    this._dateCreated = obj["dateCreated"];
    this._id = obj["id"];
  }

  ToDoItem.fromMap(Map<String, dynamic> map) {
    this._itemName = map["itemName"];
    this._dateCreated = map["dateCreated"];
    this._id = map["id"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["itemName"] = this._itemName;
    map["dateCreated"] = this._dateCreated;
    if (_id != null) {
      map["id"] = this._id;
    }
    return map;
  }

  String get itemName => _itemName;
  String get dateCreated => _dateCreated;
  int get id => _id;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "$_itemName",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17.0),
          ),
          Container(
            margin: EdgeInsets.all(5.0),
            child: Text(
              "Created on: $_dateCreated",
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
