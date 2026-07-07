const mongoose = require('mongoose');

const quizAttemptSchema = new mongoose.Schema(
  {
    userId: { type: String, required: true, index: true },
    testId: { type: String, required: true },
    testTitle: { type: String, required: true },
    score: { type: Number, required: true },
    accuracy: { type: Number, required: true },
    timeTakenSeconds: { type: Number, required: true },
    subjectStats: { type: Object, default: {} },
  },
  { timestamps: true }
);

module.exports = mongoose.model('QuizAttempt', quizAttemptSchema);
