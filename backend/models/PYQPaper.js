const mongoose = require('mongoose');

const PYQPaperSchema = new mongoose.Schema(
  {
    examId: { type: String, required: true },       // 'ssc_cgl', 'ibps_po', etc.
    examName: { type: String, required: true },     // 'SSC CGL', 'IBPS PO', etc.
    year: { type: Number, required: true },          // 2023, 2024, etc.
    title: { type: String, required: true },         // 'SSC CGL 2023 Tier-I Shift 1'
    fileName: { type: String, required: true },      // stored filename on disk
    originalName: { type: String, default: '' },    // original uploaded filename
    fileSize: { type: Number, default: 0 },          // bytes
  },
  { timestamps: true }
);

module.exports = mongoose.model('PYQPaper', PYQPaperSchema);
