import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_pr/core/domain/entities/result.dart';
import 'package:x_pr/core/utils/log/dio_logger.dart';
import 'package:x_pr/features/auth/domain/entities/jwt.dart';
import 'package:x_pr/features/config/domain/services/config_service.dart';

class AuthClient {
  static final $ = AutoDisposeProvider<AuthClient>((ref) {
    var config = ref.read(ConfigService.$);
    var option = BaseOptions(
      baseUrl: config.baseUrl.toString(),
    );

    return AuthClient(
      dio: Dio(option)..interceptors.add(DioLogger()),
    );
  });

  final Dio dio;

  const AuthClient({
    required this.dio,
  });

  Future<Result<Jwt>> reissue(String refreshToken) async {
    try {
      final response = await dio.post(
        '/api/v1/auth/reissue',
        data: {
          'refreshToken': refreshToken,
        },
      );

      return Success(Jwt.fromJson(response.data));
    } catch (e) {
      return Failure(e);
    }
  }
}
