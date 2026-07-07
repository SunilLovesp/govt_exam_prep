const pdfParse = require('pdf-parse');
const { convertKrutiToUnicode, isKrutiDev } = require('./krutiToUnicode');

/**
 * Parses a PDF buffer and extracts MCQ questions.
 *
 * Supports formats used in Indian govt exams:
 *   English:  1. Question text?  (A) Opt1  (B) Opt2  (C) Opt3  (D) Opt4  Ans: B
 *   Numeric:  1. Question text?  (1) Opt1  (2) Opt2  (3) Opt3  (4) Opt4  Ans: 2
 *   Inline:   1. Question? (A) Opt1 (B) Opt2 (C) Opt3 (D) Opt4 Ans: A
 *   2-per-line: (A) Opt1   (B) Opt2 on same line
 *   Hindi:    १. प्रश्न?  (अ) उत्तर1  (ब) उत्तर2  (स) उत्तर3  (द) उत्तर4  उत्तर: (ब)
 */

// Option label → index maps
const HINDI_OPTION_MAP = { 'अ': 0, 'ब': 1, 'स': 2, 'द': 3 };
const ENG_OPTION_MAP   = { 'A': 0, 'B': 1, 'C': 2, 'D': 3, 'a': 0, 'b': 1, 'c': 2, 'd': 3 };
const NUM_OPTION_MAP   = { '1': 0, '2': 1, '3': 2, '4': 3 };

function getLabelIndex(label) {
  const l = (label || '').trim();
  if (ENG_OPTION_MAP[l]   !== undefined) return ENG_OPTION_MAP[l];
  if (HINDI_OPTION_MAP[l] !== undefined) return HINDI_OPTION_MAP[l];
  if (NUM_OPTION_MAP[l]   !== undefined) return NUM_OPTION_MAP[l];
  return -1;
}

function parseCorrectIndex(label) {
  if (!label) return -1;
  const l = label.trim().replace(/[().[\]]/g, '');
  const idx = getLabelIndex(l);
  if (idx >= 0) return idx;
  const n = parseInt(l, 10);
  return (!isNaN(n) && n >= 1 && n <= 4) ? n - 1 : -1;
}

function cleanText(t) {
  return t.replace(/\s+/g, ' ').trim();
}

/**
 * Splits a single line that contains multiple options inline.
 * e.g. "(A) Mercury  (B) Venus  (C) Earth  (D) Mars"
 *      "(1) Mercury  (2) Venus"
 * Returns [{label, text}, ...] if ≥2 options found, else null.
 */
function splitInlineOptions(line) {
  // Match option markers: (A), [A], A), A. followed by space, (1), 1), etc.
  const markerRe = /[(\[]\s*([ABCDabcdअबसद1-4])\s*[)\]]\s*|(?:^|\s+)([ABCDabcd])[.)]\s+/g;
  const results = [];
  let lastEnd = 0;
  let lastLabel = null;
  let m;

  while ((m = markerRe.exec(line)) !== null) {
    const label = (m[1] || m[2] || '').trim();
    if (!label || getLabelIndex(label) < 0) continue;
    if (lastLabel !== null) {
      const text = cleanText(line.substring(lastEnd, m.index));
      if (text) results.push({ label: lastLabel, text });
    }
    lastLabel = label;
    lastEnd = m.index + m[0].length;
  }

  if (lastLabel !== null) {
    const text = cleanText(line.substring(lastEnd));
    if (text) results.push({ label: lastLabel, text });
  }

  return results.length >= 2 ? results : null;
}

/**
 * Expands a block where all options appear inline (1 or 2 lines).
 * e.g. "What is capital? (A) Mumbai (B) Delhi (C) Chennai (D) Kolkata Ans: B"
 * → splits option markers onto separate lines.
 */
function expandInlineBlock(block) {
  // Always put "Ans:" / "उत्तर:" on its own line when inline after option text
  // e.g. "(D) Mars Ans: B" → "(D) Mars\nAns: B"
  let processed = block.replace(
    /([^\n]+?)\s+((?:ans(?:wer)?|उत्तर)\s*[:\-.])/gi,
    '$1\n$2'
  );

  const optMarkerCount = (processed.match(/[(\[]\s*[ABCDabcdअबसद1-4]\s*[)\]]/g) || []).length;
  if (optMarkerCount < 2) return processed;

  const lines = processed.split('\n').filter(s => s.trim());
  if (lines.length >= 3) return processed; // already multi-line, no expansion needed

  // Expand option markers in the FIRST line ONLY (the inline question+options line).
  // Do NOT expand markers in subsequent lines (e.g. "उत्तर: (ब)") — that would
  // corrupt the answer capture group.
  const firstLine = lines[0] || '';
  const restLines = lines.slice(1);

  const expandedFirst = firstLine
    .replace(/\s*[(\[]\s*([ABCDabcdअबसद1-4])\s*[)\]]\s*/g, '\n($1) ')
    .trim();

  return [expandedFirst, ...restLines].join('\n');
}

