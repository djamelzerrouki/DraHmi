 import 'package:drahmi/actions/sharedPrefUtils.dart';
import 'package:flutter/material.dart';
 import 'package:flutter/services.dart';

class SharedPreferenceDemo extends StatefulWidget {
  SharedPreferenceDemo() : super();

  final String title = "Shared Preference Demo";

  @override
  SharedPreferenceDemoState createState() => SharedPreferenceDemoState();
}

class SharedPreferenceDemoState extends State<SharedPreferenceDemo> {
  //
    static  String data = "0.0";
   static TextEditingController controller = TextEditingController();

    static addingToSum(String prix){
      data = PreferenceUtils.getString(PreferenceUtils.KEY_SUM);
      double sum= double.parse(data)+double.parse(prix);
      data=sum.toString();
      PreferenceUtils.setString(PreferenceUtils.KEY_SUM , data);
      data = PreferenceUtils.getString(PreferenceUtils.KEY_SUM);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
        Padding(
        padding: const EdgeInsets.only(
          top: 10,
        ),
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

            OutlineButton(
              child: Text("SAVE SUM"),
              onPressed: () {
                addingToSum(controller.text);

              },
            ),
            Text(
              PreferenceUtils.getString(PreferenceUtils.KEY_SUM)+' DA',
              style: TextStyle(fontSize: 20),
            ),


          ],
        ),
      ),
    );
  }
}