import 'package:x_pr/core/domain/entities/result.dart';
import 'package:x_pr/core/utils/ext/uri_ext.dart';
import 'package:x_pr/core/view/base_view_model.dart';
import 'package:x_pr/core/view/base_view_state.dart';
import 'package:x_pr/features/analytics/domain/entities/app_event/app_event.dart';
import 'package:x_pr/features/analytics/domain/services/analytics_service.dart';
import 'package:x_pr/features/auth/domain/entities/sign_in_method.dart';
import 'package:x_pr/features/auth/domain/services/auth_service.dart';
import 'package:x_pr/features/config/domain/entities/config.dart';
import 'package:x_pr/features/config/domain/services/config_service.dart';

class LoginButtonModel extends BaseViewModel<BaseViewState> {
  LoginButtonModel(super.initState);
  Config get config => ref.read(ConfigService.$);
  AnalyticsService get analyticsService => ref.read(AnalyticsService.$);

  Future<Result> login(SignInMethod signInMethod) async {
    final res = await ref.read(AuthService.$.notifier).login(signInMethod);
    switch (res) {
      case Success():
        state = BaseViewState.success;
        break;
      case Failure():
        state = BaseViewState.failure;
        break;
      case Cancel():
        break;
    }
    return res;
  }

  void showTermsOfService() {
    config.termsOfServiceUrl.launchBrowser();

    /// Send event
    analyticsService.sendEvent(NicknamePageTermsOfServiceClickEvent());
  }
}
