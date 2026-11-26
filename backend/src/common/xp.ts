export function xpForLevel(level: number): number {
  if (level <= 1) return 0;
  let total = 0;
  for (let current = 2; current <= level; current += 1) {
    total += 100 + (current - 2) * 50;
  }
  return total;
}

export function levelFromXp(xp: number): number {
  const safeXp = Math.max(0, Math.floor(xp));
  let level = 1;
  while (safeXp >= xpForLevel(level + 1)) level += 1;
  return level;
}

export function xpProgressInLevel(
  xp: number,
): { current: number; required: number; percentage: number } {
  const level = levelFromXp(xp);
  const floor = xpForLevel(level);
  const ceiling = xpForLevel(level + 1);
  const current = Math.max(0, xp - floor);
  const required = ceiling - floor;
  return {
    current,
    required,
    percentage: required === 0 ? 100 : Math.round((current / required) * 100),
  };
}

export interface XpAwardResult {
  xp: number;
  level: number;
  leveledUp: boolean;
}

export function applyXp(currentXp: number, amount: number): XpAwardResult {
  const previousLevel = levelFromXp(currentXp);
  const xp = Math.max(0, currentXp + amount);
  const level = levelFromXp(xp);
  return { xp, level, leveledUp: level > previousLevel };
}
