// To parse this JSON data, do
//
//     final customerRegisterPostResponse = customerRegisterPostResponseFromJson(jsonString);

import 'dart:convert';

CustomerRegisterPostResponse customerRegisterPostResponseFromJson(String str) =>
    CustomerRegisterPostResponse.fromJson(json.decode(str));

String customerRegisterPostResponseToJson(CustomerRegisterPostResponse data) =>
    json.encode(data.toJson());

class CustomerRegisterPostResponse {
  String message;
  Customer customer;

  CustomerRegisterPostResponse({
    required this.message,
    required this.customer,
  });

  factory CustomerRegisterPostResponse.fromJson(Map<String, dynamic> json) =>
      CustomerRegisterPostResponse(
        message: json["message"],
        customer: Customer.fromJson(json["customer"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "customer": customer.toJson(),
      };
}

class Customer {
  int idx;
  String fullname;
  String phone;
  String email;
  String image;

  Customer({
    required this.idx,
    required this.fullname,
    required this.phone,
    required this.email,
    required this.image,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        idx: json["idx"],
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "idx": idx,
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
      };
}