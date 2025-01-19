import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AppData.dart';
import 'Manager.dart';
import 'Player.dart';
import 'Trophy.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({super.key});

  @override
  _MobileLayoutState createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
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

  void _navigateToDetails() {
    final appData = Provider.of<AppData>(context, listen: false); // Obtienes el contexto de AppData
    appData.changeViewToDetails(context, selectedItem); // Llamas a la función en AppData
  }

  void _search() {
    // Aquí puedes realizar la búsqueda o cualquier acción
    print('Buscando: ${_searchController.text}');
  }

  @override
  Widget build(BuildContext context) {
    const Color color1 = Color.fromARGB(255, 238, 100, 90); // Color de fondo
    const Color color2 = Colors.white; // Color de texto
    const Color color3 = Color.fromARGB(255, 51, 68, 160); // Color del DropDown
    const Color color4 = Colors.yellow; // Color del título

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Atletico De Madrid DB',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color4,
          ),
        ),
        centerTitle: true,
        backgroundColor: color3,
      ),
      body: Column(
        children: [
          // Dropdown para seleccionar la categoría
          Container(
            color: color1,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: DropdownButton<String>(
              dropdownColor: color3,
              value: selectedCategory,
              isExpanded: true,
              hint: const Text('Selecciona una categoría'),
              items: ['Players', 'Managers', 'Trophies'].map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(
                    category,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color2,
                    ),
                  ),
                );
              }).toList(),
              onChanged: _onCategoryChanged,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: Row(
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
                ),
              ],
            ),
          ),

          // Lista de elementos
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: filteredList.length, // Cambiado de currentList.length a filteredList.length
              itemBuilder: (context, index) {
                final item = filteredList[index]; // Cambiado de currentList a filteredList
                return GestureDetector(
                  onTap: () => setState(() => selectedItem = item),
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Image.network(
                        'http://localhost:3000/images/${_getItem(item).image}',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported),
                      ),
                      title: Text(
                        _getItem(item).name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

         if (selectedItem != null)
          Container(
            padding: const EdgeInsets.all(16.0),
            color: color3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen del item seleccionado
                Image.network(
                  'http://localhost:3000/images/${_getItem(selectedItem).image}', // Usa la imagen del item
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported),
                ),
                const SizedBox(width: 10), // Espacio entre la imagen y la información

                // Información del item seleccionado
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_getItem(selectedItem).name}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: color2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (selectedItem is Manager)
                        Text(
                          'Years: ${selectedItem.years}, Style: ${selectedItem.style}',
                          style: const TextStyle(color: color2),
                        )
                      else if (selectedItem is Player)
                        Text(
                          'Age: ${selectedItem.age}, Position: ${selectedItem.position}',
                          style: const TextStyle(color: color2),
                        )
                      else if (selectedItem is Trophy)
                        Text(
                          'Description: ${selectedItem.description}',
                          style: const TextStyle(color: color2),
                        ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: _navigateToDetails,
                  icon: const Icon(Icons.arrow_forward, color: color2),
                  label: const Text(
                    "See More",
                    style: TextStyle(color: color2),
                  ),
                )
              ],
            ),
          )
        else
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Selecciona un elemento para ver los detalles',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
