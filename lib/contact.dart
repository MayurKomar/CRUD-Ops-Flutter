class Contact {
  static const tableName = 'contacts';
  static const colId = 'id';
  static const colName = 'name';
  static const colNumber = 'number';

  Contact({this.id, this.name, this.number});

  int? id;
  String? name;
  String? number;

  Contact.fromMap(Map<String,dynamic> map){
    id = map[colId];
    name = map[colName];
    number = map[colNumber];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{colName: name, colNumber: number};
    if (id!=null) map[colId] = id;
    return map;
  }
}
