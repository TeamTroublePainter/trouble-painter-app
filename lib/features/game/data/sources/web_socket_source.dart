import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/io.dart';
import 'package:x_pr/core/domain/entities/result.dart';
import 'package:x_pr/core/utils/env/constant.dart';
import 'package:x_pr/core/utils/log/logger.dart';
import 'package:x_pr/features/game/data/models/x/x_game_channel.dart';
import 'package:x_pr/features/game/domain/entities/game_channel.dart';

class WebSocketSource {
  static final $ = AutoDisposeProvider<WebSocketSource>((ref) {
    return WebSocketSource();
  });

  Future<Result<GameChannel>> connect(String uri, {Map<String, dynamic>? headers, Duration timeout = Constant.connectionTimeout}) async {
    try {
      final wsUrl = Uri.parse(uri);

      final channel = IOWebSocketChannel.connect(wsUrl, headers: headers);
      //WebSocketChannel.connect(wsUrl);
      await channel.ready.timeout(timeout);
      return Success(XGameChannel(channel));
    } on SocketException catch (e, s) {
      Logger.e('Failed to connect', e, s);
      return Failure(e);
    } on Exception catch (e, s) {
      // on WebSocketChannelException catch (e, s) {
      Logger.e('Failed to connect', e, s);
      return Failure(e);
      // }
    }
  }
}
