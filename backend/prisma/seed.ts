import {
  BadgeCriteriaType,
  BadgeRarity,
  CourseLevel,
  FriendRequestStatus,
  LessonType,
  PrismaClient,
} from '@prisma/client';
import * as bcrypt from 'bcryptjs';
import { levelFromXp } from '../src/common/xp';

const prisma = new PrismaClient();

const categories = [
  { id: 'cat-mobile', slug: 'mobile', name: 'Mobile', description: 'Cross-platform mobile apps', color: '#4F46E5' },
  { id: 'cat-python', slug: 'python', name: 'Python', description: 'Python programming', color: '#2563EB' },
  { id: 'cat-web', slug: 'web', name: 'Web Development', description: 'Modern web applications', color: '#0891B2' },
  { id: 'cat-security', slug: 'security', name: 'Cybersecurity', description: 'Defensive security', color: '#DC2626' },
  { id: 'cat-ai', slug: 'ai', name: 'AI / ML', description: 'Machine learning foundations', color: '#7C3AED' },
  { id: 'cat-games', slug: 'games', name: 'Game Development', description: 'Interactive games', color: '#DB2777' },
];

const courseData = [
  {
    id: 'course-flutter', slug: 'flutter', title: 'Flutter Fundamentals', categoryId: 'cat-mobile',
    description: 'Build cross-platform apps with Flutter and Dart.', level: CourseLevel.BEGINNER,
    hours: 12, featured: true,
    modules: [
      { title: 'Dart Basics', lessons: ['Variables and types', 'Functions', 'Control flow'] },
      { title: 'Widgets', lessons: ['Stateless widgets', 'Stateful widgets', 'Layouts', 'Navigation'] },
    ],
  },
  {
    id: 'course-python', slug: 'python', title: 'Python from Scratch', categoryId: 'cat-python',
    description: 'Learn Python syntax, data structures and projects.', level: CourseLevel.BEGINNER,
    hours: 10, featured: true,
    modules: [
      { title: 'Core Syntax', lessons: ['Values and variables', 'Lists and dictionaries', 'Loops'] },
      { title: 'Building Projects', lessons: ['Functions', 'Files', 'Modules', 'Testing'] },
    ],
  },
  {
    id: 'course-web', slug: 'web-dev', title: 'Modern Web Development', categoryId: 'cat-web',
    description: 'HTML, CSS, TypeScript and React fundamentals.', level: CourseLevel.INTERMEDIATE,
    hours: 16, featured: true,
    modules: [
      { title: 'The Platform', lessons: ['HTML semantics', 'CSS layout', 'Flexbox and Grid'] },
      { title: 'Frontend Apps', lessons: ['TypeScript basics', 'React components', 'State', 'Fetching data'] },
    ],
  },
  {
    id: 'course-cyber', slug: 'cybersecurity', title: 'Cybersecurity Essentials', categoryId: 'cat-security',
    description: 'Threat models, networking and secure coding.', level: CourseLevel.INTERMEDIATE,
    hours: 14, featured: false,
    modules: [
      { title: 'Security Basics', lessons: ['CIA triad', 'Networking', 'Threat modeling'] },
      { title: 'Defensive Practice', lessons: ['Authentication', 'Encryption', 'OWASP Top 10', 'Incident response'] },
    ],
  },
  {
    id: 'course-ai', slug: 'ai-ml', title: 'AI and Machine Learning', categoryId: 'cat-ai',
    description: 'From linear regression to neural networks.', level: CourseLevel.ADVANCED,
    hours: 20, featured: true,
    modules: [
      { title: 'Foundations', lessons: ['Data and features', 'Linear regression', 'Classification'] },
      { title: 'Neural Networks', lessons: ['Perceptrons', 'Backpropagation', 'Training loops', 'Evaluation'] },
    ],
  },
  {
    id: 'course-games', slug: 'game-dev', title: 'Game Development', categoryId: 'cat-games',
    description: 'Game loops, sprites and physics with Flutter Flame.', level: CourseLevel.INTERMEDIATE,
    hours: 12, featured: false,
    modules: [
      { title: 'Game Loops', lessons: ['The update loop', 'Sprites', 'Input handling'] },
      { title: 'Worlds', lessons: ['Collision detection', 'Animations', 'Levels', 'Scoring'] },
    ],
  },
];

