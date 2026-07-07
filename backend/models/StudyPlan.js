const mongoose = require('mongoose');

const studyTaskSchema = new mongoose.Schema(
  {
    title: { type: String, required: true, trim: true },
    type: { type: String, required: true, trim: true },
    minutes: { type: Number, default: 15 },
    completed: { type: Boolean, default: false },
  },
  { _id: true }
);

const studyPlanSchema = new mongoose.Schema(
  {
    userId: { type: String, required: true, index: true },
    planDate: { type: String, required: true, index: true },
    tasks: [studyTaskSchema],
  },
  { timestamps: true }
);

studyPlanSchema.index({ userId: 1, planDate: 1 }, { unique: true });

module.exports = mongoose.model('StudyPlan', studyPlanSchema);
