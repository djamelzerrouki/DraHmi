import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'actions/add_editOperation.dart';
 import 'actions/sharedPrefUtils.dart';
import 'actions/sharedprefrencess.dart';
import 'chart.dart';
import 'db/database.dart';
import 'main_drawer.dart';
import 'model/operation_model.dart';
import 'page1.dart';

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
      home: MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //CircleAvatar(child:Icon(_data[item.name]),foregroundColor: Colors.cyan,)
   final Map<String, CircleAvatar> _data = Map.fromIterables(
      [ 'Transportation', 'Food', 'Health', 'Clothes','Other'],
      [
        CircleAvatar(child:Icon(Icons.directions_car),backgroundColor:Colors.deepPurple,),
        CircleAvatar(child:Icon( Icons.local_dining),backgroundColor: Colors.pinkAccent,),
        CircleAvatar(child:Icon(Icons.healing),backgroundColor: Color(0xff109618),),
        CircleAvatar(child:Icon(Icons.shopping_cart),backgroundColor: Colors.blueAccent,),
        CircleAvatar(child:Icon(Icons.devices_other),backgroundColor: Colors.orange,),


      ]
   );

   static List<Operation> operations=List<Operation>();

   static  String data = "0.0";
   String nameKey = "sum";

   Future<bool> saveData(String data) async {
     SharedPreferences preferences = await SharedPreferences.getInstance();
     return await preferences.setString("sum", data);
   }

   static   readPrefStr(String key) async {
     final SharedPreferences pref = await SharedPreferences.getInstance();
     return pref.getString(key);
   }

   setData() {
     readPrefStr("sum").then((value) {
       setState(() {
         data = value;
       });
     });
   }

   @override
   void initState() {
     super.initState();
     PreferenceUtils.init();
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
      // Main Drawer
      drawer: MainDrawer(),
//

      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
    //  backgroundColor: Colors.cyan,
      body:  Padding(
          padding: EdgeInsets.all(2.0),
          child: Container(
          child: Center(
          child: Column(
          children: <Widget>[

            RaisedButton(
              color: Colors.blue,

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50.0))),
          onPressed: () {
            showCustomDialogWithImage(context);
   // Navigator.of(context).push(MaterialPageRoute(builder: (context) => SharedPreferenceDemo()));
    },
      child: Text(
        PreferenceUtils.getString(PreferenceUtils.KEY_SUM)+' DA' ,
        style: TextStyle(fontSize: 28.0,fontWeight: FontWeight.bold,color: Colors.white),),
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
    operations.add(item);
    //delete one register for id
    return Dismissible(
    key: UniqueKey(),
    background: Container(color: Colors.red),
    onDismissed: (diretion) {
    ClientDatabaseProvider.db.deleteOperationWithId(item.id);
    },
    //Now we paint the list with all the records, which will have a number, name, phone

    child:  Card(
      margin: EdgeInsets.all(3.0),
      elevation: 1.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0))),


      child: ListTile(
      title: Text(item.name),
      subtitle: Text(item.date.toString()),
      leading: _data[item.name],

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


   void showCustomDialogWithImage(BuildContext context) {
       TextEditingController controller = TextEditingController();

     Dialog dialogWithImage = Dialog(
       child: Container(
         height: 350.0,
         width: 400.0,
         child: Column(
           children: <Widget>[
             Container(
               padding: EdgeInsets.all(12),
               alignment: Alignment.center,
               decoration: BoxDecoration(color: Colors.cyan),
               child: Text(
                 "Add sum",
                 style: TextStyle(
                     color: Colors.white,
                     fontSize: 18,
                     fontWeight: FontWeight.w600),
               ),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Container(
                 height: 150,
                 width: 150,
                 child: Image.asset(
                   'assets/images/da1.jpg',
                   fit: BoxFit.scaleDown,
                 ),
               ),
             ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: TextFormField(
                 controller: controller,
                 validator: (value){
                   if (value.isEmpty) {
                     return 'Please enter some text';
                   }
                 },
                 keyboardType: TextInputType.number,
                 textCapitalization: TextCapitalization.words,
                 decoration: InputDecoration(
                     prefixIcon: Icon(Icons.money_off),
                     hintText: "Enter SUM",
                     border:
                     OutlineInputBorder(borderRadius: BorderRadius.circular(10))

                 ),
               ),
             ),

             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.end,
               children: <Widget>[
                 RaisedButton(
                   color: Colors.blue,
                   onPressed: () {
                     setState(() {
                       addingToSum(controller.text);

                     });
                     Navigator.of(context).pop();
                   },
                   child: Text(
                     'Save',
                     style: TextStyle(fontSize: 18.0, color: Colors.white),
                   ),
                 ),
                 SizedBox(
                   width: 20,
                 ),
                 RaisedButton(
                   color: Colors.red,
                   onPressed: () {
                     Navigator.of(context).pop();
                   },
                   child: Text(
                     'Cancel!',
                     style: TextStyle(fontSize: 18.0, color: Colors.white),
                   ),
                 )
               ],
             ),
           ],
         ),
       ),
     );
     showDialog(
         context: context, builder: (BuildContext context) => dialogWithImage);
   } static addingToSum(String prix){
     data = PreferenceUtils.getString(PreferenceUtils.KEY_SUM);
     double sum= double.parse(data)+double.parse(prix);
     data=sum.toString();
     PreferenceUtils.setString(PreferenceUtils.KEY_SUM , data);
     data = PreferenceUtils.getString(PreferenceUtils.KEY_SUM);
   }

}
