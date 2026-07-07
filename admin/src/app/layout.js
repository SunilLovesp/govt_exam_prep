import './globals.css';

export const metadata = {
  title: 'ExamPrep Admin',
  description: 'Admin panel for Govt Exam Prep app',
};

export default function RootLayout({ children }) {
  return (
    <html lang="hi">
      <head>
        {/* Noto Sans Devanagari — standard Unicode Hindi / Kundli-style font */}
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <link
          href="https://fonts.googleapis.com/css2?family=Noto+Sans+Devanagari:wght@400;500;600;700&family=Inter:wght@400;500;600;700&display=swap"
          rel="stylesheet"
        />
      </head>
      <body>{children}</body>
    </html>
  );
}
