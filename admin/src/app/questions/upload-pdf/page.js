'use client';
import { useState, useRef } from 'react';
import { useRouter } from 'next/navigation';
import Sidebar from '@/components/Sidebar';
import AuthGuard from '@/components/AuthGuard';
import { parsePdf, bulkImport } from '@/lib/api';

const SUBJECTS = ['Quantitative Aptitude', 'Reasoning', 'English', 'General Awareness', 'Computer Knowledge', 'Current Affairs'];
const EXAM_TYPES = ['General', 'SSC', 'UPSC', 'Banking', 'Railways', 'State PSC', 'Teaching', 'Army'];
const OPTION_LABELS = ['A', 'B', 'C', 'D'];

export default function UploadPdfPage() {
  const router = useRouter();
  const fileRef = useRef();
  const [dragging, setDragging] = useState(false);
  const [file, setFile] = useState(null);
  const [parsing, setParsing] = useState(false);
  const [parsed, setParsed] = useState(null); // { questions, pageCount }
  const [questions, setQuestions] = useState([]); // editable list
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  function handleFile(f) {
    if (!f || f.type !== 'application/pdf') {
      setError('Please select a valid PDF file.');
      return;
    }
    setFile(f);
    setError('');
    setParsed(null);
    setQuestions([]);
  }

  async function handleParse() {
    if (!file) return;
    setError('');
    setParsing(true);
    try {
      const result = await parsePdf(file);
      setParsed(result);
      // Add default fields for each extracted question
      setQuestions(
        result.questions.map((q, idx) => ({
          ...q,
          _id: idx,
          subject: q.subject || 'General Awareness',
          topic: q.topic || '',
          difficulty: q.difficulty || 'medium',
          examType: q.examType || 'General',
          selected: true,
        }))
      );
    } catch (err) {
      setError(err.response?.data?.error || 'Failed to parse PDF. Make sure the backend is running.');
    } finally {
      setParsing(false);
    }
  }

  function updateQuestion(idx, key, value) {
    setQuestions((prev) => prev.map((q) => (q._id === idx ? { ...q, [key]: value } : q)));
  }

  function updateOption(idx, optIdx, value) {
    setQuestions((prev) =>
      prev.map((q) => {
        if (q._id !== idx) return q;
        const options = [...q.options];
        options[optIdx] = value;
        return { ...q, options };
      })
    );
  }

  function toggleSelect(idx) {
    setQuestions((prev) => prev.map((q) => (q._id === idx ? { ...q, selected: !q.selected } : q)));
  }

  async function handleSave() {
    const toSave = questions
      .filter((q) => q.selected)
      .map(({ _id, selected, _isHindi, ...q }) => q);

    if (toSave.length === 0) {
      setError('Select at least one question to save.');
      return;
    }

    setSaving(true);
    setError('');
    try {
      const result = await bulkImport(toSave);
      setSuccess(`✓ ${result.inserted} questions saved successfully!`);
      setTimeout(() => router.push('/questions'), 2000);
    } catch (err) {
      setError(err.response?.data?.error || 'Failed to save questions.');
    } finally {
      setSaving(false);
    }
  }

  const selectedCount = questions.filter((q) => q.selected).length;

  return (
    <AuthGuard>
      <div className="layout">
        <Sidebar />
        <div className="main">
          <div className="page-header">
            <h1>Upload PDF</h1>
            <span style={{ fontSize: '13px', color: '#888' }}>
              Supports Unicode Hindi (Mangal, Noto) &amp; English PDFs
            </span>
          </div>

          {error && <div className="error-msg" style={{ marginBottom: '16px' }}>{error}</div>}
          {success && (
            <div style={{ background: '#e8f5e9', color: '#2e7d32', padding: '12px 16px', borderRadius: '8px', marginBottom: '16px', fontWeight: 600 }}>
              {success}
            </div>
          )}

          {/* Step 1 — Drop zone */}
          {!parsed && (
            <div className="card" style={{ padding: '24px', marginBottom: '24px' }}>
              <h2 style={{ fontSize: '15px', marginBottom: '16px' }}>Step 1 — Select PDF</h2>
              <div
                className={`dropzone ${dragging ? 'drag' : ''}`}
                onClick={() => fileRef.current.click()}
                onDragOver={(e) => { e.preventDefault(); setDragging(true); }}
                onDragLeave={() => setDragging(false)}
                onDrop={(e) => { e.preventDefault(); setDragging(false); handleFile(e.dataTransfer.files[0]); }}
              >
                <div style={{ fontSize: '40px' }}>📄</div>
                <p style={{ fontWeight: 600, color: '#333', marginTop: '8px' }}>
                  {file ? file.name : 'Click or drag a PDF file here'}
                </p>
                <p>Max 20 MB · Hindi &amp; English supported</p>
                <input ref={fileRef} type="file" accept=".pdf" style={{ display: 'none' }} onChange={(e) => handleFile(e.target.files[0])} />
              </div>
              {file && (
                <button
                  className="btn btn-primary"
                  style={{ marginTop: '16px' }}
                  onClick={handleParse}
                  disabled={parsing}
                >
                  {parsing ? '⏳ Extracting questions...' : '🔍 Extract Questions'}
                </button>
              )}
            </div>
          )}

          {/* Step 2 — Review extracted questions */}
          {parsed && questions.length === 0 && (
            <div className="card" style={{ padding: '32px' }}>
              <div style={{ textAlign: 'center' }}>
                <div style={{ fontSize: '40px' }}>😕</div>
                <p style={{ marginTop: '8px', color: '#666' }}>
                  No questions could be automatically detected in this PDF.
                </p>
                <p style={{ fontSize: '13px', color: '#999', marginTop: '4px' }}>
                  The PDF may use scanned images (needs OCR), an unsupported layout, or legacy
                  Kundli/Kruti Dev encoding. Try adding questions manually.
                </p>
                <button className="btn btn-secondary" style={{ marginTop: '16px' }} onClick={() => setParsed(null)}>
                  Try Another PDF
                </button>
              </div>
              {parsed.rawTextPreview && (
                <div style={{ marginTop: '24px' }}>
                  <p style={{ fontSize: '12px', fontWeight: 600, color: '#888', marginBottom: '6px' }}>
                    Raw text extracted from PDF (first 1000 chars) — use this to check if text extraction worked:
                  </p>
                  <pre style={{ background: '#f5f5f5', padding: '12px', borderRadius: '6px', fontSize: '11px', overflowX: 'auto', whiteSpace: 'pre-wrap', wordBreak: 'break-word', color: '#333', maxHeight: '240px', overflowY: 'auto' }}>
                    {parsed.rawTextPreview || '(empty — PDF may be scanned/image-based)'}
                  </pre>
                </div>
              )}
            </div>
          )}

          {parsed && questions.length > 0 && (
            <>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '16px', flexWrap: 'wrap', gap: '10px' }}>
                <div>
                  <span style={{ fontWeight: 600 }}>{questions.length} questions extracted</span>
                  <span style={{ color: '#888', marginLeft: '12px', fontSize: '13px' }}>
                    {selectedCount} selected · {parsed.pageCount} pages
                  </span>
                </div>
                <div style={{ display: 'flex', gap: '10px' }}>
                  <button className="btn btn-secondary btn-sm" onClick={() => setParsed(null)}>
                    ← Try Another PDF
                  </button>
                  <button
                    className="btn btn-primary"
                    onClick={handleSave}
                    disabled={saving || selectedCount === 0}
                  >
                    {saving ? 'Saving...' : `Save ${selectedCount} Questions`}
                  </button>
                </div>
              </div>

              {questions.map((q, idx) => (
                <div key={q._id} className="preview-row" style={{ opacity: q.selected ? 1 : 0.4 }}>
                  {/* Header: question number + checkbox + subject */}
                  <div style={{ display: 'flex', gap: '12px', alignItems: 'flex-start', marginBottom: '10px' }}>
                    <input
                      type="checkbox"
                      checked={q.selected}
                      onChange={() => toggleSelect(q._id)}
                      style={{ marginTop: '3px', cursor: 'pointer', width: '16px', height: '16px' }}
                    />
                    <div style={{ flex: 1 }}>
                      <div style={{ display: 'flex', gap: '10px', marginBottom: '8px', flexWrap: 'wrap' }}>
                        <select
                          value={q.subject}
                          onChange={(e) => updateQuestion(q._id, 'subject', e.target.value)}
                          style={{ padding: '4px 8px', border: '1px solid #ddd', borderRadius: '6px', fontSize: '12px' }}
                        >
                          {SUBJECTS.map((s) => <option key={s}>{s}</option>)}
                        </select>
                        <input
                          type="text"
                          value={q.topic}
                          onChange={(e) => updateQuestion(q._id, 'topic', e.target.value)}
                          placeholder="Topic"
                          style={{ padding: '4px 8px', border: '1px solid #ddd', borderRadius: '6px', fontSize: '12px', width: '140px' }}
                        />
                        <select
                          value={q.difficulty}
                          onChange={(e) => updateQuestion(q._id, 'difficulty', e.target.value)}
                          style={{ padding: '4px 8px', border: '1px solid #ddd', borderRadius: '6px', fontSize: '12px' }}
                        >
                          <option value="easy">Easy</option>
                          <option value="medium">Medium</option>
                          <option value="hard">Hard</option>
                        </select>
                        <select
                          value={q.examType}
                          onChange={(e) => updateQuestion(q._id, 'examType', e.target.value)}
                          style={{ padding: '4px 8px', border: '1px solid #ddd', borderRadius: '6px', fontSize: '12px' }}
                        >
                          {EXAM_TYPES.map((t) => <option key={t}>{t}</option>)}
                        </select>
                      </div>

                      {/* Question text */}
                      <textarea
                        className={q._isHindi ? 'hindi' : ''}
                        value={q.question}
                        onChange={(e) => updateQuestion(q._id, 'question', e.target.value)}
                        rows={2}
                        style={{ width: '100%', padding: '8px', border: '1px solid #eee', borderRadius: '6px', fontSize: '14px', marginBottom: '8px', fontFamily: 'inherit' }}
                      />

                      {/* Options */}
                      <div className="preview-options">
                        {q.options.map((opt, oi) => (
                          <div key={oi} style={{ display: 'flex', gap: '6px', alignItems: 'center' }}>
                            <input
                              type="radio"
                              name={`correct-${q._id}`}
                              checked={q.correct === oi}
                              onChange={() => updateQuestion(q._id, 'correct', oi)}
                              title="Mark as correct"
                            />
                            <span style={{ minWidth: '18px', fontWeight: 700, color: '#555' }}>{OPTION_LABELS[oi]}.</span>
                            <input
                              type="text"
                              className={`preview-option ${q.correct === oi ? 'correct' : ''} ${q._isHindi ? 'hindi' : ''}`}
                              value={opt}
                              onChange={(e) => updateOption(q._id, oi, e.target.value)}
                              style={{ flex: 1, border: '1px solid #eee', borderRadius: '6px', padding: '4px 8px', fontFamily: 'inherit' }}
                            />
                          </div>
                        ))}
                      </div>

                      {/* Explanation */}
                      <div style={{ marginTop: '8px' }}>
                        <input
                          type="text"
                          className={q._isHindi ? 'hindi' : ''}
                          value={q.explanation}
                          onChange={(e) => updateQuestion(q._id, 'explanation', e.target.value)}
                          placeholder="Explanation (optional, add before saving)"
                          style={{ width: '100%', padding: '6px 10px', border: '1px solid #eee', borderRadius: '6px', fontSize: '13px', color: '#666', fontFamily: 'inherit' }}
                        />
                      </div>
                    </div>
                  </div>
                </div>
              ))}

              <div style={{ marginTop: '20px', display: 'flex', justifyContent: 'flex-end' }}>
                <button
                  className="btn btn-primary"
                  onClick={handleSave}
                  disabled={saving || selectedCount === 0}
                >
                  {saving ? 'Saving...' : `Save ${selectedCount} Questions`}
                </button>
              </div>
            </>
          )}
        </div>
      </div>
    </AuthGuard>
  );
}
