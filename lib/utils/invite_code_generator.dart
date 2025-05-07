import 'dart:math';

String generateInviteCode() {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  Random rand = Random();
  return List.generate(6, (_) => chars[rand.nextInt(chars.length)]).join();
}