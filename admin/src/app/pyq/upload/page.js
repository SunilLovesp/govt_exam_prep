'use client';
import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import Sidebar from '@/components/Sidebar';
import { isLoggedIn, uploadPYQPaper } from '@/lib/api';

const EXAMS = [
  { id: 'ssc_cgl', name: 'SSC CGL' },
  { id: 'ssc_chsl', name: 'SSC CHSL' },
  { id: 'ssc_mts', name: 'SSC MTS' },
  { id: 'ssc_gd', name: 'SSC GD' },
  { id: 'upsc_cse', name: 'UPSC CSE (Prelims)' },
  { id: 'upsc_nda', name: 'UPSC NDA' },
  { id: 'ibps_po', name: 'IBPS PO' },
  { id: 'ibps_clerk', name: 'IBPS Clerk' },
  { id: 'sbi_po', name: 'SBI PO' },
  { id: 'sbi_clerk', name: 'SBI Clerk' },
  { id: 'rrb_ntpc', name: 'RRB NTPC' },
  { id: 'rrb_group_d', name: 'RRB Group D' },
  { id: 'rrb_alp', name: 'RRB ALP' },
  { id: 'uppsc', name: 'UPPSC PCS' },
  { id: 'mppsc', name: 'MPPSC' },
  { id: 'bpsc', name: 'BPSC' },
  { id: 'rpsc', name: 'RPSC RAS' },
  { id: 'ctet', name: 'CTET' },
  { id: 'kvs', name: 'KVS' },
];

const currentYear = new Date().getFullYear();
const YEARS = Array.from({ length: 15 }, (_, i) => currentYear - i);

export default function UploadPYQPage() {
  const router = useRouter();
  const [form, setForm] = useState({
    examId: EXAMS[0].id,
    year: String(currentYear),
    title: '',
  });
  const [file, setFile] = useState(null);
  const [uploading, setUploading] = useState(false);
  const [progress, setProgress] = useState('');

  useEffect(() => {
    if (!isLoggedIn()) router.push('/login');
  }, []);

  function handleExamChange(e) {
    const examId = e.target.value;
    const examName = EXAMS.find((x) => x.id === examId)?.name || '';
    const year = form.year;
    setForm((f) => ({ ...f, examId, title: `${examName} ${year}` }));
  }

  function handleYearChange(e) {
    const year = e.target.value;
    const examName = EXAMS.find((x) => x.id === form.examId)?.name || '';
    setForm((f) => ({ ...f, year, title: `${examName} ${year}` }));
  }

  async function handleSubmit(e) {
    e.preventDefault();
    if (!file) return alert('Please select a PDF file.');
    const examName = EXAMS.find((x) => x.id === form.examId)?.name || form.examId;
    setUploading(true);
    setProgress('Uploading…');
    try {
      await uploadPYQPaper({
        file,
        examId: form.examId,
        examName,
        year: Number(form.year),
        title: form.title.trim(),
      });
      setProgress('');
      alert('Paper uploaded successfully!');
      router.push('/pyq');
    } catch (err) {
      alert('Upload failed: ' + (err.response?.data?.error || err.message));
      setProgress('');
    } finally {
      setUploading(false);
    }
  }

  return (
    <div className="layout">
      <Sidebar />
      <main className="main">
        <h2>+ Upload Previous Year Paper</h2>
        <form onSubmit={handleSubmit} style={{ maxWidth: '540px' }}>
          <div className="form-group">
            <label>Exam</label>
            <select value={form.examId} onChange={handleExamChange} required>
              {EXAMS.map((e) => (
                <option key={e.id} value={e.id}>{e.name}</option>
              ))}
            </select>
          </div>

          <div className="form-group">
            <label>Year</label>
            <select value={form.year} onChange={handleYearChange} required>
              {YEARS.map((y) => (
                <option key={y} value={String(y)}>{y}</option>
              ))}
            </select>
          </div>

          <div className="form-group">
            <label>Title <span style={{ color: '#999', fontSize: '12px' }}>(e.g. "SSC CGL 2023 Tier-I Shift 1")</span></label>
            <input
              type="text"
              value={form.title}
              onChange={(e) => setForm((f) => ({ ...f, title: e.target.value }))}
              placeholder="Paper title"
              required
            />
          </div>

          <div className="form-group">
            <label>PDF File</label>
            <input
              type="file"
              accept="application/pdf"
              onChange={(e) => setFile(e.target.files[0])}
              required
            />
            {file && (
              <div style={{ marginTop: '6px', fontSize: '13px', color: '#555' }}>
                {file.name} ({(file.size / 1024 / 1024).toFixed(1)} MB)
              </div>
            )}
          </div>

          <div style={{ display: 'flex', gap: '12px', marginTop: '8px' }}>
            <button type="submit" className="btn-primary" disabled={uploading}>
              {uploading ? progress || 'Uploading…' : 'Upload Paper'}
            </button>
            <button type="button" onClick={() => router.push('/pyq')} style={{ padding: '10px 20px', borderRadius: '8px', border: '1px solid #ddd', background: 'white', cursor: 'pointer' }}>
              Cancel
            </button>
          </div>
        </form>
      </main>
    </div>
  );
}
