import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haweyati/models/available-services_model.dart';
import 'package:haweyati/services/haweyati-service.dart';
import 'package:haweyati/src/utlis/const.dart';

class ServiceAvailability extends HaweyatiService<List<String>> {

  Future<List<String>> getAvailableServices(String city) async {
    Response res = await dio.get('$apiUrl/suppliers/available/$city');
    print("$apiUrl/suppliers/available/$city");
    print(city);
    return ((res.data) as List).map((item) => item.toString()).toList();
  }

  @override
  List<String> parse(Map<String, dynamic> item) {
    return null;
  }

}