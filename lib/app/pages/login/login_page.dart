import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:x_pr/app/pages/login/widgets/login_button/login_button_model.dart';
import 'package:x_pr/app/pages/login/widgets/login_layout.dart';
import 'package:x_pr/app/routes/routes.dart';
import 'package:x_pr/core/localization/generated/l10n.dart';
import 'package:x_pr/core/theme/foundations/app_theme.dart';
import 'package:x_pr/core/view/base_view.dart';
import 'package:x_pr/core/view/base_view_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseView(
        viewModel: LoginButtonModel.new,
        state: (ref, prevState) => BaseViewState.init,
        onStateChanged: (ref, viewModel, state, oldState) {
          switch (state) {
            case BaseViewState.success:
              context.goNamed(
                viewModel.hasNickname
                    ? Routes.nicknamePage.name
                    : Routes.homePage.name,
              );
              break;
            case BaseViewState.failure:
              break;
            default:
              break;
          }
        },
        builder: (ref, viewModel, state) => Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            LoginLayout(viewModel: viewModel),
            const SizedBox(height: 40),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: viewModel.showTermsOfService,
                child: AutoSizeText.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: S.current.loginAgreement1),
                      TextSpan(
                        text: S.current.termsOfService,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: context.color.subtext5,
                        ),
                      ),
                      TextSpan(text: S.current.loginAgreement2),
                    ],
                  ),
                  minFontSize: 6,
                  textAlign: TextAlign.center,
                  style: context.typo.caption1.copyWith(
                    color: context.color.subtext4,
                    fontSize: 13,
                    fontWeight: context.typo.regular,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 54),
          ],
        ),
      ),
    );
  }
}
