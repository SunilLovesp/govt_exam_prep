/**
 * Kruti Dev / Kundli font  →  Unicode Devanagari converter
 * Kruti Dev is a legacy ASCII-based font used widely in Indian government
 * exam papers. When PDFs using this font are parsed, text appears as ASCII
 * characters instead of proper Devanagari. This module converts them back.
 */

// Character-level mapping: Kruti Dev ASCII → Unicode Devanagari
const CHAR_MAP = {
  // Vowels (standalone)
  'v': 'अ', 'vk': 'आ', 'b': 'इ', 'bZ': 'ई', 'q': 'उ', 'Å': 'ऊ',
  ',': 'ए', 'S': 'ऐ', 'vks': 'ओ', 'vkS': 'औ', 'va': 'अं', 'v%': 'अः',
  // Consonants
  'd': 'क', '[k': 'ख', 'x': 'ग', 'Ek': 'घ', 'M~': 'ङ',
  'p': 'च', 'N': 'छ', 't': 'ज', '>': 'झ', '×': 'ञ',
  'V': 'ट', 'B': 'ठ', 'M': 'ड', '<': 'ढ', '.k': 'ण',
  'r': 'त', 'Fk': 'थ', 'n': 'द', '/k': 'ध', 'u': 'न',
  'i': 'प', 'Q': 'फ', 'c': 'ब', 'Hk': 'भ', 'e': 'म',
  'y': 'ल', 'o': 'व', 'f\'k': 'श', ';': 'य', 'j': 'र',
  'l': 'स', 'g': 'ह', 'Ck': 'ब', 'Nk': 'छ',
  // Matras (vowel signs)
  'k': 'ा', 'f': 'ि', 'h': 'ी', 'q': 'ु', 'w': 'ू',
  's': 'े', 'S': 'ै', 'ks': 'ो', 'kS': 'ौ', 'a': 'ं', '%': 'ः',
  // Halant and special
  '~': '्', '^': 'ऱ', 'j+': 'ड़', '<+': 'ढ़',
  // Digits in Devanagari
  '0': '०', '1': '१', '2': '२', '3': '३', '4': '४',
  '5': '५', '6': '६', '7': '७', '8': '८', '9': '९',
};

// Detect if text is likely Kruti Dev encoded (heuristic)
function isKrutiDev(text) {
  // Kruti Dev text has lots of ASCII chars but no Unicode Devanagari
  const hasDevanagari = /[\u0900-\u097F]/.test(text);
  if (hasDevanagari) return false;

  // If text has English MCQ structure (Ans:, (A)/(B), etc.) it is NOT Kruti Dev
  if (/(?:ans(?:wer)?\s*:|(?:\(|\[)\s*[ABCDabcd]\s*(?:\)|\]))/i.test(text)) return false;

  // Require at least 3 matches to avoid false positives on English words
  // like "light" (gh), "knight" (gh), "kkhaki" etc.
  const krutiMatches = (text.match(/[fFdDsS]{2,}|[kKgGhH]{2,}/g) || []);
  return krutiMatches.length >= 3;
}

// Simple token-based conversion (handles most common cases)
function convertKrutiToUnicode(text) {
  if (!isKrutiDev(text)) return text; // already Unicode or not Kruti

  let result = '';
  let i = 0;
  while (i < text.length) {
    // Try longest match first (up to 4 chars)
    let matched = false;
    for (let len = 4; len >= 1; len--) {
      const chunk = text.substring(i, i + len);
      if (CHAR_MAP[chunk]) {
        result += CHAR_MAP[chunk];
        i += len;
        matched = true;
        break;
      }
    }
    if (!matched) {
      result += text[i];
      i++;
    }
  }
  return result;
}

module.exports = { convertKrutiToUnicode, isKrutiDev };
