const mongoose = require('mongoose');

const LawyerSchema = new mongoose.Schema({
  name: { type: String, required: true },
  specialty: { type: String },
  location: { type: String },
}, { timestamps: true });

module.exports = mongoose.model('Lawyer', LawyerSchema);
