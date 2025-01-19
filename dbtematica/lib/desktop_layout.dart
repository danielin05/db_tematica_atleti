import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AppData.dart';
import 'Manager.dart';
import 'Player.dart';
import 'Trophy.dart';

class DesktopLayout extends StatefulWidget {
  const DesktopLayout({super.key});

  @override
  _DesktopLayout createState() => _DesktopLayout();
}

class _DesktopLayout extends State<DesktopLayout> {
  String? selectedCategory = 'Players';
  dynamic selectedItem;
  // Nueva lista filtrada
  List<dynamic> filteredList = [];
  TextEditingController _searchController = TextEditingController(); // Controlador para la búsqueda

  @override
void initState() {
  super.initState();
  _searchController.addListener(_filterList);

  Future.delayed(Duration.zero, () {
    final appData = Provider.of<AppData>(context, listen: false);
    if (appData.players.isNotEmpty) {
      setState(() {
        selectedItem = appData.players[0];
        _updateFilteredList(); // Inicializa filteredList
      });
    }
  });
}
   @override
  void dispose() {
    _searchController.dispose(); // Liberar el controlador al salir
    super.dispose();
  }
  // Actualizar la lista filtrada basada en la búsqueda
  void _filterList() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredList = currentList
          .where((item) =>
              _getItem(item).name.toLowerCase().contains(query)) // Filtrar por nombre
          .toList();
    });
  }
   // Actualizar la lista filtrada al cambiar de categoría
void _updateFilteredList() {
  final query = _searchController.text.toLowerCase();
  final list = currentList;
  setState(() {
    filteredList = query.isNotEmpty
        ? list.where((item) => _getItem(item).name.toLowerCase().contains(query)).toList()
        : list;
  });
}

  dynamic _getItem(dynamic item) {
    if (item is Player || item is Manager || item is Trophy) {
      return item;
    } else {
      return null;
    }
  }

  List<dynamic> get currentList {
    final appData = Provider.of<AppData>(context, listen: false);
    if (selectedCategory == 'Players') {
      return appData.players;
    } else if (selectedCategory == 'Managers') {
      return appData.managers;
    } else if (selectedCategory == 'Trophies') {
      return appData.trophies;
    }
    return [];
  }

 void _onCategoryChanged(String? newCategory) {
  setState(() {
    selectedCategory = newCategory;
    _updateFilteredList(); // Actualizar la lista filtrada al cambiar de categoría
    if (filteredList.isNotEmpty) {
      selectedItem = filteredList[0];
    } else {
      selectedItem = null;
    }
  });
}

  void _search() {
    // Aquí puedes realizar la búsqueda o cualquier acción
    print('Buscando: ${_searchController.text}');
  }

  @override
  Widget build(BuildContext context) {
    const Color color1 = Color.fromARGB(255, 238, 100, 90); // Color del AppBar
    const Color color2 = Colors.white; // Color de fondo general
    const Color color3 = Color.fromARGB(255, 51, 68, 160); // Color del DropDown
    const Color color4 = Colors.yellow; // Color del título

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Atletico De Madrid DB',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
            color: color4,
          ),
        ),
        centerTitle: true,
        backgroundColor: color3,
      ),
      body: Container(
        color: Colors.white,
        child: Row(
          children: [
            Container(
              color: color1,
              width: 370,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        // Barra de búsqueda
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  labelText: 'Buscar...',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16), // Espacio entre barra y dropdown
                        // DropdownButton
                        DropdownButton<String>(
                          dropdownColor: color3,
                          value: selectedCategory,
                          hint: const Text('Selecciona una categoría'),
                          items: ['Players', 'Managers', 'Trophies']
                              .map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(
                                category,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto',
                                  color: color2,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: _onCategoryChanged,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(14.0),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final item = filteredList[index];
                        return GestureDetector(
                          onTap: () => setState(() => selectedItem = item),
                          child: Container(
                            margin: const EdgeInsets.only(
                              bottom: 14.0,
                              left: 4,
                              top: 0,
                              right: 0,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  Provider.of<AppData>(context, listen: false).getImageUrl(item),
                                  width: 80,
                                  height: 80,
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: Text(
                                    _getItem(item).name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                      color: color2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/fondo_estadio.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: selectedItem != null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  Provider.of<AppData>(context, listen: false).getImageUrl(selectedItem),
                                  width: 340,
                                  height: 340,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                                  (loadingProgress.expectedTotalBytes ?? 1)
                                              : null,
                                        ),
                                      );
                                    }
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Text(
                                      'ERROR trying to load an image',
                                    );
                                  },
                                ),

                                const SizedBox(height: 20),
                                Text(
                                  '${_getItem(selectedItem).name}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Roboto',
                                    color: color2,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (selectedItem is Manager)
                                  Column(
                                    children: [
                                      Text('Years on the Club: ${selectedItem.years}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                          color: color2,
                                        ),
                                      ),
                                      Text('StyleGame: ${selectedItem.style}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                          color: color2,
                                        ),
                                      ),
                                      Text('Trophies: ${selectedItem.trophies}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                          color: color2,
                                        ),
                                      ),
                                    ],
                                  )
                                else if (selectedItem is Player)
                                  Column(
                                    children: [
                                      Text('Age: ${selectedItem.age}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                          color: color2,
                                        ),
                                      ),
                                      Text('Height: ${selectedItem.height}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                          color: color2,
                                        ),
                                      ),
                                      Text('Weight: ${selectedItem.weight}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                          color: color2,
                                        ),
                                      ),
                                      Text('Position: ${selectedItem.position}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                          color: color2,
                                        ),
                                      ),
                                    ],
                                  )
                                else if (selectedItem is Trophy)
                                  Column(
                                    children: [
                                      Text('Description: ${selectedItem.description}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                          color: color2,
                                        ),
                                      ),
                                      Text('Amount of Wined: ${selectedItem.amount}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                          color: color2,
                                        ),
                                      ),
                                      Text('Years Winded: ${selectedItem.years}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                          color: color2,
                                        ),
                                      ),
                                      Text('Competition Type: ${selectedItem.type}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                          color: color2,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            )
                          : const Center(
                              child: Text(
                                'Selecciona un elemento para ver los detalles',
                                style: TextStyle(fontSize: 20, color: Colors.white),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
