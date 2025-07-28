// To parse this JSON data, do
//
//     final tripGetResponse = tripGetResponseFromJson(jsonString);

import 'dart:convert';

List<Trip> tripGetResponseFromJson(String str) =>
    List<Trip>.from(json.decode(str).map((x) => Trip.fromJson(x)));

String tripGetResponseToJson(List<Trip> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Trip {
  int idx;
  String name;
  String country;
  int duration;
  double price;
  String detail;
  String coverimage;
  String destinationZone;

  Trip({
    required this.idx,
    required this.name,
    required this.country,
    required this.duration,
    required this.price,
    required this.detail,
    required this.coverimage,
    required this.destinationZone,
  });

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        idx: json["idx"],
        name: json["name"],
        country: json["country"],
        duration: json["duration"],
        price: json["price"]?.toDouble(),
        detail: json["detail"],
        coverimage: json["coverimage"],
        destinationZone: json["destination_zone"],
      );

  Map<String, dynamic> toJson() => {
        "idx": idx,
        "name": name,
        "country": country,
        "duration": duration,
        "price": price,
        "detail": detail,
        "coverimage": coverimage,
        "destination_zone": destinationZone,
      };
}