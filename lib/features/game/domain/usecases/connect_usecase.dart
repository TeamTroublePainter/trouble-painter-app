import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_pr/adapter/xpr-client/game_client.dart';
import 'package:x_pr/core/domain/entities/result.dart';
import 'package:x_pr/domain/game/game_repository_v2.dart';
import 'package:x_pr/features/auth/domain/entities/jwt.dart';
import 'package:x_pr/features/config/domain/entities/config.dart';
import 'package:x_pr/features/config/domain/entities/language.dart';
import 'package:x_pr/features/config/domain/services/config_service.dart';
import 'package:x_pr/features/game/data/repositories/game_repository.dart';
import 'package:x_pr/features/game/domain/entities/game_channel.dart';
import 'package:x_pr/features/game/domain/entities/game_exception/game_exception.dart';
import 'package:x_pr/features/network/domain/entities/network_state.dart';
import 'package:x_pr/features/network/domain/services/network_service.dart';

class ConnectUsecaseParam {
  final Duration timeout;

  ConnectUsecaseParam(this.timeout);
}

class ConnectUsecase{
  static final $ = AutoDisposeProvider<ConnectUsecase>((ref) {
    return ConnectUsecase(
      gameRepository: ref.read(GameRepository.$),
      gameRepositoryNew: ref.read(GameWebSocketClient.$),
      networkState: ref.read(NetworkService.$),
      config: ref.read(ConfigService.$),
    );
  });

  ConnectUsecase({
    required this.gameRepository,
    required this.gameRepositoryNew,
    required this.networkState,
    required this.config,
  });

  final NetworkState networkState;
  final GameRepository gameRepository;
  final GameRepositoryV2 gameRepositoryNew;
  final Config config;

  Future<GameChannel> connectQuick(Jwt jwt, Language language, String nickname) async {
    switch (networkState) {
      case NetworkState.connected:
        var result = await gameRepositoryNew.connectQuick(jwt, language, nickname);
        return _processResult(result);
      case NetworkState.disconnected:
        throw GameException.networkNotConnected;
    }
  }

  Future<GameChannel> connectRoom(Jwt jwt, Language language, String nickname, [String? roomId]) async {
    switch (networkState) {
      case NetworkState.connected:
        var result = await gameRepositoryNew.connectRoom(jwt, language, nickname, roomId);
        return _processResult(result);
      case NetworkState.disconnected:
        throw GameException.networkNotConnected;
    }
  }

  Future<GameChannel> call(ConnectUsecaseParam param) async {
    switch (networkState) {
      case NetworkState.connected:
        return await _connect(
          config.baseSocketUrl,
          param.timeout,
        );
      case NetworkState.disconnected:
        throw GameException.networkNotConnected;
    }
  }

  Future<GameChannel> _connect(Uri uri, Duration timeout) async {
    return _processResult(await gameRepository.connect(
      uri: uri,
      timeout: timeout,
    ),);
  }

  Future<GameChannel> _processResult(Result<GameChannel> result) async {
    return switch (result) {
      Success(value: final channel) => channel,
      Failure(e: final e) => throw e,
      Cancel() => throw const Cancel(),
    };
  }
}
