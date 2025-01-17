const express = require('express');
const path = require('path');
const fs = require('fs').promises;
const app = express();
const port = 3000;


const filePath0 = path.join(__dirname, 'data', 'managers.json');
const filePath1 = path.join(__dirname, 'data', 'players.json');
const filePath2 = path.join(__dirname, 'data', 'trophies.json');

try {
    fs.access(filePath0);
    console.log('File managers.json has been found.');
} catch (err) {
    console.error('File not found', err);
}

try {
    fs.access(filePath1);
    console.log('File players.json has been found.');
} catch (err) {
    console.error('File not found', err);
}

try {
    fs.access(filePath2);
    console.log('File trophies.json has been found.');
} catch (err) {
    console.error('File not found', err);
}

app.use(express.static('public'));

app.get('/', async (req, res) => {
    res.send(`Hello World /`);
});

app.post('/api/managers', async (req, res) => {
    try {
        const data = await fs.readFile(filePath0, 'utf8');
        const jsonData = JSON.parse(data);
        res.json(jsonData);
    } catch (error) {
        console.error('ERROR trying to read the file managers.json:', error);
        res.status(500).send({ error: 'Cannot read the file managers.json' });
    }
});

app.post('/api/players', async (req, res) => {
    try {
        const data = await fs.readFile(filePath1, 'utf8');
        const jsonData = JSON.parse(data);
        res.json(jsonData);
    } catch (error) {
        console.error('ERROR trying to read the file players.json:', error);
        res.status(500).send({ error: 'Cannot read the file players.json' });
    }
});

app.post('/api/trophies', async (req, res) => {
    try {
        const data = await fs.readFile(filePath2, 'utf8');
        const jsonData = JSON.parse(data);
        res.json(jsonData);
    } catch (error) {
        console.error('ERROR trying to read the file trophies.json:', error);
        res.status(500).send({ error: 'Cannot read the file trophies.json' });
    }
});

app.get('/images/:imageName', async (req, res) => {
    try {
        const imagePath = `images/${req.params.imageName}`;
        res.sendFile(imagePath, { root: __dirname }, (err) => {
            if (err) {
                console.error('ERROR trying to send the image:', err);
                res.status(404).send({ error: 'Image not found' });
            }
        });
    } catch (error) {
        console.error('ERROR processing the image request:', error);
        res.status(500).send({ error: 'Internal server ERROR' });
    }
});

const httpServer = app.listen(port, appListen);
function appListen() {
    console.log(`Example app listening on: http://localhost:${port}`);
}

process.on('SIGTERM', shutDown);
process.on('SIGINT', shutDown);
function shutDown() {
    console.log('Received kill signal, shutting down gracefully');
    httpServer.close();
    process.exit(0);
}