import 'package:flutter/material.dart';
import 'Manager.dart';
import 'Player.dart';
import 'Trophy.dart';

class AppData extends ChangeNotifier {
  List<Manager> _managers = [];
  List<Player> _players = [];
  List<Trophy> _trophies = [];

  List<Manager> get managers => _managers;
  List<Player> get players => _players;
  List<Trophy> get trophies => _trophies;

  void setManagers(List<Manager> newManagers) {
    _managers = newManagers;
    notifyListeners();
  }

  void setPlayers(List<Player> newPlayers) {
    _players = newPlayers;
    notifyListeners();
  }

  void setTrophies(List<Trophy> newTrophies) {
    _trophies = newTrophies;
    notifyListeners();
  }
}