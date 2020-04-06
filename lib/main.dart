import 'package:flutter/material.dart';

import 'actions/add_editOperation.dart';
import 'actions/sharedprefrencess.dart';
import 'db/database.dart';
import 'model/operation_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
   final Map<String, IconData> _data = Map.fromIterables(
      [ 'Transportation', 'Food', 'Health', 'Other'],
      [Icons.directions_car, Icons.fastfood, Icons.healing,Icons.devices_other]);

  void _incrementCounter() {
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
               accountName: Text("Djamel zerrouki"),
              accountEmail: Text("Djameljimmizerrouki@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.cyan,
                child: Icon(Icons.add_shopping_cart ,color:Colors.white),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home), title: Text("Home"),
              onTap: () {
                Navigator.pop(context);
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
      ),

      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body:  Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
          child: Center(
          child: Column(
          children: <Widget>[
          RaisedButton(


          onPressed: () {
    Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => SharedPreferenceDemo()));
    },
      child: Text(
        SharedPreferenceDemoState.data+' DA',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
    ),

    Expanded(
    child: new FutureBuilder<List<Operation>>(

    //we call the method, which is in the folder db file database.dart
    future: ClientDatabaseProvider.db.getAllOperations(),
    builder: (BuildContext context, AsyncSnapshot<List<Operation>> snapshot) {
    if (snapshot.hasData) {
    return ListView.builder(
    physics: BouncingScrollPhysics(),
    //Count all records
    itemCount: snapshot.data.length,
    //all the records that are in the Operation table are passed to an item Operation item = snapshot.data [index];
    itemBuilder: (BuildContext context, int index){
    Operation item = snapshot.data[index];
    //delete one register for id
    return Dismissible(
    key: UniqueKey(),
    background: Container(color: Colors.red),
    onDismissed: (diretion) {
    ClientDatabaseProvider.db.deleteOperationWithId(item.id);
    },
    //Now we paint the list with all the records, which will have a number, name, phone

    child: ListTile(
    title: Text(item.name),
    subtitle: Text(item.date.toString()),
    leading: CircleAvatar(child:Icon(_data[item.name])),

    trailing: Text(item.prix.toString()+' DA', style: TextStyle( color: Colors.green, fontWeight: FontWeight.bold,fontSize: 20),),
    onLongPress: () {
    Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => AddEditOperation(
    true, //Here is the record that we want to edit
    operation: item,
    )
    )
    );},
    //If we press one of the cards, it takes us to the page to edit, with the data onTap:
    //This method is in the file add_editOperation.dart
    onTap: () {
    Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => AddEditOperation(
    true, //Here is the record that we want to edit
    operation: item,
    )
    )
    );
    },
    ),
    );
    },
    );
    }else {
    return Center(child: CircularProgressIndicator());
    }
    },
    ),

    ),
    FloatingActionButton(

    child: Icon(Icons.add),

    onPressed: () {
    Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => AddEditOperation(false)));
    },
    ),
   ],),),),),);
  }
}
