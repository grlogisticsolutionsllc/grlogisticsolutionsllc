Backend: Node.js + Express (server.js)
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const app = express();
require('dotenv').config();

Middleware
app.use(express.json());
app.use(cors());

Connect to MongoDB
mongoose.connect(process.env.MONGO_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true
}).then(() => console.log('MongoDB Connected'))
.catch(err => console.log(err));

Example Route
app.get('/', (req, res) => {
    res.send('Logistics API Running');
});

Start Server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

--------------------------------------------------------------
Frontend: React (App.js)
import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Dashboard from './components/Dashboard';
import Tracking from './components/Tracking';

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Dashboard />} />
        <Route path="/track" element={<Tracking />} />
      </Routes>
    </Router>
  );
}
export default App;
