import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'dart:convert';
import '../models/restaurant.dart';

// This function is used for fetching the restaurant's list from the asset folder. 
final restaurantProvider = FutureProvider<List<Restaurant>>((ref) async {
  final String response = await rootBundle.rootBundle.loadString('assets/restaurants.json');
  final List data = json.decode(response);
  return data.map((json) => Restaurant.fromJson(json)).toList();
});

final searchQueryProvider = StateProvider<String>((ref) => '');
