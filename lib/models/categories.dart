// To parse this JSON data, do
//
//     final categoriesResponse = categoriesResponseFromJson(jsonString);

import 'dart:convert';

CategoriesResponse categoriesResponseFromJson(String str) => CategoriesResponse.fromJson(json.decode(str));

String categoriesResponseToJson(CategoriesResponse data) => json.encode(data.toJson());

class CategoriesResponse {
  final String id;
  final String firstName;
  final String lastName;
  final String productName;
  final String purchaseDate;
  final String warrantyDate;

  CategoriesResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.productName,
    required this.purchaseDate,
    required this.warrantyDate,
  });

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) => CategoriesResponse(
    id: json["id"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    productName: json["productName"],
    purchaseDate: json["purchaseDate"],
   warrantyDate: json["warrantyDate"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "productName": productName,
    "purchaseDate": purchaseDate,
    "warrantyDate": warrantyDate,
  };
}
