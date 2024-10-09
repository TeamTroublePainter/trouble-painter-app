import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_pr/core/domain/entities/result.dart';
import 'package:x_pr/domain/game/game_repository_v2.dart';
import 'package:x_pr/features/auth/domain/entities/jwt.dart';
import 'package:x_pr/features/config/domain/entities/config.dart';
import 'package:x_pr/features/config/domain/entities/language.dart';
import 'package:x_pr/features/config/domain/services/config_service.dart';
import 'package:x_pr/features/game/data/sources/web_socket_source.dart';
import 'package:x_pr/features/game/domain/entities/game_channel.dart';

class GameWebSocketClient implements GameRepositoryV2 {
  static final $ = AutoDisposeProvider<GameRepositoryV2>((ref) {
    return GameWebSocketClient(
        webSocketSource: ref.read(WebSocketSource.$),
        config: ref.read(ConfigService.$),
    );
  });

  GameWebSocketClient({
    required this.webSocketSource,
    required this.config,
  });

  final WebSocketSource webSocketSource;
  final Config config;

  @override
  Future<Result<GameChannel>> connectQuick(Jwt jwt, Language language, String nickname) {
    return webSocketSource.connect("${config.baseSocketUrl}/mafia/quick", headers: {
      'Authorization': 'bearer ${jwt.accessToken}',
      'locale': language.locale.languageCode,
      'nickname': Uri.encodeComponent(nickname),
    },);
  }

  @override
  Future<Result<GameChannel>> connectRoom(Jwt jwt, Language language, String nickname, String? roomId) {
    return webSocketSource.connect("${config.baseSocketUrl}/mafia/room", headers: {
      'Authorization': 'bearer ${jwt.accessToken}',
      'locale': language.locale.languageCode,
      'nickname': Uri.encodeComponent(nickname),
      if (roomId != null) 'roomId': roomId,
    },);
  }
}
