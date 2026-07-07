import '../core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ExamCategory {
  final String id;
  final String name;
  final String shortName;
  final String description;
  final Color color;
  final IconData icon;
  final List<Exam> exams;

  const ExamCategory({
    required this.id,
    required this.name,
    required this.shortName,
    required this.description,
    required this.color,
    required this.icon,
    required this.exams,
  });
}

class Exam {
  final String id;
  final String name;
  final String fullName;
  final String category;
  final String conductedBy;
  final int vacancies;
  final String eligibility;
  final List<ExamTier> tiers;
  final List<String> subjects;
  final List<TestSeries> testSeries;

  const Exam({
    required this.id,
    required this.name,
    required this.fullName,
    required this.category,
    required this.conductedBy,
    required this.vacancies,
    required this.eligibility,
    required this.tiers,
    required this.subjects,
    required this.testSeries,
  });
}

class ExamTier {
  final String name;
  final int totalQuestions;
  final int totalMarks;
  final int durationMinutes;
  final double negativeMark;
  final List<Section> sections;

  const ExamTier({
    required this.name,
    required this.totalQuestions,
    required this.totalMarks,
    required this.durationMinutes,
    required this.negativeMark,
    required this.sections,
  });
}

class Section {
  final String name;
  final int questions;
  final int marks;

  const Section(
      {required this.name, required this.questions, required this.marks});
}

class TestSeries {
  final String id;
  final String title;
  final String type; // 'full', 'sectional', 'previous_year'
  final int totalQuestions;
  final int durationMinutes;
  final int totalAttempts;
  final bool isFree;

  const TestSeries({
    required this.id,
    required this.title,
    required this.type,
    required this.totalQuestions,
    required this.durationMinutes,
    required this.totalAttempts,
    required this.isFree,
  });
}

