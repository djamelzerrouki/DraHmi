import 'package:drahmi/page1.dart';
import 'package:flutter/material.dart';

import 'actions/sharedprefrencess.dart';
import 'chart.dart';
import 'main.dart';
class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
        Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Center(
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Colors.cyan ),
                  accountName: Text("DraHmi",style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold,color: Colors.black)),
                  accountEmail: Text("Developed by djamel zerrouki"),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.add_shopping_cart ,color:Colors.cyan),
                          Text("DraHmi",style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold,color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                ),

              ),
              ListTile(
                leading: Icon(Icons.home), title: Text("Home"),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MyHomePage(title: 'Home Page')));
                },
              ),

              ListTile(
                leading: Icon(Icons.add), title: Text("add SUM"),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SharedPreferenceDemo()));
                },
              ),
              ListTile(
                leading: Icon(Icons.monetization_on), title: Text("Currency "),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
              ),
              ListTile(
                leading: Icon(Icons.show_chart), title: Text("Chart Page"),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ChartPage()));
                },
              ),
              ListTile(
                leading: Icon(Icons.settings), title: Text("Settings"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.contacts), title: Text("Contact Us"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );

  }
}