// Matches answer lines like: "Ans: B", "Answer: 2", "उत्तर: (ब)", "Ans.(A)", "उत्तर:- (ब)"
const ANSWER_RE = /(?:ans(?:wer)?|उत्तर)\s*[:\-.]{0,2}\s*[(\[]?\s*([ABCDabcdअबसद1-4])\s*[)\]]?/i;

// Matches a single option line: "(A) text", "A) text", "A. text", "(1) text", "1) text"
const OPTION_RE = /^\s*[(\[]?\s*([ABCDabcdअबसद1-4])\s*[)\].]\s+(.+)/;

function parseQuestionsFromText(rawText) {
  const text = isKrutiDev(rawText) ? convertKrutiToUnicode(rawText) : rawText;
  const isHindi = /[\u0900-\u097F]/.test(text);
  const questions = [];

  // Split by question numbers: "1.", "1)", "Q1.", "Q.1", Devanagari numerals, "1:"
  const questionPattern = /(?:^|\n)\s*(?:Q\.?\s*)?(?:[१२३४५६७८९०\d]+)[.)।:]\s*/gm;
  const rawSplit = text.split(questionPattern);
  const parts = rawSplit.filter(Boolean);

  // Use number-based split if the pattern matched at least once (rawSplit.length > 1),
  // otherwise fall back to double-newline split.
  const blocks = rawSplit.length > 1 ? parts : text.split(/\n{2,}/).filter(Boolean);

  for (const rawBlock of blocks) {
    // Expand inline options to separate lines
    const block = expandInlineBlock(rawBlock);
    const lines = block.split('\n').map(cleanText).filter(Boolean);
    if (lines.length < 2) continue;

    // Strip any leading question number that wasn't removed by the split
    let questionText = lines[0].replace(/^\s*(?:Q\.?\s*)?(?:[१२३४५६७८९०\d]+)[.)।:]\s*/i, '');
    const options = ['', '', '', ''];
    let correctIndex = -1;
    const explanationLines = [];
    let inExplanation = false;
    let optionsFound = false;

    for (let i = 1; i < lines.length; i++) {
      const line = lines[i];

      // Answer line?
      const ansMatch = line.match(ANSWER_RE);
      if (ansMatch) {
        correctIndex = parseCorrectIndex(ansMatch[1]);
        inExplanation = true;
        const rest = line.replace(ANSWER_RE, '').trim();
        if (rest) explanationLines.push(rest);
        continue;
      }

      if (inExplanation) {
        explanationLines.push(line);
        continue;
      }

      // Try multi-option line (e.g. "(A) opt1   (B) opt2")
      const inlineParts = splitInlineOptions(line);
      if (inlineParts) {
        for (const { label, text } of inlineParts) {
          const idx = getLabelIndex(label);
          if (idx >= 0 && !options[idx]) options[idx] = text;
        }
        optionsFound = true;
        continue;
      }

      // Single option line?
      const optMatch = line.match(OPTION_RE);
      if (optMatch) {
        const idx = getLabelIndex(optMatch[1]);
        if (idx >= 0) {
          if (!options[idx]) options[idx] = cleanText(optMatch[2]);
          optionsFound = true;
          continue;
        }
      }

      // Continuation of question text (before any option found)
      if (!optionsFound) {
        questionText += ' ' + line;
      }
    }

    const filledOptions = options.filter(Boolean);
    if (!questionText || filledOptions.length < 2) continue;

    const finalOptions = options.map((o, i) =>
      o || `Option ${String.fromCharCode(65 + i)}`
    );

    questions.push({
      question: cleanText(questionText),
      options: finalOptions,
      correct: correctIndex >= 0 ? correctIndex : 0,
      explanation: explanationLines.join(' ').trim() || 'See solution.',
      subject: 'General Awareness',
      topic: '',
      difficulty: 'medium',
      examType: 'General',
      _isHindi: isHindi,
    });
  }

  return questions;
}

async function parsePDF(buffer) {
  const data = await pdfParse(buffer);
  const rawText = data.text;
  const questions = parseQuestionsFromText(rawText);
  return {
    questions,
    pageCount: data.numpages,
    rawTextPreview: rawText.slice(0, 1000),
  };
}

module.exports = { parsePDF, parseQuestionsFromText };
