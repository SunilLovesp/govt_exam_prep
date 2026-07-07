const express = require('express');
const router = express.Router();
const Bookmark = require('../models/Bookmark');
const Question = require('../models/Question');
const QuizAttempt = require('../models/QuizAttempt');
const StudyPlan = require('../models/StudyPlan');
const UserFeature = require('../models/UserFeature');

const defaultTasks = [
  { title: 'Attempt daily mixed quiz', type: 'Quiz', minutes: 10 },
  { title: 'Solve one previous year paper section', type: 'PYQ', minutes: 25 },
  { title: 'Revise one weak chapter', type: 'Study', minutes: 30 },
  { title: 'Read and quiz current affairs', type: 'Current Affairs', minutes: 15 },
  { title: 'Review bookmarked mistakes', type: 'Revision', minutes: 20 },
];

function userId(req) {
  return req.query.userId || req.body.userId || 'demo-user';
}

router.get('/study-plan', async (req, res) => {
  try {
    const planDate = req.query.date || new Date().toISOString().slice(0, 10);
    const plan = await StudyPlan.findOneAndUpdate(
      { userId: userId(req), planDate },
      { $setOnInsert: { tasks: defaultTasks } },
      { new: true, upsert: true }
    );
    res.json(plan);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

router.patch('/study-plan/:taskId', async (req, res) => {
  try {
    const planDate = req.body.date || new Date().toISOString().slice(0, 10);
    const plan = await StudyPlan.findOne({ userId: userId(req), planDate });
    if (!plan) return res.status(404).json({ error: 'Study plan not found.' });
    const task = plan.tasks.id(req.params.taskId);
    if (!task) return res.status(404).json({ error: 'Task not found.' });
    task.completed = req.body.completed ?? !task.completed;
    await plan.save();
    res.json(plan);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

router.get('/bookmarks', async (req, res) => {
  try {
    const bookmarks = await Bookmark.find({ userId: userId(req) })
      .populate('question')
      .sort({ createdAt: -1 });
    res.json({ bookmarks });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

router.post('/bookmarks/:questionId', async (req, res) => {
  try {
    const question = await Question.findById(req.params.questionId);
    if (!question) return res.status(404).json({ error: 'Question not found.' });
    const bookmark = await Bookmark.findOneAndUpdate(
      { userId: userId(req), question: question._id },
      { note: req.body.note || '' },
      { new: true, upsert: true }
    );
    res.status(201).json(bookmark);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

router.delete('/bookmarks/:questionId', async (req, res) => {
  try {
    await Bookmark.deleteOne({ userId: userId(req), question: req.params.questionId });
    res.json({ message: 'Bookmark removed.' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

router.post('/attempts', async (req, res) => {
  try {
    const attempt = await QuizAttempt.create({ ...req.body, userId: userId(req) });
    res.status(201).json(attempt);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

router.get('/weak-areas', async (req, res) => {
  try {
    const attempts = await QuizAttempt.find({ userId: userId(req) }).sort({ createdAt: -1 }).limit(20);
    const bySubject = {};
    attempts.forEach((attempt) => {
      Object.entries(attempt.subjectStats || {}).forEach(([subject, stats]) => {
        bySubject[subject] ||= { total: 0, correct: 0 };
        bySubject[subject].total += stats.total || 0;
        bySubject[subject].correct += stats.correct || 0;
      });
    });
    const weakAreas = Object.entries(bySubject)
      .map(([subject, stats]) => ({
        subject,
        total: stats.total,
        accuracy: stats.total ? (stats.correct / stats.total) * 100 : 0,
      }))
      .filter((area) => area.accuracy < 70)
      .sort((a, b) => a.accuracy - b.accuracy);
    res.json({ weakAreas });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

router.get('/leaderboard', async (_req, res) => {
  try {
    const leaders = await QuizAttempt.aggregate([
      { $group: { _id: '$userId', score: { $sum: '$score' }, accuracy: { $avg: '$accuracy' } } },
      { $sort: { score: -1 } },
      { $limit: 50 },
    ]);
    res.json({ leaders });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

router.get('/settings', async (req, res) => {
  try {
    const settings = await UserFeature.findOneAndUpdate(
      { userId: userId(req) },
      {},
      { new: true, upsert: true }
    );
    res.json(settings);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

router.patch('/settings', async (req, res) => {
  try {
    const settings = await UserFeature.findOneAndUpdate(
      { userId: userId(req) },
      { $set: req.body },
      { new: true, upsert: true }
    );
    res.json(settings);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

module.exports = router;
