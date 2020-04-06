import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class SharedPreferenceDemo extends StatefulWidget {
  SharedPreferenceDemo() : super();

  final String title = "Shared Preference Demo";

  @override
  SharedPreferenceDemoState createState() => SharedPreferenceDemoState();
}

class SharedPreferenceDemoState extends State<SharedPreferenceDemo> {
  //
  static  double sum = 0.0;

  static  String data = "0.0";
  String nameKey = "_key_name";
  TextEditingController controller = TextEditingController();

     SharedPreferences preferences;
  static  double getDoubledata(String data){
if(double.parse(data).isNaN){
  return 0;
}
return double.parse(data);
}
  @override
  void initState() {
    super.initState();
    const MethodChannel('plugins.flutter.io/shared_preferences')
        .setMockMethodCallHandler(
          (MethodCall methodcall) async {
        if (methodcall.method == 'getAll') {
          return {"flutter." + nameKey: "[ No Name Saved ]"};
        }
        return null;
      },
    );
    setData();
  }

  Future<bool> saveData() async {
      preferences = await SharedPreferences.getInstance();
    return await preferences.setString(nameKey, controller.text);
  }
   static Future<bool> saveOperationData(String data) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString("_key_name", data);
  }

  Future<String> loadData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(nameKey);
  }

  setData() {
    loadData().then((value) {
      setState(() {
        data = getDoubledata(value).toString();
      });
    });
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
                saveData();
                setData();
              },
            ),
            Text(
              data,
              style: TextStyle(fontSize: 20),
            ),
            OutlineButton(
              child: Text("LOAD SUM"),
              onPressed: () {
                setData();
              },
            ),
          ],
        ),
      ),
    );
  }
}