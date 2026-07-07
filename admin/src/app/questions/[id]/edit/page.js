'use client';
import { useEffect, useState } from 'react';
import { useParams } from 'next/navigation';
import Sidebar from '@/components/Sidebar';
import AuthGuard from '@/components/AuthGuard';
import QuestionForm from '@/components/QuestionForm';
import { getQuestion, updateQuestion } from '@/lib/api';

export default function EditQuestionPage() {
  const { id } = useParams();
  const [initial, setInitial] = useState(null);
  const [error, setError] = useState('');

  useEffect(() => {
    getQuestion(id)
      .then((q) => setInitial({
        subject: q.subject,
        topic: q.topic,
        question: q.question,
        options: q.options,
        correct: q.correct,
        difficulty: q.difficulty,
        explanation: q.explanation,
        examType: q.examType || 'General',
      }))
      .catch(() => setError('Question not found.'));
  }, [id]);

  return (
    <AuthGuard>
      <div className="layout">
        <Sidebar />
        <div className="main">
          <div className="page-header">
            <h1>Edit Question</h1>
          </div>
          {error && <div className="error-msg">{error}</div>}
          {initial ? (
            <QuestionForm
              initial={initial}
              onSubmit={(body) => updateQuestion(id, body)}
              submitLabel="Save Changes"
            />
          ) : (
            !error && <p style={{ color: '#888' }}>Loading question...</p>
          )}
        </div>
      </div>
    </AuthGuard>
  );
}
