import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AppData.dart';
import 'Manager.dart';
import 'Player.dart';
import 'Trophy.dart';

class MobileDetailsLayout extends StatefulWidget {
  final dynamic item;
  const MobileDetailsLayout({super.key, required this.item});

  @override
  _MobileDetailsLayoutState createState() => _MobileDetailsLayoutState();
}

class _MobileDetailsLayoutState extends State<MobileDetailsLayout> {

  @override
  Widget build(BuildContext context) {
    const Color color1 = Color.fromARGB(255, 238, 100, 90); // Color de fondo
    const Color color2 = Colors.white; // Color de texto
    const Color color3 = Color.fromARGB(255, 51, 68, 160); // Color del DropDown
    const Color color4 = Colors.yellow; // Color del título
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
        backgroundColor: color1,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondo_estadio.jpg',
              fit: BoxFit.cover,
            ),
          ),Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child:Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              'http://localhost:3000/images/${widget.item.image}',
                              width: 280,
                              height: 280,
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
                              '${widget.item.name}',
                              textAlign: TextAlign.center,  // Centra el texto
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                                color: color2,
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (widget.item is Manager)
                              Column(
                                children: [
                                  Text('Years on the Club: ${widget.item.years}',
                                    textAlign: TextAlign.center,  // Centra el texto
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                      color: color2,
                                    ),
                                  ),
                                  Text('StyleGame: ${widget.item.style}',
                                    textAlign: TextAlign.center,  // Centra el texto
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                      color: color2,
                                    ),
                                  ),
                                  Text('Trophies: ${widget.item.trophies}',
                                    textAlign: TextAlign.center,  // Centra el texto
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                      color: color2,
                                    ),
                                  ),
                                ],
                              )
                            else if (widget.item is Player)
                              Column(
                                children: [
                                  Text('Age: ${widget.item.age}',
                                    textAlign: TextAlign.center,  // Centra el texto
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                      color: color2,
                                    ),
                                  ),
                                  Text('Height: ${widget.item.height}',
                                    textAlign: TextAlign.center,  // Centra el texto
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                      color: color2,
                                    ),
                                  ),
                                  Text('Weight: ${widget.item.weight}',
                                    textAlign: TextAlign.center,  // Centra el texto
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                      color: color2,
                                    ),
                                  ),
                                  Text('Position: ${widget.item.position}',
                                    textAlign: TextAlign.center,  // Centra el texto
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                      color: color2,
                                    ),
                                  ),
                                ],
                              )
                            else if (widget.item is Trophy)
                              Column(
                                children: [
                                  Text('Description: ${widget.item.description}',
                                    textAlign: TextAlign.center,  // Centra el texto
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                      color: color2,
                                    ),
                                  ),
                                  Text('Amount of Wined: ${widget.item.amount}',
                                    textAlign: TextAlign.center,  // Centra el texto
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                      color: color2,
                                    ),
                                  ),
                                  Text('Years Winded: ${widget.item.years}',
                                    textAlign: TextAlign.center,  // Centra el texto
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                      color: color2,
                                    ),
                                  ),
                                  Text('Competition Type: ${widget.item.type}',
                                    textAlign: TextAlign.center,  // Centra el texto
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                      color: color2,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        )
                    
              ),
            )
          ],
        ),
        ]
      ),
    );
  }
}
