const mongoose = require('mongoose');

const userFeatureSchema = new mongoose.Schema(
  {
    userId: { type: String, required: true, unique: true, index: true },
    premium: { type: Boolean, default: false },
    offlineItems: { type: [String], default: [] },
    notifications: {
      dailyQuiz: { type: Boolean, default: true },
      streak: { type: Boolean, default: true },
      currentAffairs: { type: Boolean, default: false },
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model('UserFeature', userFeatureSchema);
