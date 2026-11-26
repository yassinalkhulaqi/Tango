import {
  applyXp,
  levelFromXp,
  xpForLevel,
  xpProgressInLevel,
} from './xp';

describe('xp helpers', () => {
  it('starts at level 1 with zero XP', () => {
    expect(xpForLevel(1)).toBe(0);
    expect(levelFromXp(0)).toBe(1);
  });

  it('computes monotonic level thresholds', () => {
    expect(xpForLevel(2)).toBe(100);
    expect(xpForLevel(3)).toBe(250);
    expect(xpForLevel(4)).toBe(450);
    expect(levelFromXp(99)).toBe(1);
    expect(levelFromXp(100)).toBe(2);
    expect(levelFromXp(249)).toBe(2);
    expect(levelFromXp(250)).toBe(3);
  });

  it('never returns a negative level or XP', () => {
    expect(levelFromXp(-50)).toBe(1);
    expect(applyXp(10, -100).xp).toBe(0);
  });

  it('reports progress inside the current level', () => {
    expect(xpProgressInLevel(100)).toEqual({ current: 0, required: 150, percentage: 0 });
    expect(xpProgressInLevel(175)).toEqual({ current: 75, required: 150, percentage: 50 });
  });

  it('detects level ups', () => {
    expect(applyXp(90, 20)).toEqual({ xp: 110, level: 2, leveledUp: true });
    expect(applyXp(110, 10)).toEqual({ xp: 120, level: 2, leveledUp: false });
  });
});
