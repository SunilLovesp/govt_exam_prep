const mongoose = require('mongoose');

const questionSchema = new mongoose.Schema(
  {
    subject: {
      type: String,
      required: true,
      enum: [
        'Quantitative Aptitude',
        'Reasoning',
        'English',
        'General Awareness',
        'Computer Knowledge',
        'Current Affairs',
      ],
    },
    topic: { type: String, required: true, trim: true },
    question: { type: String, required: true, trim: true },
    options: {
      type: [String],
      required: true,
      validate: { validator: (v) => v.length === 4, message: 'Must have exactly 4 options' },
    },
    correct: { type: Number, required: true, min: 0, max: 3 },
    difficulty: { type: String, required: true, enum: ['easy', 'medium', 'hard'], default: 'medium' },
    explanation: { type: String, required: true, trim: true },
    examType: {
      type: String,
      enum: ['SSC', 'UPSC', 'Banking', 'Railways', 'State PSC', 'Teaching', 'Army', 'General'],
      default: 'General',
    },
    year: { type: Number },
    isPremium: { type: Boolean, default: false },
    tags: { type: [String], default: [] },
    // Hindi (Devanagari) translations — optional
    questionHi: { type: String, trim: true, default: '' },
    optionsHi: { type: [String], default: [] },
    explanationHi: { type: String, trim: true, default: '' },
    topicHi: { type: String, trim: true, default: '' },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Question', questionSchema);
