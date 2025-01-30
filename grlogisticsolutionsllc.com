Backend (Node.js + Express)
const express = require('express');
const app = express();
const cors = require('cors');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');

app.use(cors());
app.use(bodyParser.json());

Conectar a la base de datos MongoDB
mongoose.connect('mongodb://localhost:27017/logistica', { useNewUrlParser: true, useUnifiedTopology: true });

Modelo de paquete
const Package = mongoose.model('Package', new mongoose.Schema({
    trackingNumber: String,
    sender: String,
    receiver: String,
    status: String,
    assignedDriver: String
}));

Ruta para rastreo de paquetes
app.get('/track/:trackingNumber', async (req, res) => {
    const package = await Package.findOne({ trackingNumber: req.params.trackingNumber });
    res.json(package);
});

Ruta para actualizar estado del paquete
app.post('/update-package', async (req, res) => {
    const { trackingNumber, status } = req.body;
    await Package.updateOne({ trackingNumber }, { status });
    res.json({ message: 'Paquete actualizado' });
});

app.listen(5000, () => {
    console.log('Servidor ejecutándose en el puerto 5000');
});

Frontend (React)
import React, { useState } from 'react';
import axios from 'axios';

function Tracking() {
    const [trackingNumber, setTrackingNumber] = useState('');
    const [packageInfo, setPackageInfo] = useState(null);

    const trackPackage = async () => {
        const response = await axios.get(`http://localhost:5000/track/${trackingNumber}`);
        setPackageInfo(response.data);
    };

    return (
        <div>
            <h2>Rastreo de Paquetes</h2>
            <input type="text" placeholder="Número de seguimiento" value={trackingNumber} onChange={(e) => setTrackingNumber(e.target.value)} />
            <button onClick={trackPackage}>Rastrear</button>
            {packageInfo && (
                <div>
                    <p>Envío de: {packageInfo.sender}</p>
                    <p>Envío a: {packageInfo.receiver}</p>
                    <p>Estado: {packageInfo.status}</p>
                </div>
            )}
        </div>
    );
}

export default Tracking;
