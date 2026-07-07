'use client';
import { useEffect, useState } from 'react';
import Sidebar from '@/components/Sidebar';
import AuthGuard from '@/components/AuthGuard';
import { getStats } from '@/lib/api';

export default function DashboardPage() {
  const [stats, setStats] = useState(null);
  const [error, setError] = useState('');

  useEffect(() => {
    getStats()
      .then(setStats)
      .catch(() => setError('Could not load stats. Is the backend running?'));
  }, []);

  return (
    <AuthGuard>
      <div className="layout">
        <Sidebar />
        <div className="main">
          <div className="page-header">
            <h1>Dashboard</h1>
          </div>

          {error && <div className="error-msg">{error}</div>}

          {stats ? (
            <>
              <div className="stats-grid">
                <div className="stat-card">
                  <div className="label">Total Questions</div>
                  <div className="value">{stats.total}</div>
                </div>
                {stats.byDifficulty.map((d) => (
                  <div className="stat-card" key={d._id}>
                    <div className="label">{d._id}</div>
                    <div className="value">{d.count}</div>
                  </div>
                ))}
              </div>

              <div className="card">
                <div className="card-header">
                  <h2>Questions by Subject</h2>
                </div>
                <table>
                  <thead>
                    <tr>
                      <th>Subject</th>
                      <th>Count</th>
                      <th>% of Total</th>
                    </tr>
                  </thead>
                  <tbody>
                    {stats.bySubject.map((s) => (
                      <tr key={s._id}>
                        <td>{s._id}</td>
                        <td>{s.count}</td>
                        <td>{stats.total ? Math.round((s.count / stats.total) * 100) : 0}%</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </>
          ) : (
            !error && <p style={{ color: '#888' }}>Loading stats...</p>
          )}
        </div>
      </div>
    </AuthGuard>
  );
}
