import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_pr/adapter/xpr-client/interceptor/xpr_auth_interceptor.dart';
import 'package:x_pr/core/utils/log/dio_logger.dart';
import 'package:x_pr/features/auth/domain/entities/jwt.dart';
import 'package:x_pr/features/auth/domain/services/auth_service.dart';

abstract class AuthDioSource {
  static final $ = AutoDisposeProvider<Dio>((ref) {
    final authServiceState = ref.read(AuthService.$);
    final Jwt? jwt = switch (authServiceState) {
      Unauthenticated() => null,
      Authenticated(authState: final authState) => authState.jwt,
    };

    final dio = Dio();

    dio.interceptors
      ..add(ref.read(XprAuthInterceptor.$))
      ..add(DioLogger());

    return dio;

    // return Dio()
    //   ..interceptors.add(
    //     DioLogger(
    //       onRequest: (options) {
    //         if (jwt != null) {
    //           options.headers['Authorization'] = 'bearer ${jwt.accessToken}';
    //         }
    //       },
    //     ),
    //   );
  });
}