const quizData: Record<string, { question: string; options: string[]; correct: number }[]> = {
  flutter: [
    { question: 'Which language does Flutter use?', options: ['Kotlin', 'Dart', 'Swift', 'Java'], correct: 1 },
    { question: 'Which widget rebuilds when state changes?', options: ['StatelessWidget', 'Container', 'StatefulWidget', 'Text'], correct: 2 },
    { question: 'What lays out children vertically?', options: ['Row', 'Column', 'Stack', 'Wrap'], correct: 1 },
  ],
  python: [
    { question: 'Which keyword defines a function?', options: ['func', 'def', 'function', 'lambda x'], correct: 1 },
    { question: 'Which structure is ordered and mutable?', options: ['tuple', 'set', 'list', 'frozenset'], correct: 2 },
    { question: 'What does len() return?', options: ['Last item', 'Number of items', 'Type name', 'Hash'], correct: 1 },
  ],
  'web-dev': [
    { question: 'Which element is the document root?', options: ['<body>', '<head>', '<html>', '<main>'], correct: 2 },
    { question: 'Which CSS model controls spacing outside an element?', options: ['padding', 'margin', 'border', 'gap'], correct: 1 },
    { question: 'What does TypeScript add to JavaScript?', options: ['Static types', 'New runtime', 'CSS support', 'Threads'], correct: 0 },
  ],
  cybersecurity: [
    { question: 'What does the "C" in CIA triad stand for?', options: ['Confidentiality', 'Compatibility', 'Connectivity', 'Caching'], correct: 0 },
    { question: 'Which protocol serves HTTPS?', options: ['FTP', 'TLS', 'SMTP', 'Telnet'], correct: 1 },
    { question: 'Which attack relies on injected SQL?', options: ['XSS', 'SQL injection', 'CSRF', 'Clickjacking'], correct: 1 },
  ],
  'ai-ml': [
    { question: 'What is the goal of regression?', options: ['Classify labels', 'Predict a number', 'Cluster rows', 'Hash data'], correct: 1 },
    { question: 'Which function maps input to output in a perceptron?', options: ['Activation', 'Loss', 'Tokenizer', 'Optimizer'], correct: 0 },
    { question: 'What is overfitting?', options: ['Too little data', 'Memorizing training data', 'Under-trained model', 'High bias only'], correct: 1 },
  ],
  'game-dev': [
    { question: 'What drives a game frame?', options: ['Game loop', 'HTTP request', 'Database trigger', 'CSS animation'], correct: 0 },
    { question: 'Which component detects overlap?', options: ['Animation', 'Camera', 'Collision detection', 'Audio'], correct: 2 },
    { question: 'What is a sprite?', options: ['A 2D image asset', 'A sound file', 'A save file', 'A shader language'], correct: 0 },
  ],
};

const badges = [
  { code: 'FIRST_STEP', name: 'First Step', description: 'Earn 50 XP', type: BadgeCriteriaType.XP_THRESHOLD, value: 50, rarity: BadgeRarity.COMMON, xp: 25 },
  { code: 'QUIZ_NOVICE', name: 'Quiz Novice', description: 'Pass your first quiz', type: BadgeCriteriaType.QUIZ_COUNT, value: 1, rarity: BadgeRarity.COMMON, xp: 25 },
  { code: 'STREAK_7', name: 'Seven Days', description: 'Reach a 7-day streak', type: BadgeCriteriaType.STREAK_DAYS, value: 7, rarity: BadgeRarity.RARE, xp: 60 },
  { code: 'LESSON_10', name: 'Dedicated Learner', description: 'Complete 10 lessons', type: BadgeCriteriaType.LESSON_COUNT, value: 10, rarity: BadgeRarity.RARE, xp: 60 },
  { code: 'COURSE_1', name: 'Course Finisher', description: 'Complete one course', type: BadgeCriteriaType.COURSE_COUNT, value: 1, rarity: BadgeRarity.RARE, xp: 75 },
  { code: 'SOCIALITE', name: 'Socialite', description: 'Add three friends', type: BadgeCriteriaType.FRIEND_COUNT, value: 3, rarity: BadgeRarity.COMMON, xp: 30 },
  { code: 'POSTER', name: 'Contributor', description: 'Publish a post', type: BadgeCriteriaType.POST_COUNT, value: 1, rarity: BadgeRarity.COMMON, xp: 20 },
  { code: 'XP_1000', name: 'CodeBro Legend', description: 'Earn 1000 XP', type: BadgeCriteriaType.XP_THRESHOLD, value: 1000, rarity: BadgeRarity.LEGENDARY, xp: 200 },
];

