import 'package:flutter/material.dart';
import 'package:x_pr/app/pages/login/widgets/login_button.dart';
import 'package:x_pr/app/pages/login/widgets/login_button/login_button_model.dart';
import 'package:x_pr/core/localization/generated/l10n.dart';
import 'package:x_pr/core/theme/foundations/app_theme.dart';
import 'package:x_pr/core/utils/platform/platform_info.dart';
import 'package:x_pr/features/auth/domain/entities/sign_in_method.dart';

class LoginLayout extends StatelessWidget {
  const LoginLayout({
    super.key,
    required this.viewModel,
  });

  final LoginButtonModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Login with Google
        LoginButton(
          text: S.current.loginWithGoogle,
          icon: "google_logo",
          onClick: () => viewModel.login(SignInMethod.google),
        ),

        if (!PlatformInfo.isAndroid) ...[
          const SizedBox(height: 12),

          /// Login with Apple
          LoginButton(
            text: S.current.loginWithApple,
            icon: "apple_logo",
            onClick: () => viewModel.login(SignInMethod.google),
          ),
        ],

        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => viewModel.login(SignInMethod.anonymous),
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              S.current.loginWithAnonymous,
              style: context.typo.subHeader1,
            ),
          ),
        ),
      ],
    );
  }
}
