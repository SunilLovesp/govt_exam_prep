const mongoose = require('mongoose');

const bookmarkSchema = new mongoose.Schema(
  {
    userId: { type: String, required: true, index: true },
    question: { type: mongoose.Schema.Types.ObjectId, ref: 'Question', required: true },
    note: { type: String, default: '' },
  },
  { timestamps: true }
);

bookmarkSchema.index({ userId: 1, question: 1 }, { unique: true });

module.exports = mongoose.model('Bookmark', bookmarkSchema);
