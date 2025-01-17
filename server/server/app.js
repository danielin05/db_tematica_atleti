const express = require('express');
const app = express();

// Ruta principal
app.get('/', (req, res) => {
  res.send('¡Hola, mundo con Express!');
});

// Configurar el puerto
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Servidor funcionando en http://localhost:${PORT}`);
});