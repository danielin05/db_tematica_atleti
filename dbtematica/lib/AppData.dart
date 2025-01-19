import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Manager.dart';
import 'Player.dart';
import 'Trophy.dart';
import 'mobile_details_layout.dart'; // Importamos MobileLayout

class AppData extends ChangeNotifier {
  List<Manager> _managers = [];
  List<Player> _players = [];
  List<Trophy> _trophies = [];
  bool _isDataLoaded = false;

  List<Manager> get managers => _managers;
  List<Player> get players => _players;
  List<Trophy> get trophies => _trophies;
  bool get isDataLoaded => _isDataLoaded;

  // Método para cargar todos los datos
  Future<void> loadData() async {
    try {
      await Future.wait([
        _fetchData('Players'),
        _fetchData('Managers'),
        _fetchData('Trophies'),
      ]);
      _isDataLoaded = true;
      notifyListeners();
    } catch (error) {
      print('Error loading data: $error');
    }
  }

  // Método privado para obtener datos de cada tipo
  Future<void> _fetchData(String type) async {
    try {
      final response =
          await http.post(Uri.parse('http://localhost:3000/api/$type'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (type == 'Players') {
          _players = data.map<Player>((item) => Player.fromJson(item)).toList();
        } else if (type == 'Managers') {
          _managers =
              data.map<Manager>((item) => Manager.fromJson(item)).toList();
        } else if (type == 'Trophies') {
          _trophies =
              data.map<Trophy>((item) => Trophy.fromJson(item)).toList();
        }
        notifyListeners();
      }
    } catch (error) {
      print('Error fetching $type data: $error');
    }
  }

void changeViewToDetails(BuildContext context, dynamic selectedItem) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MobileDetailsLayout(item: selectedItem),
    ),
  );
}




}
