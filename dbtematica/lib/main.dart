import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AppData.dart';
import 'desktop_layout.dart';
import 'mobile_layout.dart'; // Importamos MobileLayout

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
  @override
  void initState() {
    super.initState();
    _loadAppData();
  }

  // Llama al método de AppData para cargar datos
  void _loadAppData() {
    final appData = Provider.of<AppData>(context, listen: false);
    appData.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppData>(
      builder: (context, appData, child) {
        return Scaffold(
          body: appData.isDataLoaded
              ? LayoutBuilder(
                  builder: (context, constraints) {
                    // Si el ancho de la ventana es menor o igual a 450px, usa MobileLayout
                    if (constraints.maxWidth <= 530) {
                      return const MobileLayout();
                    } else {
                      return const DesktopLayout();
                    }
                  },
                )
              : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
