import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_pr/core/data/sources/dio_source.dart';
import 'package:x_pr/core/domain/entities/result.dart';
import 'package:x_pr/features/auth/data/repositories/auth_repository.dart';
import 'package:x_pr/features/auth/domain/entities/auth_state.dart';
import 'package:x_pr/features/auth/domain/entities/jwt.dart';
import 'package:x_pr/features/auth/domain/services/auth_service.dart';
import 'package:x_pr/features/auth/domain/usecases/refresh_access_token_usecase.dart';

class XprAuthInterceptor extends Interceptor {
  static final $ = AutoDisposeProvider<XprAuthInterceptor>((ref) {
    final jwt = switch (ref.read(AuthService.$)) {
      Unauthenticated() => null,
      Authenticated(authState: final authState) => authState.jwt,
    };

    return XprAuthInterceptor(
      authRepository: ref.read(AuthRepository.$),
      jwt: jwt,
      dio: ref.read(DioSource.$),
    );
  });

  final AuthRepository authRepository;
  final Dio dio;
  Jwt? _jwt;
  Completer<void>? _refreshCompleter;

  XprAuthInterceptor({
    required this.authRepository,
    required this.dio,
    required Jwt? jwt,
  }) : _jwt = jwt;

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler,) async {
    if (_jwt != null) {
      options.headers['Authorization'] = 'bearer ${_jwt?.accessToken}';
    }

    return super.onRequest(options, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 Unauthorized 에러가 발생했을 때 처리
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    try {
      if (_refreshCompleter != null) {
        // 만약 다른 요청이 이미 재로그인을 진행하고 있다면, 기다렸다가 진행
        await _refreshCompleter?.future;
      } else {
        _refreshCompleter = Completer<void>();
        await reissue();
      }

      final newHeader = Map<String, dynamic>.from(err.requestOptions.headers);
      newHeader['Authorization'] = 'bearer ${_jwt?.accessToken}';

      final retryRequest = await dio.request(
        err.requestOptions.path,
        options: Options(
          method: err.requestOptions.method,
          headers: newHeader,
        ),
        data: err.requestOptions.data,
        queryParameters: err.requestOptions.queryParameters,
      );
      handler.resolve(retryRequest);
    } catch (e) {
      handler.next(err);
    }
  }

  Future<void> reissue() async {
    try {
      final refreshToken = _jwt?.refreshToken;
      if (refreshToken == null) {
        _refreshCompleter?.completeError(RefreshAccessTokenException.unauthenticated);
        return;
      }

      final result = await authRepository.refreshAccessToken(refreshToken);

      if (result is Success == false) {
        _refreshCompleter?.completeError(RefreshAccessTokenException.unauthenticated);
        return;
      }

      _jwt = (result as Success<AuthState>).value.jwt;

      _refreshCompleter?.complete();
    } catch (e) {
      // 재로그인 중 에러 발생 시 처리
      _refreshCompleter?.completeError(e);
    } finally {
      _refreshCompleter = null;
    }
  }
}
