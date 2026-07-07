const express = require('express');
const router = express.Router();
const multer = require('multer');
const Question = require('../models/Question');
const auth = require('../middleware/auth');
const { parsePDF } = require('../utils/pdfParser');

// Store PDF in memory (no disk writes)
const upload = multer({ storage: multer.memoryStorage(), limits: { fileSize: 20 * 1024 * 1024 } });

// GET /api/questions — list with optional filters
router.get('/', async (req, res) => {
  try {
    const { subject, difficulty, examType, tag, premium, limit = 200, skip = 0 } = req.query;
    const filter = {};
    if (subject) filter.subject = subject;
    if (difficulty) filter.difficulty = difficulty;
    if (examType) filter.examType = examType;
    if (tag) filter.tags = tag;
    if (premium != null) filter.isPremium = premium === 'true';

    const questions = await Question.find(filter)
      .sort({ createdAt: -1 })
      .skip(Number(skip))
      .limit(Number(limit));

    const total = await Question.countDocuments(filter);
    res.json({ questions, total });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET /api/questions/stats — summary counts (must be before /:id)
router.get('/stats', async (req, res) => {
  try {
    const total = await Question.countDocuments();
    const bySubject = await Question.aggregate([
      { $group: { _id: '$subject', count: { $sum: 1 } } },
      { $sort: { count: -1 } },
    ]);
    const byDifficulty = await Question.aggregate([
      { $group: { _id: '$difficulty', count: { $sum: 1 } } },
    ]);
    res.json({ total, bySubject, byDifficulty });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET /api/questions/:id — single question
router.get('/:id', async (req, res) => {
  try {
    const question = await Question.findById(req.params.id);
    if (!question) return res.status(404).json({ error: 'Question not found.' });
    res.json(question);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST /api/questions — create (auth required)
router.post('/', auth, async (req, res) => {
  try {
    const question = new Question(req.body);
    await question.save();
    res.status(201).json(question);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// POST /api/questions/parse-pdf — upload PDF, extract questions (auth required)
router.post('/parse-pdf', auth, upload.single('pdf'), async (req, res) => {
  try {
    if (!req.file) return res.status(400).json({ error: 'No PDF file uploaded.' });
    const result = await parsePDF(req.file.buffer);
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: 'PDF parsing failed: ' + err.message });
  }
});

// POST /api/questions/bulk-import — import array of questions (auth required)
router.post('/bulk-import', auth, async (req, res) => {
  try {
    const { questions } = req.body;
    if (!Array.isArray(questions) || questions.length === 0) {
      return res.status(400).json({ error: 'Provide a non-empty "questions" array.' });
    }
    // Map to schema fields (include optional Hindi translation fields)
    const docs = questions.map((q) => ({
      subject: q.subject,
      topic: q.topic || 'General',
      question: q.question,
      options: q.options,
      correct: q.correct,
      difficulty: q.difficulty || 'medium',
      explanation: q.explanation || 'See solution.',
      examType: q.examType || 'General',
      year: q.year,
      isPremium: Boolean(q.isPremium),
      tags: Array.isArray(q.tags) ? q.tags : [],
      questionHi: q.questionHi || '',
      optionsHi: Array.isArray(q.optionsHi) ? q.optionsHi : [],
      explanationHi: q.explanationHi || '',
      topicHi: q.topicHi || '',
    }));
    const inserted = await Question.insertMany(docs, { ordered: false });
    res.status(201).json({ inserted: inserted.length });
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// PUT /api/questions/:id — update (auth required)
router.put('/:id', auth, async (req, res) => {
  try {
    const question = await Question.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });
    if (!question) return res.status(404).json({ error: 'Question not found.' });
    res.json(question);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// DELETE /api/questions/:id — delete (auth required)
router.delete('/:id', auth, async (req, res) => {
  try {
    const question = await Question.findByIdAndDelete(req.params.id);
    if (!question) return res.status(404).json({ error: 'Question not found.' });
    res.json({ message: 'Question deleted.' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
