import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Player.dart';
import 'Manager.dart';
import 'Trophy.dart';
import 'desktop_layout.dart';
import 'package:provider/provider.dart';
import 'AppData.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppData(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Screen Size Specific Views',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Cargar los datos de forma asíncrona
  Future<void> _loadData() async {
    await Future.wait([
      getData('Players'),
      getData('Managers'),
      getData('Trophies'),
    ]);
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isDataLoaded
          ? LayoutBuilder(
              builder: (context, constraints) {
                // if (constraints.maxWidth > 450) {
                  return const DesktopLayout();
                // } else {
                //   return const ViewMobile();
                // }
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> getData(String type) async {
    try {
      final response =
          await http.post(Uri.parse('http://localhost:3000/api/$type'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (type == 'Players') {
          final parsedPlayers =
              data.map<Player>((item) => Player.fromJson(item)).toList();
          Provider.of<AppData>(context, listen: false).setPlayers(parsedPlayers);
        } else if (type == 'Managers') {
          final parsedManagers =
              data.map<Manager>((item) => Manager.fromJson(item)).toList();
          Provider.of<AppData>(context, listen: false)
              .setManagers(parsedManagers);
        } else if (type == 'Trophies') {
          final parsedTrophies =
              data.map<Trophy>((item) => Trophy.fromJson(item)).toList();
          Provider.of<AppData>(context, listen: false)
              .setTrophies(parsedTrophies);
        }
      }
    } catch (error) {
      print('Error getting data: $error');
    }
  }
}
