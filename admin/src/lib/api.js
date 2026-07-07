import axios from 'axios';

const BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:5000/api';

function getToken() {
  if (typeof window === 'undefined') return null;
  return localStorage.getItem('adminToken');
}

const api = axios.create({ baseURL: BASE_URL });

api.interceptors.request.use((config) => {
  const token = getToken();
  if (token) config.headers.Authorization = `Bearer ${token}`;
  return config;
});

export async function login(email, password) {
  const { data } = await api.post('/auth/login', { email, password });
  localStorage.setItem('adminToken', data.token);
  localStorage.setItem('adminEmail', data.email);
  return data;
}

export function logout() {
  localStorage.removeItem('adminToken');
  localStorage.removeItem('adminEmail');
}

export function isLoggedIn() {
  return typeof window !== 'undefined' && !!localStorage.getItem('adminToken');
}

export async function getStats() {
  const { data } = await api.get('/questions/stats');
  return data;
}

export async function getQuestions(params = {}) {
  const { data } = await api.get('/questions', { params });
  return data;
}

export async function getQuestion(id) {
  const { data } = await api.get(`/questions/${id}`);
  return data;
}

export async function createQuestion(body) {
  const { data } = await api.post('/questions', body);
  return data;
}

export async function updateQuestion(id, body) {
  const { data } = await api.put(`/questions/${id}`, body);
  return data;
}

export async function deleteQuestion(id) {
  const { data } = await api.delete(`/questions/${id}`);
  return data;
}

export async function bulkImport(questions) {
  const { data } = await api.post('/questions/bulk-import', { questions });
  return data;
}

export async function parsePdf(file) {
  const form = new FormData();
  form.append('pdf', file);
  const { data } = await api.post('/questions/parse-pdf', form, {
    headers: { 'Content-Type': 'multipart/form-data' },
  });
  return data;
}

// ── Previous Year Papers ──────────────────────────────────────────────────────

export async function getPYQPapers(examId) {
  const params = examId ? { examId } : {};
  const { data } = await api.get('/pyq', { params });
  return data;
}

export async function uploadPYQPaper({ file, examId, examName, year, title }) {
  const form = new FormData();
  form.append('pdf', file);
  form.append('examId', examId);
  form.append('examName', examName);
  form.append('year', String(year));
  form.append('title', title);
  const { data } = await api.post('/pyq', form, {
    headers: { 'Content-Type': 'multipart/form-data' },
  });
  return data;
}

export async function deletePYQPaper(id) {
  const { data } = await api.delete(`/pyq/${id}`);
  return data;
}

export function getPYQFileUrl(id) {
  return `${BASE_URL}/pyq/${id}/file`;
}