async function seedUsers(): Promise<void> {
  const passwordHash = await bcrypt.hash(
    process.env.SEED_DEMO_PASSWORD ?? 'CodeBro123!',
    4,
  );
  for (let index = 1; index <= 12; index += 1) {
    const id = `user-demo-${String(index).padStart(2, '0')}`;
    const xp = index * 75;
    await prisma.user.upsert({
      where: { id },
      create: {
        id,
        email: `demo${String(index).padStart(2, '0')}@codebro.app`,
        passwordHash,
        displayName: `Demo Learner ${index}`,
        bio: 'CodeBro demo account',
        xp,
        level: levelFromXp(xp),
        streakCount: index % 7,
        longestStreak: index % 7,
      },
      update: {
        displayName: `Demo Learner ${index}`,
        bio: 'CodeBro demo account',
        xp,
        level: levelFromXp(xp),
      },
    });
  }
}

async function seedCourses(): Promise<void> {
  for (const category of categories) {
    await prisma.category.upsert({
      where: { id: category.id },
      create: { ...category },
      update: { name: category.name, description: category.description, color: category.color },
    });
  }

  for (const course of courseData) {
    await prisma.course.upsert({
      where: { id: course.id },
      create: {
        id: course.id,
        slug: course.slug,
        title: course.title,
        description: course.description,
        categoryId: course.categoryId,
        level: course.level,
        estimatedHours: course.hours,
        featured: course.featured,
        published: true,
      },
      update: {
        title: course.title,
        description: course.description,
        level: course.level,
        estimatedHours: course.hours,
        featured: course.featured,
        published: true,
      },
    });

    let firstLessonId = '';
    for (let moduleIndex = 0; moduleIndex < course.modules.length; moduleIndex += 1) {
      const moduleEntry = course.modules[moduleIndex];
      const moduleId = `${course.id}-m${moduleIndex + 1}`;
      await prisma.module.upsert({
        where: { id: moduleId },
        create: {
          id: moduleId,
          courseId: course.id,
          slug: `module-${moduleIndex + 1}`,
          title: moduleEntry.title,
          description: `Module ${moduleIndex + 1} of ${course.title}`,
          order: moduleIndex + 1,
        },
        update: { title: moduleEntry.title, order: moduleIndex + 1 },
      });

      for (let lessonIndex = 0; lessonIndex < moduleEntry.lessons.length; lessonIndex += 1) {
        const lessonId = `${moduleId}-l${lessonIndex + 1}`;
        const title = moduleEntry.lessons[lessonIndex];
        if (!firstLessonId) firstLessonId = lessonId;
        await prisma.lesson.upsert({
          where: { id: lessonId },
          create: {
            id: lessonId,
            moduleId,
            slug: `lesson-${lessonIndex + 1}`,
            title,
            type: LessonType.READING,
            order: lessonIndex + 1,
            estimatedMinutes: 5 + lessonIndex,
            xpReward: 20,
            content: {
              blocks: [
                { type: 'heading', text: title },
                { type: 'paragraph', text: `Learn ${title.toLowerCase()} in this ${course.title} lesson.` },
              ],
            },
          },
          update: {
            title,
            order: lessonIndex + 1,
            content: {
              blocks: [
                { type: 'heading', text: title },
                { type: 'paragraph', text: `Learn ${title.toLowerCase()} in this ${course.title} lesson.` },
              ],
            },
          },
        });
      }
    }

    const quizId = `quiz-${course.slug}`;
    await prisma.quiz.upsert({
      where: { id: quizId },
      create: {
        id: quizId,
        slug: course.slug,
        courseId: course.id,
        lessonId: firstLessonId || null,
        title: `${course.title} Checkpoint`,
        description: 'Three-question knowledge check.',
        passingScore: 70,
        xpReward: 50,
        published: true,
      },
      update: { title: `${course.title} Checkpoint`, passingScore: 70, xpReward: 50, published: true },
    });

    const questions = quizData[course.slug];
    for (let questionIndex = 0; questionIndex < questions.length; questionIndex += 1) {
      const question = questions[questionIndex];
      const questionId = `${quizId}-q${questionIndex + 1}`;
      await prisma.quizQuestion.upsert({
        where: { id: questionId },
        create: { id: questionId, quizId, prompt: question.question, order: questionIndex + 1 },
        update: { prompt: question.question, order: questionIndex + 1 },
      });
      for (let optionIndex = 0; optionIndex < question.options.length; optionIndex += 1) {
        await prisma.quizOption.upsert({
          where: { id: `${questionId}-a${optionIndex + 1}` },
          create: {
            id: `${questionId}-a${optionIndex + 1}`,
            questionId,
            label: question.options[optionIndex],
            isCorrect: optionIndex === question.correct,
            order: optionIndex + 1,
          },
          update: {
            label: question.options[optionIndex],
            isCorrect: optionIndex === question.correct,
            order: optionIndex + 1,
          },
        });
      }
    }
  }
}

