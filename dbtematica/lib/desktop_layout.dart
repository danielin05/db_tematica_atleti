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

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final appData = Provider.of<AppData>(context, listen: false);
      if (appData.players.isNotEmpty) {
        setState(() {
          selectedItem = appData.players[0];
        });
      }
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
      final list = currentList;
      selectedItem = list.isNotEmpty ? list[0] : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color color1 = Colors.red; // Color del AppBar
    const Color color2 = Colors.white; // Color de fondo general
    const Color color3 = Colors.indigo; // Color del DropDown
    const Color color4 = Colors.yellow; // Color del titulo
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Atletico De Madrid DB',
          style: TextStyle(
            fontSize: 24, // Tamaño de la fuente
            fontWeight:
                FontWeight.bold, // Estilo de la fuente (negrita, por ejemplo)
            fontFamily:
                'Roboto', // Tipografía (puedes cambiarla o usar una personalizada)
            color: color4, // Color del texto
          ),
        ),
        centerTitle: true,
        backgroundColor: color3,
      ),
      body: Container(
        color: color2,
        child: Row(
          children: [
            Container(
              color: color1,
              width: 370,
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Expanded(
                          child: DropdownButton<String>(
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
                                fontSize: 24, // Tamaño de la fuente
                                fontWeight: FontWeight
                                    .bold, // Estilo de la fuente (negrita, por ejemplo)
                                fontFamily:
                                    'Roboto', // Tipografía (puedes cambiarla o usar una personalizada)
                                color: color2, // Color del texto
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: _onCategoryChanged,
                      ))),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(14.0),
                      itemCount: currentList.length,
                      itemBuilder: (context, index) {
                        final item = currentList[index];
                        return GestureDetector(
                          onTap: () =>
                              setState(() => selectedItem = item),
                          child: Container(
                            margin: const EdgeInsets.only(
                                bottom: 14.0, left: 4, top: 0, right: 0),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  'http://localhost:3000/images/${_getItem(item).image}',
                                  width: 80,
                                  height: 80,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                        ),
                                      );
                                    }
                                  },
                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    return const Text(
                                        'ERROR trying to load an image');
                                  },
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: Text(
                                    _getItem(item).name,
                                    style: const TextStyle(
                                      fontSize: 18, // Tamaño de la fuente
                                      fontWeight: FontWeight
                                          .bold, // Estilo de la fuente (negrita, por ejemplo)
                                      fontFamily:
                                          'Roboto', // Tipografía (puedes cambiarla o usar una personalizada)
                                      color: color2, // Color del texto
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ));
                    }))
                ],
              ),
            ),
                // Información encima de la imagen
                Expanded(
                  child: Stack(
                    children: [
                      // Imagen de fondo
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/fondo_estadio.jpg', // Ruta de tu imagen en la carpeta assets
                          fit: BoxFit.cover, // Para que la imagen se ajuste al tamaño del contenedor
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: selectedItem != null
                        ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Image.network(
                            'http://localhost:3000/images/${_getItem(selectedItem).image}',
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
                              return const Text('ERROR trying to load an image');
                            },
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 30),
                            child: Text(
                              'Name: ${_getItem(selectedItem).name}',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),

                          //SI EL OBJETO ES UN ENTRENADOR
                          if (selectedItem is Manager)
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    'Years on the Club: ${selectedItem.years.toString()}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Calibri"),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    'StyleGame: ${selectedItem.style.toString()}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Calibri"),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    'Amount of Trophies: ${selectedItem.trophies.toString()}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Calibri"),
                                  ),
                                ),
                              ],
                            )

                          //SI EL OBJETO ES UN JUGADOR
                          else if (selectedItem is Player)
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    'Age: ${selectedItem.age.toString()}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Calibri"),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    'Height: ${selectedItem.height.toString()}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Calibri"),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    'Weight: ${selectedItem.weight.toString()}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Calibri"),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    'Position: ${selectedItem.position.toString()}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Calibri"),
                                  ),
                                ),
                              ],
                            )

                          //SI EL OBJETO ES UN TROFEO
                          else if (selectedItem is Trophy)
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    'Description: ${selectedItem.description.toString()}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Calibri"),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    'Amount of wined trophies: ${selectedItem.amount.toString()}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Calibri"),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    'Years that wined this trophie: ${selectedItem.years.toString()}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Calibri"),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    'Type of cometition: ${selectedItem.type.toString()}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Calibri"),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      )
                    : const Center(
                      child: Text(
                        'Selecciona un elemento para ver los detalles',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white, // Ajusta el color para que contraste con el fondo
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
