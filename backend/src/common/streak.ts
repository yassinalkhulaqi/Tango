const DAY_IN_MS = 24 * 60 * 60 * 1000;

export interface StreakSnapshot {
  streakCount: number;
  longestStreak: number;
  continued: boolean;
  sameDay: boolean;
}

export function startOfUtcDay(date: Date): Date {
  return new Date(
    Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate()),
  );
}

export function daysBetween(from: Date, to: Date): number {
  return Math.round(
    (startOfUtcDay(to).getTime() - startOfUtcDay(from).getTime()) / DAY_IN_MS,
  );
}

export function calculateStreak(
  lastActiveAt: Date | null | undefined,
  streakCount: number,
  longestStreak: number,
  now: Date = new Date(),
): StreakSnapshot {
  const previous = lastActiveAt ? new Date(lastActiveAt) : null;
  const longest = Math.max(0, longestStreak, streakCount);

  if (!previous || Number.isNaN(previous.getTime())) {
    return { streakCount: 1, longestStreak: Math.max(1, longest), continued: false, sameDay: false };
  }

  const gap = daysBetween(previous, now);
  if (gap <= 0) {
    return {
      streakCount: Math.max(1, streakCount),
      longestStreak: longest,
      continued: true,
      sameDay: true,
    };
  }
  if (gap === 1) {
    const next = Math.max(1, streakCount) + 1;
    return {
      streakCount: next,
      longestStreak: Math.max(longest, next),
      continued: true,
      sameDay: false,
    };
  }
  return { streakCount: 1, longestStreak: longest, continued: false, sameDay: false };
}

export function isStreakActiveToday(
  lastActiveAt: Date | null | undefined,
  now: Date = new Date(),
): boolean {
  if (!lastActiveAt) return false;
  return daysBetween(new Date(lastActiveAt), now) === 0;
}
