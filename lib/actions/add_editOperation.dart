import 'package:drahmi/actions/sharedPrefUtils.dart';
import 'package:drahmi/actions/sharedprefrencess.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
 import '../db/database.dart';

 import '../model/operation_model.dart';
 import 'package:intl/intl.dart';

class AddEditOperation extends StatefulWidget {
  final bool edit;
  final Operation operation;


  AddEditOperation(this.edit, {this.operation})
  : assert(edit == true || operation ==null);


  @override
  _AddEditOperationState createState() => _AddEditOperationState();
}

class _AddEditOperationState extends State<AddEditOperation> {
  SharedPreferences preferences ;
  static  String data = "0.0";
  String nameKey = "sum";

  TextEditingController nameEditingController = TextEditingController();
  TextEditingController prixEditingController = TextEditingController();

  String _selectedType='Transportation';
  IconData _selectedIcon;

  final Map<String, IconData> _data = Map.fromIterables(
      [ 'Transportation', 'Food', 'Health', 'Other'],
      [Icons.directions_car, Icons.fastfood, Icons.healing,Icons.devices_other]);



  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {    
    super.initState();
    //if you press the button to edit it must pass to true, 
    //instantiate the name and phone in its respective controller, (link them to each controller)
    if(widget.edit == true){
    //  nameEditingController.text = widget.operation.name;
      _selectedType=widget.operation.name;
      prixEditingController.text = widget.operation.prix.toString();
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.edit?"Edit Operation":"Add Operation"),),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
             child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Icon(Icons.add_shopping_cart,color:Colors.cyan,size: 250),
               ),
              //
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                        items: _data.keys.map((String val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Icon(_data[val],color:Colors.cyan),
                                ),
                                Text(val),
                              ],
                            ),
                          );
                        }).toList(),
                        hint: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                              child:
                              Icon(_selectedIcon ?? _data.values.toList()[0],color:Colors.blueAccent),
                            ),
                            Text(_selectedType ?? _data.keys.toList()[0]),
                          ],
                        ),
                        onChanged: (String val) {
                          setState(() {
                            _selectedType = val;
                            _selectedIcon = _data[val];
                          });
                        }),
                  ),
                ),

                // textFormField(nameEditingController, "Name", "Enter Name",
                 //   Icons.add_shopping_cart, widget.edit ? widget.operation.name : "name"),
                textFormFieldPhone(prixEditingController, "Prix", "Enter Prix",
                Icons.money_off, widget.edit ? widget.operation.prix : "Prix",),

                RaisedButton(
                  color:  Colors.cyan,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text('Save',
                    style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    color: Colors.white
                  ),
                    ),
                    onPressed: () async {
                      if (!_formKey.currentState.validate()){
                        Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Data'))
                        );
                      }else if (widget.edit == true) {
                           ClientDatabaseProvider.db.updateOperation(new Operation(
                              name: _selectedType,
                              prix: double.parse(prixEditingController.text),
                             date:(DateTime.now()).toString() ,
                            id: widget.operation.id ));
                        } else {
                        await ClientDatabaseProvider.db.addOperationToDatabase(new Operation(
                          name:_selectedType,
                           prix:  double.parse(prixEditingController.text),
                          date: new DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now()).toString()
                         ));
                        substractionofSum(prixEditingController.text);
                      }
                      Navigator.pop(context);
                    },
                )
              ],
            ),
          ),
        ),
      ),
  
    );
  }


  textFormField(TextEditingController t, String label, String hint,
    IconData iconData, String initialValue) {
      return Padding(
        padding: const EdgeInsets.only(
          top: 10,
        ),
        child: TextFormField(
          validator: (value){
            if (value.isEmpty) {
              return 'Please enter some text';
            }
          },
          controller: t,
          //keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            prefixIcon: Icon(iconData),
            hintText: label,
            border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10))
          ),
        ),
      );
    }

    textFormFieldPhone(TextEditingController t, String label, String hint,
    IconData iconData, String initialValue) {
      return Padding(
        padding: const EdgeInsets.only(
          top: 10,
        ),
        child: TextFormField(
          validator: (value){
            if (value.isEmpty) {
              return 'Please enter some text';
            }
          },
          controller: t,
          keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            prefixIcon: Icon(iconData),
            hintText: label,
            border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10))
          ),
        ),
      );
    }

static substractionofSum(String prix){
  data = PreferenceUtils.getString(PreferenceUtils.KEY_SUM);
double sum= double.parse(data)-double.parse(prix);
data=sum.toString();
  PreferenceUtils.setString(PreferenceUtils.KEY_SUM , data);
  data = PreferenceUtils.getString(PreferenceUtils.KEY_SUM);
}
}
