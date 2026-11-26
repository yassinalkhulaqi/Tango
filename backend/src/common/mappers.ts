import { User } from '@prisma/client';

type UserCore = Pick<
  User,
  | 'id'
  | 'email'
  | 'displayName'
  | 'avatarUrl'
  | 'bio'
  | 'locale'
  | 'xp'
  | 'level'
  | 'streakCount'
  | 'longestStreak'
  | 'role'
  | 'createdAt'
>;

export function toPublicUser(user: UserCore) {
  return {
    id: user.id,
    email: user.email,
    displayName: user.displayName,
    avatarUrl: user.avatarUrl,
    bio: user.bio,
    locale: user.locale,
    xp: user.xp,
    level: user.level,
    streakCount: user.streakCount,
    longestStreak: user.longestStreak,
    role: user.role,
    createdAt: user.createdAt,
  };
}

export function toPublicProfile(user: UserCore) {
  const { email: _email, ...profile } = toPublicUser(user);
  return profile;
}
