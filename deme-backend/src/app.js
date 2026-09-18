const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
require('dotenv').config();

const authRoutes = require('./routes/authRoutes'); // <-- AJOUT

const app = express();

// Middlewares
app.use(helmet());
app.use(cors());
app.use(morgan('dev'));
app.use(express.json());

// Routes
app.get('/', (req, res) => {
    res.json({ message: 'API DƐMƐ Backend en ligne 🚀' });
});

// Route de test
app.get('/', (req, res) => {
    res.json({ message: 'API DƐMƐ Backend en ligne 🚀' });
});

// ✅ AJOUT : Route pour les outils de monitoring (UptimeRobot)
app.get('/health', (req, res) => {
    res.status(200).json({
        status: 'ok',
        timestamp: new Date().toISOString(),
        whatsapp_status: require('./config/whatsapp').getConnectionState()
    });
});

// Enregistrement des routes d'authentification
app.use('/api/auth', authRoutes); // <-- AJOUT

module.exports = app;