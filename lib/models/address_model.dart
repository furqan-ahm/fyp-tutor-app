class Address {
  late String addressline;
  late String city;
  late String note;
  late String unit;
  late double lat;
  late double long;



  String get noteString=>note.isEmpty?'None':note;

  Address(
      {this.addressline='Address',
      this.city='City',
      required this.lat,
      required this.long,
      this.note='None',
      this.unit='Unit'});

  Address.fromMap(Map<String, dynamic> json) {
    addressline = json['addressline']??'Address';
    city = json['city']??'City';
    unit = json['unit']??'Unit';
    note = json['note']??'None';
    lat= json['lat']??25.367;
    long= json['long']??68.367;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['addressline'] = addressline;
    data['city'] = city;
    data['unit'] = unit;
    data['note'] = note;
    data['long'] = long;
    data['lat'] = lat;
    return data;
  }

  @override
  String toString() => '$unit, $addressline';
}


  final dummyAddress=Address(lat: 25,long: 25);