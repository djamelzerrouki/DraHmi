import 'package:flutter/cupertino.dart';

class Operation{
  int id;
  String name;
  //IconData icon;
  String prix;
  String date;

  Operation ({this.id, this.name,  this.prix,this.date});

  //To insert the data in the bd, we need to convert it into a Map
  //Para insertar los datos en la bd, necesitamos convertirlo en un Map
  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "prix": prix,
    "date": date,

  };

  //to receive the data we need to pass it from Map to json
  //para recibir los datos necesitamos pasarlo de Map a json
  factory Operation.fromMap(Map<String, dynamic> json) => new Operation(
    id: json["id"],
    name: json["name"],
    prix: json["prix"],
    date: json["date"],
    );
}