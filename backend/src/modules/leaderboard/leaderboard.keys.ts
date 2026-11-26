export type LeaderboardPeriod = 'weekly' | 'monthly' | 'allTime' | 'friends';

export const LEADERBOARD_PERIODS: LeaderboardPeriod[] = [
  'weekly',
  'monthly',
  'allTime',
  'friends',
];

export function isoWeekKey(date: Date = new Date()): string {
  const day = new Date(
    Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate()),
  );
  const weekDay = day.getUTCDay() || 7;
  day.setUTCDate(day.getUTCDate() + 4 - weekDay);
  const yearStart = new Date(Date.UTC(day.getUTCFullYear(), 0, 1));
  const week = Math.ceil(
    ((day.getTime() - yearStart.getTime()) / 86_400_000 + 1) / 7,
  );
  return `${day.getUTCFullYear()}-W${String(week).padStart(2, '0')}`;
}

export function monthKey(date: Date = new Date()): string {
  return `${date.getUTCFullYear()}-${String(date.getUTCMonth() + 1).padStart(2, '0')}`;
}

export function leaderboardKey(
  period: LeaderboardPeriod,
  userId?: string,
): string {
  switch (period) {
    case 'weekly':
      return `lb:weekly:${isoWeekKey()}`;
    case 'monthly':
      return `lb:monthly:${monthKey()}`;
    case 'friends':
      return `lb:friends:${userId ?? 'global'}`;
    default:
      return 'lb:allTime';
  }
}