// ─── Static Data ─────────────────────────────────────────────────────────────
final List<ExamCategory> examCategories = [
  const ExamCategory(
    id: 'ssc',
    name: 'SSC Exams',
    shortName: 'SSC',
    description: 'Staff Selection Commission',
    color: AppColors.sscColor,
    icon: Icons.account_balance,
    exams: [
      Exam(
        id: 'ssc_cgl',
        name: 'SSC CGL',
        fullName: 'Combined Graduate Level',
        category: 'ssc',
        conductedBy: 'Staff Selection Commission',
        vacancies: 17000,
        eligibility: 'Graduation from any recognized university',
        subjects: [
          'Quantitative Aptitude',
          'Reasoning',
          'English',
          'General Awareness'
        ],
        tiers: [
          ExamTier(
            name: 'Tier I',
            totalQuestions: 100,
            totalMarks: 200,
            durationMinutes: 60,
            negativeMark: 0.5,
            sections: [
              Section(
                  name: 'General Intelligence & Reasoning',
                  questions: 25,
                  marks: 50),
              Section(name: 'General Awareness', questions: 25, marks: 50),
              Section(name: 'Quantitative Aptitude', questions: 25, marks: 50),
              Section(name: 'English Comprehension', questions: 25, marks: 50),
            ],
          ),
          ExamTier(
            name: 'Tier II',
            totalQuestions: 150,
            totalMarks: 450,
            durationMinutes: 135,
            negativeMark: 1.0,
            sections: [
              Section(
                  name: 'Mathematical Abilities', questions: 90, marks: 270),
              Section(name: 'Reasoning & GI', questions: 30, marks: 90),
              Section(
                  name: 'English Language & Comprehension',
                  questions: 45,
                  marks: 135),
            ],
          ),
        ],
        testSeries: [
          TestSeries(
              id: 'cgl_t1_1',
              title: 'CGL Tier I - Full Test 1',
              type: 'full',
              totalQuestions: 100,
              durationMinutes: 60,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'cgl_t1_2',
              title: 'CGL Tier I - Full Test 2',
              type: 'full',
              totalQuestions: 100,
              durationMinutes: 60,
              totalAttempts: 0,
              isFree: false),
          TestSeries(
              id: 'cgl_quant_1',
              title: 'Quant Practice Set 1',
              type: 'sectional',
              totalQuestions: 25,
              durationMinutes: 25,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'cgl_py_2023',
              title: 'CGL 2023 Previous Year',
              type: 'previous_year',
              totalQuestions: 100,
              durationMinutes: 60,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'ssc_chsl',
        name: 'SSC CHSL',
        fullName: 'Combined Higher Secondary Level',
        category: 'ssc',
        conductedBy: 'Staff Selection Commission',
        vacancies: 3712,
        eligibility: '12th pass from any recognized board',
        subjects: [
          'Quantitative Aptitude',
          'Reasoning',
          'English',
          'General Awareness'
        ],
        tiers: [
          ExamTier(
              name: 'Tier I',
              totalQuestions: 100,
              totalMarks: 200,
              durationMinutes: 60,
              negativeMark: 0.5,
              sections: []),
          ExamTier(
              name: 'Tier II',
              totalQuestions: 100,
              totalMarks: 200,
              durationMinutes: 60,
              negativeMark: 0.5,
              sections: []),
        ],
        testSeries: [
          TestSeries(
              id: 'chsl_t1_1',
              title: 'CHSL Tier I - Full Test 1',
              type: 'full',
              totalQuestions: 100,
              durationMinutes: 60,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'ssc_mts',
        name: 'SSC MTS',
        fullName: 'Multi Tasking Staff',
        category: 'ssc',
        conductedBy: 'Staff Selection Commission',
        vacancies: 8326,
        eligibility: '10th pass from any recognized board',
        subjects: [
          'Numerical Aptitude',
          'Reasoning',
          'English',
          'General Awareness'
        ],
        tiers: [
          ExamTier(
              name: 'Paper I',
              totalQuestions: 100,
              totalMarks: 150,
              durationMinutes: 90,
              negativeMark: 0.25,
              sections: []),
          ExamTier(
              name: 'Paper II (Descriptive)',
              totalQuestions: 0,
              totalMarks: 50,
              durationMinutes: 45,
              negativeMark: 0,
              sections: []),
        ],
        testSeries: [
          TestSeries(
              id: 'mts_1',
              title: 'MTS Full Test 1',
              type: 'full',
              totalQuestions: 100,
              durationMinutes: 90,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'mts_2',
              title: 'MTS Full Test 2',
              type: 'full',
              totalQuestions: 100,
              durationMinutes: 90,
              totalAttempts: 0,
              isFree: false),
          TestSeries(
              id: 'mts_py_2023',
              title: 'MTS 2023 Previous Year',
              type: 'previous_year',
              totalQuestions: 100,
              durationMinutes: 90,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'ssc_gd',
        name: 'SSC GD',
        fullName: 'General Duty Constable',
        category: 'ssc',
        conductedBy: 'Staff Selection Commission',
        vacancies: 26146,
        eligibility: '10th pass, Age 18-23, Physical fitness required',
        subjects: [
          'General Intelligence & Reasoning',
          'General Knowledge',
          'Elementary Mathematics',
          'English/Hindi'
        ],
        tiers: [
          ExamTier(
            name: 'CBT',
            totalQuestions: 80,
            totalMarks: 160,
            durationMinutes: 60,
            negativeMark: 0.5,
            sections: [
              Section(
                  name: 'General Intelligence & Reasoning',
                  questions: 20,
                  marks: 40),
              Section(
                  name: 'General Knowledge & Awareness',
                  questions: 20,
                  marks: 40),
              Section(name: 'Elementary Mathematics', questions: 20, marks: 40),
              Section(name: 'English / Hindi', questions: 20, marks: 40),
            ],
          ),
        ],
        testSeries: [
          TestSeries(
              id: 'gd_cbt_1',
              title: 'SSC GD Full Test 1',
              type: 'full',
              totalQuestions: 80,
              durationMinutes: 60,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'gd_cbt_2',
              title: 'SSC GD Full Test 2',
              type: 'full',
              totalQuestions: 80,
              durationMinutes: 60,
              totalAttempts: 0,
              isFree: false),
          TestSeries(
              id: 'gd_py_2023',
              title: 'GD 2023 Previous Year',
              type: 'previous_year',
              totalQuestions: 80,
              durationMinutes: 60,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'ssc_cpo',
        name: 'SSC CPO',
        fullName: 'Central Police Organisations (Sub-Inspector)',
        category: 'ssc',
        conductedBy: 'Staff Selection Commission',
        vacancies: 4187,
        eligibility: 'Graduation, Age 20-25, Physical fitness required',
        subjects: [
          'General Intelligence & Reasoning',
          'General Knowledge',
          'Quantitative Aptitude',
          'English'
        ],
        tiers: [
          ExamTier(
            name: 'Paper I',
            totalQuestions: 200,
            totalMarks: 200,
            durationMinutes: 120,
            negativeMark: 0.25,
            sections: [
              Section(
                  name: 'General Intelligence & Reasoning',
                  questions: 50,
                  marks: 50),
              Section(
                  name: 'General Knowledge & Awareness',
                  questions: 50,
                  marks: 50),
              Section(name: 'Quantitative Aptitude', questions: 50, marks: 50),
              Section(name: 'English Comprehension', questions: 50, marks: 50),
            ],
          ),
          ExamTier(
              name: 'Paper II (English)',
              totalQuestions: 200,
              totalMarks: 200,
              durationMinutes: 120,
              negativeMark: 0.25,
              sections: []),
        ],
        testSeries: [
          TestSeries(
              id: 'cpo_p1_1',
              title: 'CPO Paper I Full Test 1',
              type: 'full',
              totalQuestions: 200,
              durationMinutes: 120,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'cpo_p1_2',
              title: 'CPO Paper I Full Test 2',
              type: 'full',
              totalQuestions: 200,
              durationMinutes: 120,
              totalAttempts: 0,
              isFree: false),
        ],
      ),
      Exam(
        id: 'ssc_je',
        name: 'SSC JE',
        fullName: 'Junior Engineer',
        category: 'ssc',
        conductedBy: 'Staff Selection Commission',
        vacancies: 1765,
        eligibility: 'Diploma/Degree in Engineering, Age 18-32',
        subjects: [
          'General Intelligence & Reasoning',
          'General Awareness',
          'Civil/Mechanical/Electrical Engineering'
        ],
        tiers: [
          ExamTier(
            name: 'Paper I (CBT)',
            totalQuestions: 200,
            totalMarks: 200,
            durationMinutes: 120,
            negativeMark: 0.25,
            sections: [
              Section(
                  name: 'General Intelligence & Reasoning',
                  questions: 50,
                  marks: 50),
              Section(name: 'General Awareness', questions: 50, marks: 50),
              Section(
                  name: 'Part A: Civil & Structural Engineering',
                  questions: 100,
                  marks: 100),
            ],
          ),
          ExamTier(
              name: 'Paper II (Descriptive)',
              totalQuestions: 0,
              totalMarks: 300,
              durationMinutes: 120,
              negativeMark: 0,
              sections: []),
        ],
        testSeries: [
          TestSeries(
              id: 'je_p1_civil_1',
              title: 'JE Civil Paper I Test 1',
              type: 'full',
              totalQuestions: 200,
              durationMinutes: 120,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'je_p1_elec_1',
              title: 'JE Electrical Paper I Test 1',
              type: 'full',
              totalQuestions: 200,
              durationMinutes: 120,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'ssc_steno',
        name: 'SSC Steno',
        fullName: 'Stenographer Grade C & D',
        category: 'ssc',
        conductedBy: 'Staff Selection Commission',
        vacancies: 2006,
        eligibility: '12th pass, Age 18-30 (Grade C) / 18-27 (Grade D)',
        subjects: [
          'General Intelligence & Reasoning',
          'General Awareness',
          'English Language & Comprehension'
        ],
        tiers: [
          ExamTier(
            name: 'CBT',
            totalQuestions: 200,
            totalMarks: 200,
            durationMinutes: 120,
            negativeMark: 0.25,
            sections: [
              Section(
                  name: 'General Intelligence & Reasoning',
                  questions: 50,
                  marks: 50),
              Section(name: 'General Awareness', questions: 50, marks: 50),
              Section(
                  name: 'English Language & Comprehension',
                  questions: 100,
                  marks: 100),
            ],
          ),
        ],
        testSeries: [
          TestSeries(
              id: 'steno_1',
              title: 'Stenographer Full Test 1',
              type: 'full',
              totalQuestions: 200,
              durationMinutes: 120,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'steno_eng_1',
              title: 'English Practice Set 1',
              type: 'sectional',
              totalQuestions: 50,
              durationMinutes: 30,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
    ],
  ),
  const ExamCategory(
    id: 'upsc',
    name: 'UPSC Exams',
    shortName: 'UPSC',
    description: 'Union Public Service Commission',
    color: AppColors.upscColor,
    icon: Icons.gavel,
    exams: [
      Exam(
        id: 'upsc_cse',
        name: 'UPSC CSE',
        fullName: 'Civil Services Examination',
        category: 'upsc',
        conductedBy: 'Union Public Service Commission',
        vacancies: 1016,
        eligibility: 'Graduation from recognized university, Age 21-32',
        subjects: [
          'GS Paper I',
          'GS Paper II (CSAT)',
          'Optional Subject',
          'Essay'
        ],
        tiers: [
          ExamTier(
              name: 'Prelims',
              totalQuestions: 200,
              totalMarks: 400,
              durationMinutes: 240,
              negativeMark: 0.666,
              sections: []),
          ExamTier(
              name: 'Mains',
              totalQuestions: 0,
              totalMarks: 1750,
              durationMinutes: 180,
              negativeMark: 0,
              sections: []),
        ],
        testSeries: [
          TestSeries(
              id: 'cse_prelims_1',
              title: 'UPSC Prelims GS Test 1',
              type: 'full',
              totalQuestions: 100,
              durationMinutes: 120,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'cse_csat_1',
              title: 'CSAT Practice Set 1',
              type: 'sectional',
              totalQuestions: 80,
              durationMinutes: 120,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'upsc_nda',
        name: 'UPSC NDA',
        fullName: 'National Defence Academy',
        category: 'upsc',
        conductedBy: 'Union Public Service Commission',
        vacancies: 400,
        eligibility: '12th pass, Age 16.5-19.5 years, Male only',
        subjects: ['Mathematics', 'General Ability Test'],
        tiers: [
          ExamTier(
              name: 'Written',
              totalQuestions: 150,
              totalMarks: 900,
              durationMinutes: 150,
              negativeMark: 1.33,
              sections: []),
        ],
        testSeries: [
          TestSeries(
              id: 'nda_math_1',
              title: 'NDA Mathematics Test 1',
              type: 'full',
              totalQuestions: 120,
              durationMinutes: 150,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'nda_gat_1',
              title: 'NDA GAT Full Test 1',
              type: 'full',
              totalQuestions: 150,
              durationMinutes: 150,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'nda_py_2023',
              title: 'NDA 2023 Previous Year',
              type: 'previous_year',
              totalQuestions: 150,
              durationMinutes: 150,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'upsc_cds',
        name: 'UPSC CDS',
        fullName: 'Combined Defence Services',
        category: 'upsc',
        conductedBy: 'Union Public Service Commission',
        vacancies: 459,
        eligibility: 'Graduation (varies by service), Age 19-25',
        subjects: ['English', 'General Knowledge', 'Elementary Mathematics'],
        tiers: [
          ExamTier(
            name: 'Written',
            totalQuestions: 300,
            totalMarks: 300,
            durationMinutes: 360,
            negativeMark: 0.33,
            sections: [
              Section(name: 'English', questions: 100, marks: 100),
              Section(name: 'General Knowledge', questions: 100, marks: 100),
              Section(
                  name: 'Elementary Mathematics', questions: 100, marks: 100),
            ],
          ),
        ],
        testSeries: [
          TestSeries(
              id: 'cds_eng_1',
              title: 'CDS English Test 1',
              type: 'sectional',
              totalQuestions: 100,
              durationMinutes: 120,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'cds_full_1',
              title: 'CDS Full Test 1',
              type: 'full',
              totalQuestions: 300,
              durationMinutes: 360,
              totalAttempts: 0,
              isFree: false),
          TestSeries(
              id: 'cds_py_2023',
              title: 'CDS 2023 Previous Year',
              type: 'previous_year',
              totalQuestions: 300,
              durationMinutes: 360,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'upsc_capf',
        name: 'UPSC CAPF',
        fullName: 'Central Armed Police Forces (AC)',
        category: 'upsc',
        conductedBy: 'Union Public Service Commission',
        vacancies: 253,
        eligibility: 'Graduation, Age 20-25',
        subjects: ['General Ability & Intelligence', 'General Studies & Essay'],
        tiers: [
          ExamTier(
              name: 'Paper I (MCQ)',
              totalQuestions: 125,
              totalMarks: 250,
              durationMinutes: 120,
              negativeMark: 0.33,
              sections: []),
          ExamTier(
              name: 'Paper II (Descriptive)',
              totalQuestions: 0,
              totalMarks: 200,
              durationMinutes: 180,
              negativeMark: 0,
              sections: []),
        ],
        testSeries: [
          TestSeries(
              id: 'capf_p1_1',
              title: 'CAPF Paper I Test 1',
              type: 'full',
              totalQuestions: 125,
              durationMinutes: 120,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
    ],
  ),
  const ExamCategory(
    id: 'banking',
    name: 'Banking Exams',
    shortName: 'Banking',
    description: 'IBPS, SBI, RBI & more',
    color: AppColors.bankingColor,
    icon: Icons.account_balance_wallet,
    exams: [
      Exam(
        id: 'ibps_po',
        name: 'IBPS PO',
        fullName: 'Probationary Officer',
        category: 'banking',
        conductedBy: 'Institute of Banking Personnel Selection',
        vacancies: 4455,
        eligibility: 'Graduation, Age 20-30',
        subjects: [
          'Quantitative Aptitude',
          'Reasoning',
          'English',
          'General Awareness',
          'Computer'
        ],
        tiers: [
          ExamTier(
              name: 'Prelims',
              totalQuestions: 100,
              totalMarks: 100,
              durationMinutes: 60,
              negativeMark: 0.25,
              sections: []),
          ExamTier(
              name: 'Mains',
              totalQuestions: 155,
              totalMarks: 200,
              durationMinutes: 180,
              negativeMark: 0.25,
              sections: []),
        ],
        testSeries: [
          TestSeries(
              id: 'ibps_po_pre_1',
              title: 'IBPS PO Prelims Test 1',
              type: 'full',
              totalQuestions: 100,
              durationMinutes: 60,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'sbi_po',
        name: 'SBI PO',
        fullName: 'State Bank of India PO',
        category: 'banking',
        conductedBy: 'State Bank of India',
        vacancies: 2000,
        eligibility: 'Graduation, Age 21-30',
        subjects: [
          'Quantitative Aptitude',
          'Reasoning',
          'English',
          'General Awareness'
        ],
        tiers: [
          ExamTier(
              name: 'Prelims',
              totalQuestions: 100,
              totalMarks: 100,
              durationMinutes: 60,
              negativeMark: 0.25,
              sections: []),
          ExamTier(
              name: 'Mains',
              totalQuestions: 155,
              totalMarks: 250,
              durationMinutes: 180,
              negativeMark: 0.25,
              sections: []),
        ],
        testSeries: [
          TestSeries(
              id: 'sbi_po_pre_1',
              title: 'SBI PO Prelims Test 1',
              type: 'full',
              totalQuestions: 100,
              durationMinutes: 60,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'sbi_po_pre_2',
              title: 'SBI PO Prelims Test 2',
              type: 'full',
              totalQuestions: 100,
              durationMinutes: 60,
              totalAttempts: 0,
              isFree: false),
          TestSeries(
              id: 'sbi_po_py_2023',
              title: 'SBI PO 2023 Previous Year',
              type: 'previous_year',
              totalQuestions: 100,
              durationMinutes: 60,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'ibps_clerk',
        name: 'IBPS Clerk',
        fullName: 'IBPS Clerk (CWE)',
        category: 'banking',
        conductedBy: 'Institute of Banking Personnel Selection',
        vacancies: 6128,
        eligibility: 'Graduation, Age 20-28',
        subjects: [
          'Quantitative Aptitude',
          'Reasoning',
          'English',
          'General Awareness',
          'Computer'
        ],
        tiers: [
          ExamTier(
              name: 'Prelims',
              totalQuestions: 100,
              totalMarks: 100,
              durationMinutes: 60,
              negativeMark: 0.25,
              sections: []),
          ExamTier(
              name: 'Mains',
              totalQuestions: 190,
              totalMarks: 200,
              durationMinutes: 160,
              negativeMark: 0.25,
              sections: []),
        ],
        testSeries: [
          TestSeries(
              id: 'ibps_cl_pre_1',
              title: 'IBPS Clerk Prelims Test 1',
              type: 'full',
              totalQuestions: 100,
              durationMinutes: 60,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'ibps_cl_pre_2',
              title: 'IBPS Clerk Prelims Test 2',
              type: 'full',
              totalQuestions: 100,
              durationMinutes: 60,
              totalAttempts: 0,
              isFree: false),
          TestSeries(
              id: 'ibps_cl_py_2023',
              title: 'IBPS Clerk 2023 Previous Year',
              type: 'previous_year',
              totalQuestions: 100,
              durationMinutes: 60,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'sbi_clerk',
        name: 'SBI Clerk',
        fullName: 'State Bank of India Clerk (JA)',
        category: 'banking',
        conductedBy: 'State Bank of India',
        vacancies: 8773,
        eligibility: 'Graduation, Age 20-28',
        subjects: [
          'Quantitative Aptitude',
          'Reasoning',
          'English',
          'General Awareness'
        ],
        tiers: [
          ExamTier(
              name: 'Prelims',
              totalQuestions: 100,
              totalMarks: 100,
              durationMinutes: 60,
              negativeMark: 0.25,
              sections: []),
          ExamTier(
              name: 'Mains',
              totalQuestions: 190,
              totalMarks: 200,
              durationMinutes: 160,
              negativeMark: 0.25,
              sections: []),
        ],
        testSeries: [
          TestSeries(
              id: 'sbi_cl_pre_1',
              title: 'SBI Clerk Prelims Test 1',
              type: 'full',
              totalQuestions: 100,
              durationMinutes: 60,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'sbi_cl_py_2023',
              title: 'SBI Clerk 2023 Previous Year',
              type: 'previous_year',
              totalQuestions: 100,
              durationMinutes: 60,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'rbi_grade_b',
        name: 'RBI Grade B',
        fullName: 'Reserve Bank of India Grade B Officer',
        category: 'banking',
        conductedBy: 'Reserve Bank of India',
        vacancies: 291,
        eligibility: 'Graduation (min 60%), Age 21-30',
        subjects: [
          'General Awareness',
          'Quantitative Aptitude',
          'English',
          'Reasoning',
          'Finance & Management'
        ],
        tiers: [
          ExamTier(
              name: 'Phase I (Online)',
              totalQuestions: 200,
              totalMarks: 200,
              durationMinutes: 120,
              negativeMark: 0.25,
              sections: []),
          ExamTier(
              name: 'Phase II (Online)',
              totalQuestions: 0,
              totalMarks: 300,
              durationMinutes: 300,
              negativeMark: 0,
              sections: []),
        ],
        testSeries: [
          TestSeries(
              id: 'rbi_gb_p1_1',
              title: 'RBI Grade B Phase I Test 1',
              type: 'full',
              totalQuestions: 200,
              durationMinutes: 120,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'rbi_gb_ga_1',
              title: 'RBI GA Practice Set 1',
              type: 'sectional',
              totalQuestions: 80,
              durationMinutes: 40,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'ibps_rrb_po',
        name: 'IBPS RRB PO',
        fullName: 'Regional Rural Bank Officer Scale I',
        category: 'banking',
        conductedBy: 'Institute of Banking Personnel Selection',
        vacancies: 9985,
        eligibility: 'Graduation, Age 18-30',
        subjects: [
          'Quantitative Aptitude',
          'Reasoning',
          'English/Hindi',
          'General Awareness',
          'Computer'
        ],
        tiers: [
          ExamTier(
              name: 'Prelims',
              totalQuestions: 80,
              totalMarks: 80,
              durationMinutes: 45,
              negativeMark: 0.25,
              sections: []),
          ExamTier(
              name: 'Mains',
              totalQuestions: 200,
              totalMarks: 200,
              durationMinutes: 120,
              negativeMark: 0.25,
              sections: []),
        ],
        testSeries: [
          TestSeries(
              id: 'rrb_po_pre_1',
              title: 'RRB PO Prelims Test 1',
              type: 'full',
              totalQuestions: 80,
              durationMinutes: 45,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'rrb_po_py_2023',
              title: 'RRB PO 2023 Previous Year',
              type: 'previous_year',
              totalQuestions: 80,
              durationMinutes: 45,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'ibps_rrb_clerk',
        name: 'IBPS RRB Clerk',
        fullName: 'Regional Rural Bank Office Assistant',
        category: 'banking',
        conductedBy: 'Institute of Banking Personnel Selection',
        vacancies: 11112,
        eligibility: 'Graduation, Age 18-28',
        subjects: [
          'Quantitative Aptitude',
          'Reasoning',
          'English/Hindi',
          'General Awareness',
          'Computer'
        ],
        tiers: [
          ExamTier(
              name: 'Prelims',
              totalQuestions: 80,
              totalMarks: 80,
              durationMinutes: 45,
              negativeMark: 0.25,
              sections: []),
          ExamTier(
              name: 'Mains',
              totalQuestions: 200,
              totalMarks: 200,
              durationMinutes: 120,
              negativeMark: 0.25,
              sections: []),
        ],
        testSeries: [
          TestSeries(
              id: 'rrb_cl_pre_1',
              title: 'RRB Clerk Prelims Test 1',
              type: 'full',
              totalQuestions: 80,
              durationMinutes: 45,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
    ],
  ),
  const ExamCategory(
    id: 'railways',
    name: 'Railway Exams',
    shortName: 'Railways',
    description: 'RRB NTPC, Group D, ALP',
    color: AppColors.railwayColor,
    icon: Icons.train,
    exams: [
      Exam(
        id: 'rrb_ntpc',
        name: 'RRB NTPC',
        fullName: 'Non-Technical Popular Categories',
        category: 'railways',
        conductedBy: 'Railway Recruitment Board',
        vacancies: 35208,
        eligibility: 'Graduation/12th pass (varies by post)',
        subjects: ['Mathematics', 'General Intelligence', 'General Awareness'],
        tiers: [
          ExamTier(
              name: 'CBT 1',
              totalQuestions: 100,
              totalMarks: 100,
              durationMinutes: 90,
              negativeMark: 0.33,
              sections: []),
          ExamTier(
              name: 'CBT 2',
              totalQuestions: 120,
              totalMarks: 120,
              durationMinutes: 90,
              negativeMark: 0.33,
              sections: []),
        ],
        testSeries: [
          TestSeries(
              id: 'ntpc_cbt1_1',
              title: 'RRB NTPC CBT 1 Test 1',
              type: 'full',
              totalQuestions: 100,
              durationMinutes: 90,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'rrb_group_d',
        name: 'RRB Group D',
        fullName: 'Railway Group D',
        category: 'railways',
        conductedBy: 'Railway Recruitment Board',
        vacancies: 103769,
        eligibility: '10th pass / ITI, Age 18-36',
        subjects: [
          'Mathematics',
          'General Intelligence',
          'General Awareness',
          'Science'
        ],
        tiers: [
          ExamTier(
              name: 'CBT',
              totalQuestions: 100,
              totalMarks: 100,
              durationMinutes: 90,
              negativeMark: 0.33,
              sections: []),
        ],
        testSeries: [
          TestSeries(
              id: 'gd_1',
              title: 'Group D Full Test 1',
              type: 'full',
              totalQuestions: 100,
              durationMinutes: 90,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'gd_2',
              title: 'Group D Full Test 2',
              type: 'full',
              totalQuestions: 100,
              durationMinutes: 90,
              totalAttempts: 0,
              isFree: false),
          TestSeries(
              id: 'gd_py_2022',
              title: 'Group D 2022 Previous Year',
              type: 'previous_year',
              totalQuestions: 100,
              durationMinutes: 90,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'rrb_alp',
        name: 'RRB ALP',
        fullName: 'Assistant Loco Pilot',
        category: 'railways',
        conductedBy: 'Railway Recruitment Board',
        vacancies: 18799,
        eligibility: '10th pass + ITI (relevant trade), Age 18-28',
        subjects: [
          'Mathematics',
          'General Intelligence & Reasoning',
          'General Science',
          'General Awareness'
        ],
        tiers: [
          ExamTier(
            name: 'CBT 1',
            totalQuestions: 75,
            totalMarks: 75,
            durationMinutes: 60,
            negativeMark: 0.33,
            sections: [
              Section(name: 'Mathematics', questions: 20, marks: 20),
              Section(
                  name: 'General Intelligence & Reasoning',
                  questions: 25,
                  marks: 25),
              Section(name: 'General Science', questions: 20, marks: 20),
              Section(name: 'General Awareness', questions: 10, marks: 10),
            ],
          ),
          ExamTier(
              name: 'CBT 2 Part A',
              totalQuestions: 100,
              totalMarks: 100,
              durationMinutes: 90,
              negativeMark: 0.33,
              sections: []),
          ExamTier(
              name: 'CBT 2 Part B (Trade)',
              totalQuestions: 75,
              totalMarks: 75,
              durationMinutes: 60,
              negativeMark: 0,
              sections: []),
        ],
        testSeries: [
          TestSeries(
              id: 'alp_cbt1_1',
              title: 'ALP CBT 1 Full Test 1',
              type: 'full',
              totalQuestions: 75,
              durationMinutes: 60,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'alp_cbt1_2',
              title: 'ALP CBT 1 Full Test 2',
              type: 'full',
              totalQuestions: 75,
              durationMinutes: 60,
              totalAttempts: 0,
              isFree: false),
          TestSeries(
              id: 'alp_py_2024',
              title: 'ALP 2024 Previous Year',
              type: 'previous_year',
              totalQuestions: 75,
              durationMinutes: 60,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'rrb_je',
        name: 'RRB JE',
        fullName: 'Junior Engineer',
        category: 'railways',
        conductedBy: 'Railway Recruitment Board',
        vacancies: 7951,
        eligibility: 'Diploma/Degree in Engineering, Age 18-33',
        subjects: [
          'Mathematics',
          'General Intelligence & Reasoning',
          'General Awareness',
          'General Science',
          'Technical Subjects'
        ],
        tiers: [
          ExamTier(
            name: 'CBT 1',
            totalQuestions: 100,
            totalMarks: 100,
            durationMinutes: 90,
            negativeMark: 0.33,
            sections: [
              Section(name: 'Mathematics', questions: 30, marks: 30),
              Section(
                  name: 'General Intelligence & Reasoning',
                  questions: 25,
                  marks: 25),
              Section(name: 'General Awareness', questions: 15, marks: 15),
              Section(name: 'General Science', questions: 30, marks: 30),
            ],
          ),
          ExamTier(
              name: 'CBT 2 (Technical)',
              totalQuestions: 150,
              totalMarks: 150,
              durationMinutes: 120,
              negativeMark: 0.33,
              sections: []),
        ],
        testSeries: [
          TestSeries(
              id: 'je_cbt1_1',
              title: 'RRB JE CBT 1 Test 1',
              type: 'full',
              totalQuestions: 100,
              durationMinutes: 90,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'je_sci_1',
              title: 'Science Practice Set 1',
              type: 'sectional',
              totalQuestions: 30,
              durationMinutes: 25,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
    ],
  ),
  const ExamCategory(
    id: 'state_psc',
    name: 'State PSC',
    shortName: 'State PSC',
    description: 'UP, MP, Rajasthan, Bihar & more',
    color: AppColors.pscColor,
    icon: Icons.location_city,
    exams: [
      Exam(
        id: 'uppsc',
        name: 'UPPSC PCS',
        fullName: 'UP Provincial Civil Services',
        category: 'state_psc',
        conductedBy: 'Uttar Pradesh PSC',
        vacancies: 250,
        eligibility: 'Graduation, Age 21-40',
        subjects: ['GS Paper I', 'GS Paper II', 'Optional'],
        tiers: [
          ExamTier(
              name: 'Prelims',
              totalQuestions: 150,
              totalMarks: 300,
              durationMinutes: 120,
              negativeMark: 0.33,
              sections: []),
          ExamTier(
              name: 'Mains',
              totalQuestions: 0,
              totalMarks: 1500,
              durationMinutes: 180,
              negativeMark: 0,
              sections: []),
        ],
        testSeries: [
          TestSeries(
              id: 'uppsc_pre_1',
              title: 'UPPSC Prelims Test 1',
              type: 'full',
              totalQuestions: 150,
              durationMinutes: 120,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'uppsc_pre_2',
              title: 'UPPSC Prelims Test 2',
              type: 'full',
              totalQuestions: 150,
              durationMinutes: 120,
              totalAttempts: 0,
              isFree: false),
          TestSeries(
              id: 'uppsc_py_2023',
              title: 'UPPSC 2023 Previous Year',
              type: 'previous_year',
              totalQuestions: 150,
              durationMinutes: 120,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'mppsc',
        name: 'MPPSC PCS',
        fullName: 'MP State Service Examination',
        category: 'state_psc',
        conductedBy: 'Madhya Pradesh PSC',
        vacancies: 330,
        eligibility: 'Graduation, Age 21-40',
        subjects: ['General Studies', 'General Aptitude', 'Hindi'],
        tiers: [
          ExamTier(
              name: 'Prelims',
              totalQuestions: 200,
              totalMarks: 400,
              durationMinutes: 240,
              negativeMark: 0,
              sections: []),
          ExamTier(
              name: 'Mains',
              totalQuestions: 0,
              totalMarks: 1400,
              durationMinutes: 180,
              negativeMark: 0,
              sections: []),
        ],
        testSeries: [
          TestSeries(
              id: 'mppsc_pre_1',
              title: 'MPPSC Prelims Test 1',
              type: 'full',
              totalQuestions: 100,
              durationMinutes: 120,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'mppsc_py_2023',
              title: 'MPPSC 2023 Previous Year',
              type: 'previous_year',
              totalQuestions: 100,
              durationMinutes: 120,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'bpsc',
        name: 'BPSC PCS',
        fullName: 'Bihar Combined Competitive Examination',
        category: 'state_psc',
        conductedBy: 'Bihar Public Service Commission',
        vacancies: 281,
        eligibility: 'Graduation, Age 20-37',
        subjects: ['General Studies', 'General Hindi', 'Optional Subject'],
        tiers: [
          ExamTier(
              name: 'Prelims',
              totalQuestions: 150,
              totalMarks: 150,
              durationMinutes: 120,
              negativeMark: 0,
              sections: []),
          ExamTier(
              name: 'Mains',
              totalQuestions: 0,
              totalMarks: 900,
              durationMinutes: 180,
              negativeMark: 0,
              sections: []),
        ],
        testSeries: [
          TestSeries(
              id: 'bpsc_pre_1',
              title: 'BPSC Prelims Test 1',
              type: 'full',
              totalQuestions: 150,
              durationMinutes: 120,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'bpsc_py_2023',
              title: 'BPSC 2023 Previous Year',
              type: 'previous_year',
              totalQuestions: 150,
              durationMinutes: 120,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'rpsc_ras',
        name: 'RPSC RAS',
        fullName: 'Rajasthan Administrative Service',
        category: 'state_psc',
        conductedBy: 'Rajasthan Public Service Commission',
        vacancies: 988,
        eligibility: 'Graduation, Age 21-40',
        subjects: ['General Knowledge & GS', 'Reasoning', 'General Hindi'],
        tiers: [
          ExamTier(
              name: 'Prelims',
              totalQuestions: 150,
              totalMarks: 200,
              durationMinutes: 180,
              negativeMark: 0.33,
              sections: []),
          ExamTier(
              name: 'Mains',
              totalQuestions: 0,
              totalMarks: 800,
              durationMinutes: 180,
              negativeMark: 0,
              sections: []),
        ],
        testSeries: [
          TestSeries(
              id: 'rpsc_pre_1',
              title: 'RAS Prelims Test 1',
              type: 'full',
              totalQuestions: 150,
              durationMinutes: 180,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'rpsc_py_2023',
              title: 'RAS 2023 Previous Year',
              type: 'previous_year',
              totalQuestions: 150,
              durationMinutes: 180,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'hpsc_hcs',
        name: 'HPSC HCS',
        fullName: 'Haryana Civil Services',
        category: 'state_psc',
        conductedBy: 'Haryana Public Service Commission',
        vacancies: 156,
        eligibility: 'Graduation, Age 21-42',
        subjects: ['General Studies', 'English', 'Hindi'],
        tiers: [
          ExamTier(
              name: 'Prelims',
              totalQuestions: 200,
              totalMarks: 200,
              durationMinutes: 120,
              negativeMark: 0.25,
              sections: []),
          ExamTier(
              name: 'Mains',
              totalQuestions: 0,
              totalMarks: 750,
              durationMinutes: 180,
              negativeMark: 0,
              sections: []),
        ],
        testSeries: [
          TestSeries(
              id: 'hpsc_pre_1',
              title: 'HCS Prelims Test 1',
              type: 'full',
              totalQuestions: 200,
              durationMinutes: 120,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
    ],
  ),
  const ExamCategory(
    id: 'teaching',
    name: 'Teaching Exams',
    shortName: 'Teaching',
    description: 'CTET, STET, KVS & more',
    color: AppColors.teachingColor,
    icon: Icons.school,
    exams: [
      Exam(
        id: 'ctet',
        name: 'CTET',
        fullName: 'Central Teacher Eligibility Test',
        category: 'teaching',
        conductedBy: 'Central Board of Secondary Education',
        vacancies: 0,
        eligibility: 'D.Ed / B.Ed from recognized institution',
        subjects: [
          'Child Development',
          'Language I',
          'Language II',
          'Mathematics',
          'EVS'
        ],
        tiers: [
          ExamTier(
              name: 'Paper I (Class 1-5)',
              totalQuestions: 150,
              totalMarks: 150,
              durationMinutes: 150,
              negativeMark: 0,
              sections: []),
          ExamTier(
              name: 'Paper II (Class 6-8)',
              totalQuestions: 150,
              totalMarks: 150,
              durationMinutes: 150,
              negativeMark: 0,
              sections: []),
        ],
        testSeries: [
          TestSeries(
              id: 'ctet_p1_1',
              title: 'CTET Paper I Full Test 1',
              type: 'full',
              totalQuestions: 150,
              durationMinutes: 150,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'ctet_p2_1',
              title: 'CTET Paper II Full Test 1',
              type: 'full',
              totalQuestions: 150,
              durationMinutes: 150,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'ctet_py_2023',
              title: 'CTET 2023 Previous Year',
              type: 'previous_year',
              totalQuestions: 150,
              durationMinutes: 150,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'uptet',
        name: 'UPTET',
        fullName: 'Uttar Pradesh Teacher Eligibility Test',
        category: 'teaching',
        conductedBy: 'Uttar Pradesh Basic Education Board',
        vacancies: 0,
        eligibility: 'D.Ed / B.Ed from recognized institution',
        subjects: [
          'Child Development & Pedagogy',
          'Language I (Hindi)',
          'Language II (English)',
          'Mathematics & Science / Social Studies'
        ],
        tiers: [
          ExamTier(
              name: 'Paper I (Primary)',
              totalQuestions: 150,
              totalMarks: 150,
              durationMinutes: 150,
              negativeMark: 0,
              sections: []),
          ExamTier(
              name: 'Paper II (Upper Primary)',
              totalQuestions: 150,
              totalMarks: 150,
              durationMinutes: 150,
              negativeMark: 0,
              sections: []),
        ],
        testSeries: [
          TestSeries(
              id: 'uptet_p1_1',
              title: 'UPTET Paper I Test 1',
              type: 'full',
              totalQuestions: 150,
              durationMinutes: 150,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'uptet_py_2023',
              title: 'UPTET 2023 Previous Year',
              type: 'previous_year',
              totalQuestions: 150,
              durationMinutes: 150,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'reet',
        name: 'REET',
        fullName: 'Rajasthan Eligibility Examination for Teachers',
        category: 'teaching',
        conductedBy: 'Board of Secondary Education Rajasthan',
        vacancies: 0,
        eligibility: 'D.Ed / B.Ed, Age 18-40',
        subjects: [
          'Child Development & Pedagogy',
          'Language I',
          'Language II',
          'Mathematics & Science / Social Science'
        ],
        tiers: [
          ExamTier(
              name: 'Level I (Class 1-5)',
              totalQuestions: 150,
              totalMarks: 150,
              durationMinutes: 150,
              negativeMark: 0,
              sections: []),
          ExamTier(
              name: 'Level II (Class 6-8)',
              totalQuestions: 150,
              totalMarks: 150,
              durationMinutes: 150,
              negativeMark: 0,
              sections: []),
        ],
        testSeries: [
          TestSeries(
              id: 'reet_l1_1',
              title: 'REET Level I Test 1',
              type: 'full',
              totalQuestions: 150,
              durationMinutes: 150,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'reet_l2_1',
              title: 'REET Level II Test 1',
              type: 'full',
              totalQuestions: 150,
              durationMinutes: 150,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'reet_py_2022',
              title: 'REET 2022 Previous Year',
              type: 'previous_year',
              totalQuestions: 150,
              durationMinutes: 150,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'kvs_tgt_pgt',
        name: 'KVS TGT/PGT',
        fullName: 'Kendriya Vidyalaya Sangathan Teacher',
        category: 'teaching',
        conductedBy: 'Kendriya Vidyalaya Sangathan',
        vacancies: 6414,
        eligibility: 'B.Ed + Graduation/Post-Graduation, Age 18-35',
        subjects: [
          'General Hindi',
          'General English',
          'General Knowledge',
          'Reasoning',
          'Subject Knowledge',
          'Pedagogy'
        ],
        tiers: [
          ExamTier(
            name: 'Written Test',
            totalQuestions: 180,
            totalMarks: 180,
            durationMinutes: 180,
            negativeMark: 0.25,
            sections: [
              Section(name: 'General Hindi', questions: 10, marks: 10),
              Section(name: 'General English', questions: 10, marks: 10),
              Section(
                  name: 'General Knowledge & Current Affairs',
                  questions: 40,
                  marks: 40),
              Section(name: 'Reasoning Ability', questions: 40, marks: 40),
              Section(
                  name: 'Subject Knowledge & Pedagogy',
                  questions: 80,
                  marks: 80),
            ],
          ),
        ],
        testSeries: [
          TestSeries(
              id: 'kvs_tgt_1',
              title: 'KVS TGT Full Test 1',
              type: 'full',
              totalQuestions: 180,
              durationMinutes: 180,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'kvs_pgt_1',
              title: 'KVS PGT Full Test 1',
              type: 'full',
              totalQuestions: 180,
              durationMinutes: 180,
              totalAttempts: 0,
              isFree: false),
          TestSeries(
              id: 'kvs_py_2023',
              title: 'KVS 2023 Previous Year',
              type: 'previous_year',
              totalQuestions: 180,
              durationMinutes: 180,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'nvs_tgt',
        name: 'NVS TGT',
        fullName: 'Navodaya Vidyalaya Samiti Teacher',
        category: 'teaching',
        conductedBy: 'Navodaya Vidyalaya Samiti',
        vacancies: 1925,
        eligibility: 'B.Ed + Graduation (relevant subject), Age 21-35',
        subjects: [
          'Reasoning',
          'General Awareness',
          'Language (English/Hindi)',
          'Subject Knowledge'
        ],
        tiers: [
          ExamTier(
              name: 'Written Test',
              totalQuestions: 130,
              totalMarks: 130,
              durationMinutes: 150,
              negativeMark: 0.25,
              sections: []),
        ],
        testSeries: [
          TestSeries(
              id: 'nvs_tgt_1',
              title: 'NVS TGT Full Test 1',
              type: 'full',
              totalQuestions: 130,
              durationMinutes: 150,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'dsssb_tgt',
        name: 'DSSSB TGT',
        fullName: 'Delhi Subordinate Services Selection Board Teacher',
        category: 'teaching',
        conductedBy: 'Delhi Subordinate Services Selection Board',
        vacancies: 8980,
        eligibility: 'B.Ed + Graduation, Age 18-32',
        subjects: [
          'General Awareness',
          'General Intelligence & Reasoning',
          'Arithmetical & Numerical Ability',
          'Hindi & English Language',
          'Subject Knowledge'
        ],
        tiers: [
          ExamTier(
            name: 'Tier I (One Paper)',
            totalQuestions: 200,
            totalMarks: 200,
            durationMinutes: 120,
            negativeMark: 0.25,
            sections: [
              Section(name: 'General Awareness', questions: 20, marks: 20),
              Section(
                  name: 'General Intelligence & Reasoning',
                  questions: 20,
                  marks: 20),
              Section(
                  name: 'Arithmetical & Numerical Ability',
                  questions: 20,
                  marks: 20),
              Section(
                  name: 'Hindi & English Language', questions: 20, marks: 20),
              Section(name: 'Subject Knowledge', questions: 120, marks: 120),
            ],
          ),
        ],
        testSeries: [
          TestSeries(
              id: 'dsssb_tgt_1',
              title: 'DSSSB TGT Full Test 1',
              type: 'full',
              totalQuestions: 200,
              durationMinutes: 120,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'dsssb_py_2023',
              title: 'DSSSB 2023 Previous Year',
              type: 'previous_year',
              totalQuestions: 200,
              durationMinutes: 120,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
    ],
  ),
  const ExamCategory(
    id: 'army',
    name: 'Army Exams',
    shortName: 'Army',
    description: 'Indian Army Recruitment',
    color: AppColors.armyColor,
    icon: Icons.shield,
    exams: [
      Exam(
        id: 'army_gd',
        name: 'Army GD',
        fullName: 'General Duty Soldier',
        category: 'army',
        conductedBy: 'Indian Army',
        vacancies: 25000,
        eligibility: '10th pass, Age 17.5-21, Medical fitness required',
        subjects: [
          'General Knowledge',
          'General Science',
          'Mathematics',
          'Reasoning'
        ],
        tiers: [
          ExamTier(
            name: 'Written Exam',
            totalQuestions: 50,
            totalMarks: 100,
            durationMinutes: 60,
            negativeMark: 0.5,
            sections: [
              Section(name: 'General Knowledge & GS', questions: 15, marks: 30),
              Section(name: 'Mathematics', questions: 15, marks: 30),
              Section(name: 'Reasoning', questions: 10, marks: 20),
              Section(name: 'General Science', questions: 10, marks: 20),
            ],
          ),
        ],
        testSeries: [
          TestSeries(
              id: 'army_gd_1',
              title: 'Army GD Full Test 1',
              type: 'full',
              totalQuestions: 50,
              durationMinutes: 60,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'army_gd_2',
              title: 'Army GD Full Test 2',
              type: 'full',
              totalQuestions: 50,
              durationMinutes: 60,
              totalAttempts: 0,
              isFree: false),
          TestSeries(
              id: 'army_gd_py_2023',
              title: 'Army GD 2023 Previous Year',
              type: 'previous_year',
              totalQuestions: 50,
              durationMinutes: 60,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'army_technical',
        name: 'Army Technical',
        fullName: 'Soldier Technical',
        category: 'army',
        conductedBy: 'Indian Army',
        vacancies: 8000,
        eligibility: '12th pass (PCM), Age 17.5-23',
        subjects: ['Mathematics', 'Physics', 'Chemistry', 'General Science'],
        tiers: [
          ExamTier(
            name: 'Written Exam',
            totalQuestions: 50,
            totalMarks: 200,
            durationMinutes: 60,
            negativeMark: 0.5,
            sections: [
              Section(name: 'Mathematics', questions: 15, marks: 60),
              Section(name: 'Physics', questions: 15, marks: 60),
              Section(name: 'Chemistry', questions: 10, marks: 40),
              Section(name: 'General Science', questions: 10, marks: 40),
            ],
          ),
        ],
        testSeries: [
          TestSeries(
              id: 'army_tech_1',
              title: 'Army Technical Full Test 1',
              type: 'full',
              totalQuestions: 50,
              durationMinutes: 60,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'army_tech_sci_1',
              title: 'Science Practice Set 1',
              type: 'sectional',
              totalQuestions: 25,
              durationMinutes: 30,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'army_clerk',
        name: 'Army Clerk',
        fullName: 'Soldier Clerk / Store Keeper Technical',
        category: 'army',
        conductedBy: 'Indian Army',
        vacancies: 3000,
        eligibility: '12th pass (any stream, 60% aggregate), Age 17.5-23',
        subjects: [
          'General Knowledge',
          'General Science',
          'Mathematics',
          'English',
          'Computer'
        ],
        tiers: [
          ExamTier(
            name: 'Written Exam Part I',
            totalQuestions: 25,
            totalMarks: 100,
            durationMinutes: 60,
            negativeMark: 0.5,
            sections: [
              Section(name: 'General Knowledge & GS', questions: 5, marks: 20),
              Section(name: 'Mathematics', questions: 10, marks: 40),
              Section(name: 'Computer Science', questions: 10, marks: 40),
            ],
          ),
          ExamTier(
            name: 'Written Exam Part II',
            totalQuestions: 25,
            totalMarks: 100,
            durationMinutes: 60,
            negativeMark: 0.5,
            sections: [
              Section(name: 'General English', questions: 25, marks: 100),
            ],
          ),
        ],
        testSeries: [
          TestSeries(
              id: 'army_clerk_1',
              title: 'Army Clerk Full Test 1',
              type: 'full',
              totalQuestions: 50,
              durationMinutes: 60,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'army_clerk_eng_1',
              title: 'English Practice Set 1',
              type: 'sectional',
              totalQuestions: 25,
              durationMinutes: 30,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'army_clerk_py_2023',
              title: 'Army Clerk 2023 Previous Year',
              type: 'previous_year',
              totalQuestions: 50,
              durationMinutes: 60,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'army_tradesman',
        name: 'Army Tradesman',
        fullName: 'Soldier Tradesman',
        category: 'army',
        conductedBy: 'Indian Army',
        vacancies: 12000,
        eligibility: '8th / 10th pass (trade-dependent), Age 17.5-23',
        subjects: [
          'General Knowledge',
          'General Science',
          'Mathematics',
          'Reasoning'
        ],
        tiers: [
          ExamTier(
            name: 'Written Exam',
            totalQuestions: 50,
            totalMarks: 100,
            durationMinutes: 60,
            negativeMark: 0.5,
            sections: [
              Section(name: 'General Knowledge', questions: 20, marks: 40),
              Section(name: 'Mathematics', questions: 15, marks: 30),
              Section(name: 'General Science', questions: 10, marks: 20),
              Section(name: 'Reasoning', questions: 5, marks: 10),
            ],
          ),
        ],
        testSeries: [
          TestSeries(
              id: 'army_tm_1',
              title: 'Tradesman Full Test 1',
              type: 'full',
              totalQuestions: 50,
              durationMinutes: 60,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'army_tm_py_2023',
              title: 'Tradesman 2023 Previous Year',
              type: 'previous_year',
              totalQuestions: 50,
              durationMinutes: 60,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'army_havildar',
        name: 'Army Havildar',
        fullName: 'Havildar Education / SAC',
        category: 'army',
        conductedBy: 'Indian Army',
        vacancies: 695,
        eligibility: '12th pass (Science), Age 17.5-25',
        subjects: [
          'Mathematics',
          'Physics',
          'Chemistry',
          'General Knowledge',
          'English'
        ],
        tiers: [
          ExamTier(
            name: 'Stage I (CBT)',
            totalQuestions: 100,
            totalMarks: 200,
            durationMinutes: 60,
            negativeMark: 0.5,
            sections: [
              Section(name: 'Mathematics', questions: 30, marks: 60),
              Section(name: 'Physics & Chemistry', questions: 25, marks: 50),
              Section(
                  name: 'General Knowledge & English',
                  questions: 25,
                  marks: 50),
              Section(name: 'Reasoning', questions: 20, marks: 40),
            ],
          ),
        ],
        testSeries: [
          TestSeries(
              id: 'army_hav_1',
              title: 'Havildar Full Test 1',
              type: 'full',
              totalQuestions: 100,
              durationMinutes: 60,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'army_hav_sci_1',
              title: 'Science Practice Set 1',
              type: 'sectional',
              totalQuestions: 25,
              durationMinutes: 20,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
      Exam(
        id: 'army_nursing',
        name: 'Army Nursing',
        fullName: 'Military Nursing Service (BSc Nursing)',
        category: 'army',
        conductedBy: 'Indian Army',
        vacancies: 220,
        eligibility: '12th pass (PCB, min 50%), Age 17-25, Female',
        subjects: [
          'Physics',
          'Chemistry',
          'Biology',
          'General English',
          'General Intelligence'
        ],
        tiers: [
          ExamTier(
            name: 'Written Test',
            totalQuestions: 200,
            totalMarks: 200,
            durationMinutes: 120,
            negativeMark: 0.25,
            sections: [
              Section(name: 'Physics', questions: 40, marks: 40),
              Section(name: 'Chemistry', questions: 40, marks: 40),
              Section(name: 'Biology', questions: 40, marks: 40),
              Section(name: 'General English', questions: 40, marks: 40),
              Section(name: 'General Intelligence', questions: 40, marks: 40),
            ],
          ),
        ],
        testSeries: [
          TestSeries(
              id: 'army_nurs_1',
              title: 'MNS Full Test 1',
              type: 'full',
              totalQuestions: 200,
              durationMinutes: 120,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'army_nurs_bio_1',
              title: 'Biology Practice Set 1',
              type: 'sectional',
              totalQuestions: 40,
              durationMinutes: 25,
              totalAttempts: 0,
              isFree: true),
          TestSeries(
              id: 'army_nurs_py_2023',
              title: 'MNS 2023 Previous Year',
              type: 'previous_year',
              totalQuestions: 200,
              durationMinutes: 120,
              totalAttempts: 0,
              isFree: true),
        ],
      ),
    ],
  ),
];
