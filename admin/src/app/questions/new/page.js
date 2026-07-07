'use client';
import Sidebar from '@/components/Sidebar';
import AuthGuard from '@/components/AuthGuard';
import QuestionForm from '@/components/QuestionForm';
import { createQuestion } from '@/lib/api';

export default function NewQuestionPage() {
  return (
    <AuthGuard>
      <div className="layout">
        <Sidebar />
        <div className="main">
          <div className="page-header">
            <h1>Add New Question</h1>
          </div>
          <QuestionForm onSubmit={createQuestion} submitLabel="Add Question" />
        </div>
      </div>
    </AuthGuard>
  );
}
