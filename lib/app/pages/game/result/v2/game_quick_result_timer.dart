import 'package:flutter/material.dart';
import 'package:x_pr/core/localization/generated/l10n.dart';
import 'package:x_pr/core/theme/components/buttons/button/button.dart';
import 'package:x_pr/core/theme/components/circular_timer/circular_timer.dart';
import 'package:x_pr/core/theme/foundations/app_theme.dart';

class GameQuickResultTimer extends StatelessWidget {
  const GameQuickResultTimer({
    super.key,
    required this.startedAt,
    required this.totalMs,
    required this.isMafiaWin,
    required this.onClickRestart,
    required this.onEnd,
  });

  final DateTime startedAt;
  final int totalMs;
  final bool isMafiaWin;
  final void Function() onClickRestart;
  final void Function() onEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Button(
          text: S.current.gameResultV2ReQuickGame,
          size: ButtonSize.regular,
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 18,
          ),
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 12,
          ),
          shadow: [
            BoxShadow(
              color: context.color.primary.withOpacity(0.5),
              blurRadius: 20.5, // Figma에서 설정된 Blur
            ),
          ],
          onPressed: onClickRestart,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularTimer(
              startedAt: startedAt,
              totalMs: totalMs,
              onEnd: onEnd,
              builder: (secAnimation) {
                return Text(
                  S.current.sec(secAnimation.value),
                  style: context.typo.body2.copyWith(
                    color: isMafiaWin
                        ? context.color.primary
                        : context.color.secondary,
                  ),
                );
              },
            ),
            Text(
              ' ${S.current.gameResultV2TimerDesc}',
              style: context.typo.body2.copyWith(
                color: context.color.subtext4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 60),
      ],
    );
  }
}
