'use client';
import Link from 'next/link';
import { usePathname, useRouter } from 'next/navigation';
import { logout } from '@/lib/api';

export default function Sidebar() {
  const pathname = usePathname();
  const router = useRouter();

  function handleLogout() {
    logout();
    router.push('/login');
  }

  return (
    <div className="sidebar">
      <h1>📚 ExamPrep Admin</h1>
      <nav>
        <Link href="/" className={pathname === '/' ? 'active' : ''}>Dashboard</Link>
        <Link href="/questions" className={pathname.startsWith('/questions') ? 'active' : ''}>Questions</Link>
        <Link href="/questions/new" className={pathname === '/questions/new' ? 'active' : ''}>+ Add Question</Link>
        <Link href="/questions/upload-csv" className={pathname === '/questions/upload-csv' ? 'active' : ''}>⬆ Upload CSV</Link>
        <Link href="/questions/upload-pdf" className={pathname === '/questions/upload-pdf' ? 'active' : ''}>📄 Upload PDF</Link>
        <Link href="/pyq" className={pathname.startsWith('/pyq') ? 'active' : ''}>📋 PYQ Papers</Link>
        <Link href="/pyq/upload" className={pathname === '/pyq/upload' ? 'active' : ''}>+ Upload PYQ</Link>
        <a onClick={handleLogout} style={{ cursor: 'pointer', marginTop: '16px', color: '#e94560' }}>Logout</a>
      </nav>
    </div>
  );
}
