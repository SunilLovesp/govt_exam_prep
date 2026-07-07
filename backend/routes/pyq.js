const express = require('express');
const router = express.Router();
const multer = require('multer');
const { S3Client, PutObjectCommand, GetObjectCommand, DeleteObjectCommand } = require('@aws-sdk/client-s3');
const PYQPaper = require('../models/PYQPaper');
const auth = require('../middleware/auth');

const s3Config = {
  region: process.env.AWS_REGION || 'ap-south-1',
};

if (process.env.AWS_ACCESS_KEY_ID && process.env.AWS_SECRET_ACCESS_KEY) {
  s3Config.credentials = {
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
  };
}

const s3 = new S3Client(s3Config);

const BUCKET = process.env.AWS_S3_BUCKET;

// Store file in memory before uploading to S3
const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 50 * 1024 * 1024 }, // 50 MB
  fileFilter: (req, file, cb) => {
    if (file.mimetype === 'application/pdf') cb(null, true);
    else cb(new Error('Only PDF files are allowed.'));
  },
});

// GET /api/pyq — list all papers, optionally filter by examId
router.get('/', async (req, res) => {
  try {
    const filter = {};
    if (req.query.examId) filter.examId = req.query.examId;
    const papers = await PYQPaper.find(filter).sort({ year: -1, examName: 1 });
    res.json({ papers });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST /api/pyq — upload PDF + metadata (auth required)
router.post('/', auth, upload.single('pdf'), async (req, res) => {
  try {
    if (!req.file) return res.status(400).json({ error: 'No PDF file uploaded.' });
    if (!BUCKET) return res.status(500).json({ error: 'AWS_S3_BUCKET is not configured.' });
    const { examId, examName, year, title } = req.body;
    if (!examId || !examName || !year || !title) {
      return res.status(400).json({ error: 'examId, examName, year, and title are required.' });
    }

    const s3Key = `pyq/${Date.now()}-${Math.random().toString(36).slice(2)}.pdf`;
    await s3.send(new PutObjectCommand({
      Bucket: BUCKET,
      Key: s3Key,
      Body: req.file.buffer,
      ContentType: 'application/pdf',
    }));

    const paper = new PYQPaper({
      examId,
      examName,
      year: Number(year),
      title,
      fileName: s3Key,       // stores the S3 key
      originalName: req.file.originalname,
      fileSize: req.file.size,
    });
    await paper.save();
    res.status(201).json(paper);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// GET /api/pyq/:id/file — stream PDF from S3 to client
router.get('/:id/file', async (req, res) => {
  try {
    const paper = await PYQPaper.findById(req.params.id);
    if (!paper) return res.status(404).json({ error: 'Paper not found.' });
    if (!BUCKET) return res.status(500).json({ error: 'AWS_S3_BUCKET is not configured.' });

    const s3Response = await s3.send(
      new GetObjectCommand({ Bucket: BUCKET, Key: paper.fileName })
    );

    res.setHeader('Content-Type', 'application/pdf');
    res.setHeader(
      'Content-Disposition',
      `inline; filename="${encodeURIComponent(paper.originalName || paper.fileName)}"`
    );
    if (paper.fileSize) res.setHeader('Content-Length', paper.fileSize);
    s3Response.Body.pipe(res);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// DELETE /api/pyq/:id — delete from S3 and DB (auth required)
router.delete('/:id', auth, async (req, res) => {
  try {
    const paper = await PYQPaper.findByIdAndDelete(req.params.id);
    if (!paper) return res.status(404).json({ error: 'Paper not found.' });
    if (!BUCKET) return res.status(500).json({ error: 'AWS_S3_BUCKET is not configured.' });

    await s3.send(new DeleteObjectCommand({ Bucket: BUCKET, Key: paper.fileName }));
    res.json({ message: 'Paper deleted successfully.' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
