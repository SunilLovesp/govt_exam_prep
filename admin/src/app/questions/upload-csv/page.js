'use client';
import { useState } from 'react';
import Sidebar from '@/components/Sidebar';
import AuthGuard from '@/components/AuthGuard';
import { bulkImport } from '@/lib/api';

const REQUIRED_COLUMNS = [
  'subject',
  'topic',
  'question',
  'optionA',
  'optionB',
  'optionC',
  'optionD',
  'correct',
  'explanation',
];

function parseCsv(text) {
  const rows = [];
  let row = [];
  let cell = '';
  let quoted = false;
  for (let i = 0; i < text.length; i += 1) {
    const char = text[i];
    const next = text[i + 1];
    if (char === '"' && quoted && next === '"') {
      cell += '"';
      i += 1;
    } else if (char === '"') {
      quoted = !quoted;
    } else if (char === ',' && !quoted) {
      row.push(cell.trim());
      cell = '';
    } else if ((char === '\n' || char === '\r') && !quoted) {
      if (char === '\r' && next === '\n') i += 1;
      row.push(cell.trim());
      if (row.some(Boolean)) rows.push(row);
      row = [];
      cell = '';
    } else {
      cell += char;
    }
  }
  row.push(cell.trim());
  if (row.some(Boolean)) rows.push(row);
  return rows;
}

function toQuestions(rows) {
  const headers = rows[0].map((header) => header.trim());
  const missing = REQUIRED_COLUMNS.filter((column) => !headers.includes(column));
  if (missing.length) throw new Error(`Missing columns: ${missing.join(', ')}`);

  return rows.slice(1).map((row) => {
    const item = Object.fromEntries(headers.map((header, i) => [header, row[i] || '']));
    const correctRaw = item.correct.trim().toUpperCase();
    const correct = ['A', 'B', 'C', 'D'].includes(correctRaw)
      ? correctRaw.charCodeAt(0) - 65
      : Number(correctRaw);
    return {
      subject: item.subject,
      topic: item.topic,
      question: item.question,
      options: [item.optionA, item.optionB, item.optionC, item.optionD],
      correct,
      explanation: item.explanation,
      difficulty: item.difficulty || 'medium',
      examType: item.examType || 'General',
      year: item.year ? Number(item.year) : undefined,
      isPremium: ['true', 'yes', '1'].includes((item.isPremium || '').toLowerCase()),
      tags: item.tags ? item.tags.split('|').map((tag) => tag.trim()).filter(Boolean) : [],
    };
  });
}

export default function UploadCsvPage() {
  const [preview, setPreview] = useState([]);
  const [error, setError] = useState('');
  const [status, setStatus] = useState('');
  const [loading, setLoading] = useState(false);

  async function handleFile(file) {
    setError('');
    setStatus('');
    try {
      const text = await file.text();
      const rows = parseCsv(text);
      setPreview(toQuestions(rows));
    } catch (err) {
      setPreview([]);
      setError(err.message || 'Could not parse CSV.');
    }
  }

  async function handleImport() {
    setLoading(true);
    setError('');
    setStatus('');
    try {
      const result = await bulkImport(preview);
      setStatus(`Imported ${result.inserted} questions.`);
    } catch (err) {
      setError(err.response?.data?.error || 'Import failed.');
    } finally {
      setLoading(false);
    }
  }

  return (
    <AuthGuard>
      <div className="layout">
        <Sidebar />
        <div className="main">
          <div className="page-header">
            <h1>Bulk Upload CSV</h1>
          </div>
          <div className="form-card">
            {error && <div className="error-msg" style={{ marginBottom: '16px' }}>{error}</div>}
            {status && <div className="success-msg" style={{ marginBottom: '16px' }}>{status}</div>}
            <p style={{ color: '#666', marginTop: 0 }}>
              Required columns: {REQUIRED_COLUMNS.join(', ')}. Optional: difficulty, examType, year, isPremium, tags. Use | between tags.
            </p>
            <input type="file" accept=".csv,text/csv" onChange={(e) => e.target.files?.[0] && handleFile(e.target.files[0])} />
            {preview.length > 0 && (
              <>
                <h3 style={{ marginTop: '24px' }}>Preview ({preview.length})</h3>
                <div className="card" style={{ overflowX: 'auto' }}>
                  <table>
                    <thead>
                      <tr>
                        <th>Subject</th>
                        <th>Topic</th>
                        <th>Question</th>
                        <th>Difficulty</th>
                        <th>Tags</th>
                      </tr>
                    </thead>
                    <tbody>
                      {preview.slice(0, 10).map((q, i) => (
                        <tr key={i}>
                          <td>{q.subject}</td>
                          <td>{q.topic}</td>
                          <td>{q.question.slice(0, 80)}</td>
                          <td>{q.difficulty}</td>
                          <td>{q.tags.join(', ')}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
                <button className="btn btn-primary" disabled={loading} onClick={handleImport} style={{ marginTop: '16px' }}>
                  {loading ? 'Importing...' : 'Import Questions'}
                </button>
              </>
            )}
          </div>
        </div>
      </div>
    </AuthGuard>
  );
}
