

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'DbHelper/DbHelper.dart';
import 'EntryForm.dart';
import 'Models/Item.dart';
import 'Models/User.dart';

//pendukung program asinkron
class Home extends StatefulWidget {
  static String tag = 'home-page';
  
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  
  DbHelper dbHelper = DbHelper();
  int count = 0;
  int countUser = 0;
  List<Item> itemList;
  List<User> userList;
  List<String> listItem = ["Delete", "Update"];
  String _newValuePerem = "";
  @override
  Widget build(BuildContext context) {
    final User userArgs = ModalRoute.of(context).settings.arguments;
    int id=userArgs.id;
    if (itemList == null) {
      itemList = List<Item>();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Sembako'),
      ),
      body: Column(children: [
        Container(
          height: 100,
          child: createListViewUser(id),
        ),
        Expanded(
          child: createListView(id),
        ),
        Container(

            margin: EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () async {
                var item = await navigateToEntryForm(context, null,id);
                if (item != null) {
               
                  int result = await dbHelper.insert(item);
                  if (result > 0) {
                    updateListView(id);
                  }
                }
              },
            ),

        ),
      ]),
    );
  }

  Future<Item> navigateToEntryForm(BuildContext context, Item item,int id) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return EntryForm(item,id);
    }));
    return result;
  }

  ListView createListView(int id) {
    updateListView(id);
    TextStyle textStyle = Theme.of(context).textTheme.headline5;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.cake_rounded),
            ),
            title: Text(
              this.itemList[index].name,
              style: textStyle,
            ),
            subtitle: Text(this.itemList[index].id.toString()),
            trailing: GestureDetector(
              child: DropdownButton<String>(
                underline: SizedBox(),
                icon: Icon(Icons.menu),
                items: listItem.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String changeValue) async {
                  if (changeValue == "Delete") {
                    dbHelper.delete(this.itemList[index].id);
                    updateListView(id);
                  } else if (changeValue == "Update") {
                    var item = await navigateToEntryForm(
                        context, this.itemList[index],id);

                    dbHelper.update(item);
                    updateListView(id);
                  }
                  ;
                },
              ),
            ),
          ),
        );
      },
    );
  }
  ListView createListViewUser(int id) {
    
    updateUserView(id);
    return ListView.builder(
      itemCount: countUser,
      itemBuilder: (BuildContext context, int index) {
        return Card(
             color: Colors.cyan[200],
          elevation: 3.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.black,
              child: Icon(Icons.account_balance),
            ),
            title: Text(userList[index].name,style: TextStyle(fontSize: 25),),
            subtitle: Text(userList[index].id.toString(),style: TextStyle(fontSize: 25)),
          ),
        );
      },
    );
  }

//update List item
  void updateUserView(int id) {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      
      Future<List<User>> userListFuture = dbHelper.getUserList(id);
      userListFuture.then((userList) {
        setState(() {
          this.userList = userList;
          this.countUser = userList.length;
        });
      });
    });
  }
  //update List item
  void updateListView(int idUser) {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      
      Future<List<Item>> itemListFuture = dbHelper.getItemList(idUser);
      itemListFuture.then((itemList) {
        setState(() {
          this.itemList = itemList;
          this.count = itemList.length;
        });
      });
    });
  }
}
