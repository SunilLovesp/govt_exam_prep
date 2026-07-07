'use client';
import { useEffect, useState, useCallback } from 'react';
import Link from 'next/link';
import Sidebar from '@/components/Sidebar';
import AuthGuard from '@/components/AuthGuard';
import { getQuestions, deleteQuestion } from '@/lib/api';

const SUBJECTS = ['', 'Quantitative Aptitude', 'Reasoning', 'English', 'General Awareness', 'Computer Knowledge', 'Current Affairs'];
const DIFFICULTIES = ['', 'easy', 'medium', 'hard'];

export default function QuestionsPage() {
  const [questions, setQuestions] = useState([]);
  const [total, setTotal] = useState(0);
  const [search, setSearch] = useState('');
  const [subject, setSubject] = useState('');
  const [difficulty, setDifficulty] = useState('');
  const [loading, setLoading] = useState(true);

  const fetchQuestions = useCallback(async () => {
    setLoading(true);
    try {
      const params = {};
      if (subject) params.subject = subject;
      if (difficulty) params.difficulty = difficulty;
      const data = await getQuestions(params);
      setQuestions(data.questions);
      setTotal(data.total);
    } catch {
      // ignore
    } finally {
      setLoading(false);
    }
  }, [subject, difficulty]);

  useEffect(() => { fetchQuestions(); }, [fetchQuestions]);

  async function handleDelete(id, questionText) {
    if (!confirm(`Delete question?\n\n"${questionText.slice(0, 80)}..."`)) return;
    try {
      await deleteQuestion(id);
      setQuestions((prev) => prev.filter((q) => q._id !== id));
      setTotal((t) => t - 1);
    } catch {
      alert('Failed to delete question.');
    }
  }

  const filtered = search
    ? questions.filter(
        (q) =>
          q.question.toLowerCase().includes(search.toLowerCase()) ||
          q.topic.toLowerCase().includes(search.toLowerCase())
      )
    : questions;

  return (
    <AuthGuard>
      <div className="layout">
        <Sidebar />
        <div className="main">
          <div className="page-header">
            <h1>Questions ({total})</h1>
            <Link href="/questions/new">
              <button className="btn btn-primary">+ Add Question</button>
            </Link>
          </div>

          <div className="toolbar">
            <input
              type="text"
              placeholder="Search by question or topic..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
            />
            <select value={subject} onChange={(e) => setSubject(e.target.value)}>
              {SUBJECTS.map((s) => <option key={s} value={s}>{s || 'All Subjects'}</option>)}
            </select>
            <select value={difficulty} onChange={(e) => setDifficulty(e.target.value)}>
              {DIFFICULTIES.map((d) => <option key={d} value={d}>{d || 'All Difficulties'}</option>)}
            </select>
          </div>

          <div className="card">
            <table>
              <thead>
                <tr>
                  <th>Subject</th>
                  <th>Topic</th>
                  <th>Question</th>
                  <th>Difficulty</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {loading ? (
                  <tr><td colSpan={5} style={{ textAlign: 'center', color: '#888', padding: '40px' }}>Loading...</td></tr>
                ) : filtered.length === 0 ? (
                  <tr><td colSpan={5} style={{ textAlign: 'center', color: '#888', padding: '40px' }}>No questions found.</td></tr>
                ) : (
                  filtered.map((q) => (
                    <tr key={q._id}>
                      <td style={{ whiteSpace: 'nowrap' }}>{q.subject}</td>
                      <td style={{ whiteSpace: 'nowrap' }}>{q.topic}</td>
                      <td style={{ maxWidth: '380px' }}>
                        <span title={q.question}>{q.question.length > 80 ? q.question.slice(0, 80) + '…' : q.question}</span>
                      </td>
                      <td>
                        <span className={`badge badge-${q.difficulty}`}>{q.difficulty}</span>
                      </td>
                      <td style={{ whiteSpace: 'nowrap' }}>
                        <Link href={`/questions/${q._id}/edit`}>
                          <button className="btn btn-secondary btn-sm" style={{ marginRight: '8px' }}>Edit</button>
                        </Link>
                        <button className="btn btn-danger btn-sm" onClick={() => handleDelete(q._id, q.question)}>Delete</button>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </AuthGuard>
  );
}
