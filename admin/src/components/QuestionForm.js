'use client';
import { useState } from 'react';
import { useRouter } from 'next/navigation';

const SUBJECTS = ['Quantitative Aptitude', 'Reasoning', 'English', 'General Awareness', 'Computer Knowledge', 'Current Affairs'];
const EXAM_TYPES = ['General', 'SSC', 'UPSC', 'Banking', 'Railways', 'State PSC', 'Teaching', 'Army'];
const OPTION_LABELS = ['A', 'B', 'C', 'D'];

const EMPTY_FORM = {
  subject: 'Quantitative Aptitude',
  topic: '',
  topicHi: '',
  question: '',
  questionHi: '',
  options: ['', '', '', ''],
  optionsHi: ['', '', '', ''],
  correct: 0,
  difficulty: 'medium',
  explanation: '',
  explanationHi: '',
  examType: 'General',
  year: '',
  isPremium: false,
  tags: [],
};

export default function QuestionForm({ initial, onSubmit, submitLabel = 'Save Question' }) {
  const router = useRouter();
  const [form, setForm] = useState(() => ({
    ...EMPTY_FORM,
    ...initial,
    options: initial?.options?.length === 4 ? initial.options : ['', '', '', ''],
    optionsHi: initial?.optionsHi?.length === 4 ? initial.optionsHi : ['', '', '', ''],
  }));
  const [lang, setLang] = useState('en'); // 'en' | 'hi'
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  function set(key, value) {
    setForm((prev) => ({ ...prev, [key]: value }));
  }

  function setOption(i, value, isHindi = false) {
    const key = isHindi ? 'optionsHi' : 'options';
    const opts = [...form[key]];
    opts[i] = value;
    setForm((prev) => ({ ...prev, [key]: opts }));
  }

  async function handleSubmit(e) {
    e.preventDefault();
    setError('');
    if (form.options.some((o) => !o.trim())) {
      setError('All 4 English options must be filled in.');
      return;
    }
    setLoading(true);
    try {
      await onSubmit(form);
      router.push('/questions');
    } catch (err) {
      setError(err.response?.data?.error || 'Failed to save question.');
    } finally {
      setLoading(false);
    }
  }

  const isHindi = lang === 'hi';

  return (
    <form onSubmit={handleSubmit} className="form-card">
      {error && <div className="error-msg" style={{ marginBottom: '20px' }}>{error}</div>}

      {/* Language tab toggle */}
      <div className="lang-tabs">
        <button type="button" className={`lang-tab ${!isHindi ? 'active' : ''}`} onClick={() => setLang('en')}>
          English
        </button>
        <button type="button" className={`lang-tab ${isHindi ? 'active' : ''}`} onClick={() => setLang('hi')}>
          हिन्दी (Hindi)
        </button>
        {isHindi && (
          <span style={{ alignSelf: 'center', fontSize: '12px', color: '#888' }}>
            Hindi fields are optional
          </span>
        )}
      </div>

      {/* Subject / Topic / Difficulty / Exam Type — always shown */}
      <div className="form-row">
        <div className="form-group">
          <label>Subject *</label>
          <select value={form.subject} onChange={(e) => set('subject', e.target.value)} required>
            {SUBJECTS.map((s) => <option key={s}>{s}</option>)}
          </select>
        </div>
        <div className="form-group">
          <label>{isHindi ? 'Topic (हिन्दी)' : 'Topic *'}</label>
          {isHindi ? (
            <input
              type="text"
              className="hindi"
              value={form.topicHi}
              onChange={(e) => set('topicHi', e.target.value)}
              placeholder="विषय का नाम"
            />
          ) : (
            <input type="text" value={form.topic} onChange={(e) => set('topic', e.target.value)} placeholder="e.g. Percentage" required />
          )}
        </div>
      </div>

      <div className="form-row">
        <div className="form-group">
          <label>Year</label>
          <input
            type="number"
            value={form.year}
            onChange={(e) => set('year', e.target.value)}
            placeholder="e.g. 2025"
          />
        </div>
        <div className="form-group">
          <label>Tags</label>
          <input
            type="text"
            value={(form.tags || []).join(', ')}
            onChange={(e) => set('tags', e.target.value.split(',').map((tag) => tag.trim()).filter(Boolean))}
            placeholder="algebra, pyq, tier-1"
          />
        </div>
      </div>

      <label className="checkbox-row" style={{ marginBottom: '20px' }}>
        <input
          type="checkbox"
          checked={form.isPremium}
          onChange={(e) => set('isPremium', e.target.checked)}
        />
        Premium question
      </label>

      <div className="form-row">
        <div className="form-group">
          <label>Difficulty *</label>
          <select value={form.difficulty} onChange={(e) => set('difficulty', e.target.value)}>
            <option value="easy">Easy / आसान</option>
            <option value="medium">Medium / मध्यम</option>
            <option value="hard">Hard / कठिन</option>
          </select>
        </div>
        <div className="form-group">
          <label>Exam Type</label>
          <select value={form.examType} onChange={(e) => set('examType', e.target.value)}>
            {EXAM_TYPES.map((t) => <option key={t}>{t}</option>)}
          </select>
        </div>
      </div>

      {/* Question text */}
      <div className="form-group">
        <label>{isHindi ? 'Question (हिन्दी) — प्रश्न' : 'Question *'}</label>
        {isHindi ? (
          <textarea
            className="hindi"
            value={form.questionHi}
            onChange={(e) => set('questionHi', e.target.value)}
            placeholder="यहाँ प्रश्न लिखें..."
            rows={3}
          />
        ) : (
          <textarea
            value={form.question}
            onChange={(e) => set('question', e.target.value)}
            placeholder="Type the full question here..."
            rows={3}
            required
          />
        )}
      </div>

      {/* Options */}
      <div className="form-group">
        <label>{isHindi ? 'Options (हिन्दी) — विकल्प' : 'Options (A–D) *'}</label>
        <div className="options-grid">
          {OPTION_LABELS.map((label, i) => (
            isHindi ? (
              <input
                key={i}
                type="text"
                className="hindi"
                value={form.optionsHi[i]}
                onChange={(e) => setOption(i, e.target.value, true)}
                placeholder={`विकल्प ${label}`}
                style={{ marginBottom: '10px' }}
              />
            ) : (
              <input
                key={i}
                type="text"
                value={form.options[i]}
                onChange={(e) => setOption(i, e.target.value, false)}
                placeholder={`Option ${label}`}
                required
                style={{ marginBottom: '10px' }}
              />
            )
          ))}
        </div>
      </div>

      {/* Correct answer — only on English tab */}
      {!isHindi && (
        <div className="form-group">
          <label>Correct Answer *</label>
          <div className="correct-options">
            {OPTION_LABELS.map((label, i) => (
              <div className="correct-option" key={i}>
                <input
                  type="radio"
                  id={`correct-${i}`}
                  name="correct"
                  checked={form.correct === i}
                  onChange={() => set('correct', i)}
                />
                <label htmlFor={`correct-${i}`}>{label}</label>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Explanation */}
      <div className="form-group">
        <label>{isHindi ? 'Explanation (हिन्दी) — व्याख्या' : 'Explanation *'}</label>
        {isHindi ? (
          <textarea
            className="hindi"
            value={form.explanationHi}
            onChange={(e) => set('explanationHi', e.target.value)}
            placeholder="सही उत्तर की व्याख्या करें..."
            rows={3}
          />
        ) : (
          <textarea
            value={form.explanation}
            onChange={(e) => set('explanation', e.target.value)}
            placeholder="Explain why the correct answer is right..."
            rows={3}
            required
          />
        )}
      </div>

      <div style={{ display: 'flex', gap: '12px', marginTop: '8px' }}>
        <button type="submit" className="btn btn-primary" disabled={loading}>
          {loading ? 'Saving...' : submitLabel}
        </button>
        <button type="button" className="btn btn-secondary" onClick={() => router.push('/questions')}>
          Cancel
        </button>
      </div>
    </form>
  );
}
