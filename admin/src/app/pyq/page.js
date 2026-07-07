'use client';
import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import Sidebar from '@/components/Sidebar';
import { isLoggedIn, getPYQPapers, deletePYQPaper, getPYQFileUrl } from '@/lib/api';

const EXAMS = [
  { id: 'all', name: 'All Exams' },
  { id: 'ssc_cgl', name: 'SSC CGL' },
  { id: 'ssc_chsl', name: 'SSC CHSL' },
  { id: 'ssc_mts', name: 'SSC MTS' },
  { id: 'upsc_cse', name: 'UPSC CSE' },
  { id: 'upsc_nda', name: 'UPSC NDA' },
  { id: 'ibps_po', name: 'IBPS PO' },
  { id: 'sbi_po', name: 'SBI PO' },
  { id: 'rrb_ntpc', name: 'RRB NTPC' },
  { id: 'rrb_group_d', name: 'RRB Group D' },
  { id: 'uppsc', name: 'UPPSC PCS' },
  { id: 'ctet', name: 'CTET' },
];

export default function PYQListPage() {
  const router = useRouter();
  const [papers, setPapers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedExam, setSelectedExam] = useState('all');
  const [deleting, setDeleting] = useState(null);

  useEffect(() => {
    if (!isLoggedIn()) { router.push('/login'); return; }
    fetchPapers();
  }, [selectedExam]);

  async function fetchPapers() {
    setLoading(true);
    try {
      const examId = selectedExam === 'all' ? undefined : selectedExam;
      const { papers } = await getPYQPapers(examId);
      setPapers(papers);
    } catch {
      alert('Failed to load papers.');
    } finally {
      setLoading(false);
    }
  }

  async function handleDelete(id, title) {
    if (!confirm(`Delete "${title}"?`)) return;
    setDeleting(id);
    try {
      await deletePYQPaper(id);
      setPapers((prev) => prev.filter((p) => p._id !== id));
    } catch {
      alert('Delete failed.');
    } finally {
      setDeleting(null);
    }
  }

  // Group papers by examName then year
  const grouped = papers.reduce((acc, p) => {
    if (!acc[p.examName]) acc[p.examName] = {};
    if (!acc[p.examName][p.year]) acc[p.examName][p.year] = [];
    acc[p.examName][p.year].push(p);
    return acc;
  }, {});

  function formatSize(bytes) {
    if (!bytes) return '';
    if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(0)} KB`;
    return `${(bytes / 1024 / 1024).toFixed(1)} MB`;
  }

  return (
    <div className="layout">
      <Sidebar />
      <main className="main">
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '24px' }}>
          <h2 style={{ margin: 0 }}>📋 Previous Year Papers</h2>
          <button className="btn-primary" onClick={() => router.push('/pyq/upload')}>+ Upload Paper</button>
        </div>

        {/* Exam filter */}
        <div style={{ marginBottom: '20px', display: 'flex', gap: '8px', flexWrap: 'wrap' }}>
          {EXAMS.map((e) => (
            <button
              key={e.id}
              onClick={() => setSelectedExam(e.id)}
              style={{
                padding: '6px 14px',
                borderRadius: '20px',
                border: '1px solid',
                borderColor: selectedExam === e.id ? '#1a237e' : '#ddd',
                background: selectedExam === e.id ? '#1a237e' : 'white',
                color: selectedExam === e.id ? 'white' : '#333',
                cursor: 'pointer',
                fontSize: '13px',
              }}
            >
              {e.name}
            </button>
          ))}
        </div>

        {loading ? (
          <p>Loading…</p>
        ) : papers.length === 0 ? (
          <div style={{ textAlign: 'center', padding: '60px', color: '#666' }}>
            <p style={{ fontSize: '48px' }}>📄</p>
            <p>No papers uploaded yet.</p>
            <button className="btn-primary" onClick={() => router.push('/pyq/upload')}>Upload First Paper</button>
          </div>
        ) : (
          Object.entries(grouped).map(([examName, years]) => (
            <div key={examName} style={{ marginBottom: '28px' }}>
              <h3 style={{ margin: '0 0 12px', color: '#1a237e', borderBottom: '2px solid #e8eaf6', paddingBottom: '6px' }}>
                {examName}
              </h3>
              {Object.entries(years)
                .sort(([a], [b]) => Number(b) - Number(a))
                .map(([year, yearPapers]) => (
                  <div key={year} style={{ marginBottom: '12px' }}>
                    <div style={{ fontSize: '13px', fontWeight: 600, color: '#555', marginBottom: '6px' }}>{year}</div>
                    {yearPapers.map((paper) => (
                      <div
                        key={paper._id}
                        style={{
                          display: 'flex',
                          alignItems: 'center',
                          gap: '12px',
                          padding: '12px 16px',
                          background: 'white',
                          borderRadius: '10px',
                          marginBottom: '8px',
                          boxShadow: '0 1px 4px rgba(0,0,0,0.08)',
                        }}
                      >
                        <span style={{ fontSize: '20px' }}>📄</span>
                        <div style={{ flex: 1 }}>
                          <div style={{ fontWeight: 600 }}>{paper.title}</div>
                          <div style={{ fontSize: '12px', color: '#777' }}>{formatSize(paper.fileSize)}</div>
                        </div>
                        <a
                          href={getPYQFileUrl(paper._id)}
                          target="_blank"
                          rel="noreferrer"
                          style={{ padding: '6px 14px', background: '#e8eaf6', borderRadius: '8px', color: '#1a237e', fontSize: '13px', textDecoration: 'none' }}
                        >
                          View
                        </a>
                        <button
                          onClick={() => handleDelete(paper._id, paper.title)}
                          disabled={deleting === paper._id}
                          style={{ padding: '6px 14px', background: '#ffebee', borderRadius: '8px', color: '#c62828', fontSize: '13px', border: 'none', cursor: 'pointer' }}
                        >
                          {deleting === paper._id ? '…' : 'Delete'}
                        </button>
                      </div>
                    ))}
                  </div>
                ))}
            </div>
          ))
        )}
      </main>
    </div>
  );
}
