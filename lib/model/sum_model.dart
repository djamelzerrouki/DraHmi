class Sum {
  String name;
  double sum;
  Sum ({ this.name,  this.sum});

  //To insert the data in the bd, we need to convert it into a Map
  //Para insertar los datos en la bd, necesitamos convertirlo en un Map
  Map<String, dynamic> toMap()  => {
     "name": name,
    "sum": sum,


  };

  //to receive the data we need to pass it from Map to json
  //para recibir los datos necesitamos pasarlo de Map a json
  factory Sum.fromMap(Map<String, dynamic> json) => new Sum(
    name: json["name"],
    sum: json["sum"],
  );
}