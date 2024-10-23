import 'package:flutter/cupertino.dart';
import 'package:x_pr/core/theme/components/icons/asset_icon.dart';
import 'package:x_pr/core/theme/foundations/app_theme.dart';
import 'package:x_pr/core/theme/res/palette.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.text,
    required this.icon,
    this.onClick,
  });

  /// Click event
  final void Function()? onClick;

  final String text;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        onClick?.call();
      },
      child: Container(
        height: 54,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: Palette.white,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: AssetIcon(
                icon,
                useIconColor: true,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                text,
                style: context.typo.subHeader1.copyWith(color: Palette.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
