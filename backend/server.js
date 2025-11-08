const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const jwt = require('jsonwebtoken');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 4000;
const MONGO_URI = process.env.MONGO_URI || 'mongodb://localhost:27017/lawpoint';

// Middleware
const { authMiddleware, JWT_SECRET } = require('./middleware/auth');

// In-memory storage fallback
let dbConnected = false;
const inMemoryStore = [];
const inMemoryUsers = [];

// Error handlers
process.on('unhandledRejection', (reason, promise) => {
  console.error('❌ Unhandled Rejection at:', promise, 'reason:', reason);
});

process.on('uncaughtException', (error) => {
  console.error('❌ Uncaught Exception:', error);
  process.exit(1);
});

// Connect to MongoDB
mongoose.connect(MONGO_URI)
  .then(() => {
    dbConnected = true;
    console.log('✅ Connected to MongoDB');
  })
  .catch(err => {
    dbConnected = false;
    console.error('MongoDB connection error — falling back to in-memory store:', err.message);
    console.log('⚠️  Will use in-memory storage (data will be lost on restart)');
  });

mongoose.connection.on('error', (err) => {
  console.error('MongoDB error:', err);
});

// Load models after mongoose connection setup
const Lawyer = require('./models/Lawyer');
const User = require('./models/User');

// Routes
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    dbConnected: mongoose.connection.readyState === 1,
    timestamp: new Date().toISOString()
  });
});

// Auth Routes
app.post('/api/auth/signup', async (req, res) => {
  try {
    const { email, password, name } = req.body;
    
    if (!email || !password || !name) {
      return res.status(400).json({ error: 'Please provide email, password, and name' });
    }

    if (dbConnected && mongoose.connection.readyState === 1) {
      // MongoDB path
      const existingUser = await User.findOne({ email });
      if (existingUser) {
        return res.status(400).json({ error: 'User already exists' });
      }

      const user = new User({ email, password, name });
      await user.save();

      const token = jwt.sign({ id: user._id, email: user.email }, JWT_SECRET, { expiresIn: '7d' });

      return res.status(201).json({
        token,
        user: {
          id: user._id,
          email: user.email,
          name: user.name
        }
      });
    }

    // In-memory fallback
    const bcrypt = require('bcryptjs');
    
    const existingUser = inMemoryUsers.find(u => u.email === email.toLowerCase());
    if (existingUser) {
      return res.status(400).json({ error: 'User already exists' });
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const newUser = {
      id: String(Date.now()) + Math.floor(Math.random() * 1000),
      email: email.toLowerCase(),
      password: hashedPassword,
      name,
      createdAt: Date.now()
    };
    
    inMemoryUsers.push(newUser);

    const token = jwt.sign({ id: newUser.id, email: newUser.email }, JWT_SECRET, { expiresIn: '7d' });

    return res.status(201).json({
      token,
      user: {
        id: newUser.id,
        email: newUser.email,
        name: newUser.name
      }
    });
  } catch (err) {
    console.error('Signup error:', err);
    res.status(500).json({ error: 'Server error: ' + err.message });
  }
});

app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    
    if (!email || !password) {
      return res.status(400).json({ error: 'Please provide email and password' });
    }

    if (dbConnected && mongoose.connection.readyState === 1) {
      // MongoDB path
      const user = await User.findOne({ email: email.toLowerCase() });
      if (!user) {
        return res.status(400).json({ error: 'Invalid credentials' });
      }

      const isMatch = await user.comparePassword(password);
      if (!isMatch) {
        return res.status(400).json({ error: 'Invalid credentials' });
      }

      const token = jwt.sign({ id: user._id, email: user.email }, JWT_SECRET, { expiresIn: '7d' });

      return res.status(200).json({
        token,
        user: {
          id: user._id,
          email: user.email,
          name: user.name
        }
      });
    }

    // In-memory fallback
    const bcrypt = require('bcryptjs');
    
    const user = inMemoryUsers.find(u => u.email === email.toLowerCase());
    if (!user) {
      return res.status(400).json({ error: 'Invalid credentials' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ error: 'Invalid credentials' });
    }

    const token = jwt.sign({ id: user.id, email: user.email }, JWT_SECRET, { expiresIn: '7d' });

    return res.status(200).json({
      token,
      user: {
        id: user.id,
        email: user.email,
        name: user.name
      }
    });
  } catch (err) {
    console.error('Login error:', err);
    res.status(500).json({ error: 'Server error: ' + err.message });
  }
});

app.get('/api/auth/me', authMiddleware, async (req, res) => {
  try {
    if (dbConnected && mongoose.connection.readyState === 1) {
      const user = await User.findById(req.user.id).select('-password');
      if (!user) {
        return res.status(404).json({ error: 'User not found' });
      }
      return res.json(user);
    }

    // In-memory fallback
    const user = inMemoryUsers.find(u => u.id === req.user.id);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    const { password, ...userWithoutPassword } = user;
    res.json(userWithoutPassword);
  } catch (err) {
    console.error('Get user error:', err);
    res.status(500).json({ error: 'Server error: ' + err.message });
  }
});

// Lawyer Routes
app.get('/api/lawyers', async (req, res) => {
  try {
    if (dbConnected && mongoose.connection.readyState === 1) {
      const lawyers = await Lawyer.find();
      return res.json(lawyers);
    }

    // In-memory fallback
    res.json(inMemoryStore);
  } catch (err) {
    console.error('Get lawyers error:', err);
    res.status(500).json({ error: 'Server error: ' + err.message });
  }
});

app.post('/api/lawyers', authMiddleware, async (req, res) => {
  try {
    const { name, specialty, location } = req.body;
    
    if (!name) {
      return res.status(400).json({ error: 'Name is required' });
    }

    if (dbConnected && mongoose.connection.readyState === 1) {
      const lawyer = new Lawyer({ name, specialty, location });
      await lawyer.save();
      return res.status(201).json(lawyer);
    }

    // In-memory fallback
    const newLawyer = {
      id: String(inMemoryStore.length + 1),
      name,
      specialty,
      location,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };
    inMemoryStore.push(newLawyer);
    res.status(201).json(newLawyer);
  } catch (err) {
    console.error('Create lawyer error:', err);
    res.status(500).json({ error: 'Server error: ' + err.message });
  }
});

// Start server
const server = app.listen(PORT, () => {
  console.log(`✅ LawPoint backend listening on port ${PORT}`);
  console.log(`📍 Health check available at http://localhost:${PORT}/api/health`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM signal received: closing HTTP server');
  server.close(() => {
    console.log('HTTP server closed');
    mongoose.connection.close(false, () => {
      console.log('MongoDB connection closed');
      process.exit(0);
    });
  });
});

console.log('Server initialization complete');
