import 'dart:async';

import 'package:x_pr/core/domain/entities/result.dart';
import 'package:x_pr/features/auth/domain/entities/jwt.dart';
import 'package:x_pr/features/config/domain/entities/language.dart';
import 'package:x_pr/features/game/domain/entities/game_channel.dart';

abstract interface class GameRepositoryV2 {
  Future<Result<GameChannel>> connectQuick(Jwt jwt, Language language, String nickname);

  Future<Result<GameChannel>> connectRoom(Jwt jwt, Language language, String nickname, String? roomId);
}