async function seedBadges(): Promise<void> {
  for (const badge of badges) {
    await prisma.badge.upsert({
      where: { id: `badge-${badge.code.toLowerCase()}` },
      create: {
        id: `badge-${badge.code.toLowerCase()}`,
        code: badge.code,
        name: badge.name,
        description: badge.description,
        criteriaType: badge.type,
        criteriaValue: badge.value,
        rarity: badge.rarity,
        xpReward: badge.xp,
      },
      update: {
        name: badge.name,
        description: badge.description,
        criteriaType: badge.type,
        criteriaValue: badge.value,
        rarity: badge.rarity,
        xpReward: badge.xp,
      },
    });
  }
}

async function seedSocial(): Promise<void> {
  const pairs = [
    ['user-demo-01', 'user-demo-02'], ['user-demo-01', 'user-demo-03'],
    ['user-demo-02', 'user-demo-03'], ['user-demo-04', 'user-demo-05'],
    ['user-demo-05', 'user-demo-06'], ['user-demo-07', 'user-demo-08'],
    ['user-demo-09', 'user-demo-10'], ['user-demo-11', 'user-demo-12'],
  ];
  for (const [userId, friendId] of pairs) {
    for (const [owner, friend] of [[userId, friendId], [friendId, userId]]) {
      await prisma.friendship.upsert({
        where: { userId_friendId: { userId: owner, friendId: friend } },
        create: { userId: owner, friendId: friend },
        update: {},
      });
    }
  }

  await prisma.friendRequest.upsert({
    where: { id: 'friend-request-01' },
    create: {
      id: 'friend-request-01',
      senderId: 'user-demo-01',
      receiverId: 'user-demo-04',
      status: FriendRequestStatus.PENDING,
      message: 'Let us learn together!',
    },
    update: { status: FriendRequestStatus.PENDING },
  });

  const posts = [
    ['post-01', 'user-demo-01', 'Just finished the Flutter layout module. Loving the widget tree!'],
    ['post-02', 'user-demo-02', 'Python list comprehensions finally clicked today.'],
    ['post-03', 'user-demo-03', 'Shipped my first web app with TypeScript and React.'],
    ['post-04', 'user-demo-04', 'Remember to validate all untrusted input.'],
    ['post-05', 'user-demo-05', 'My first neural network is learning. Progress feels great.'],
    ['post-06', 'user-demo-06', 'Game dev tip: keep your update loop simple and deterministic.'],
  ];
  for (const [id, authorId, content] of posts) {
    await prisma.socialPost.upsert({
      where: { id },
      create: { id, authorId, content },
      update: { content },
    });
  }

  for (let index = 1; index <= 4; index += 1) {
    const userId = `user-demo-${String(index).padStart(2, '0')}`;
    await prisma.enrollment.upsert({
      where: { userId_courseId: { userId, courseId: 'course-flutter' } },
      create: { userId, courseId: 'course-flutter' },
      update: {},
    });
  }
}

async function main(): Promise<void> {
  await seedUsers();
  await seedCourses();
  await seedBadges();
  await seedSocial();
  console.log('Seed complete: 6 courses, 12 users, 8 badges and social demo data.');
}

void main()
  .catch((error: unknown) => {
    console.error(error);
    process.exitCode = 1;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
