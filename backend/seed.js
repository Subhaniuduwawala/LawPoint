const mongoose = require('mongoose');
const Lawyer = require('./models/Lawyer');
require('dotenv').config();

const MONGO_URI = process.env.MONGO_URI || 'mongodb://localhost:27017/lawpoint';

const sampleLawyers = [
  { name: 'Alice Johnson', specialty: 'Family Law', location: 'New York' },
  { name: 'Bob Smith', specialty: 'Criminal Defense', location: 'Los Angeles' },
  { name: 'Carol White', specialty: 'Corporate Law', location: 'Chicago' },
  { name: 'David Brown', specialty: 'Immigration Law', location: 'Houston' },
  { name: 'Emma Davis', specialty: 'Intellectual Property', location: 'San Francisco' },
];

async function seed() {
  try {
    await mongoose.connect(MONGO_URI);
    console.log('Connected to MongoDB for seeding');

    // Clear existing data (optional)
    const count = await Lawyer.countDocuments();
    console.log(`Found ${count} existing lawyers`);
    
    if (count === 0) {
      await Lawyer.insertMany(sampleLawyers);
      console.log(`Inserted ${sampleLawyers.length} sample lawyers`);
    } else {
      console.log('Database already has data. Skipping seed.');
    }

    await mongoose.connection.close();
    console.log('Seed complete');
  } catch (err) {
    console.error('Seed error:', err);
    process.exit(1);
  }
}

seed();
