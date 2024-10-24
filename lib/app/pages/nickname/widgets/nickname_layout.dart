import 'dart:math';

import 'package:flutter/material.dart';
import 'package:x_pr/core/theme/components/anims/anim_trans_opacity.dart';
import 'package:x_pr/core/theme/components/buttons/button/button.dart';
import 'package:x_pr/core/theme/res/layout.dart';
import 'package:x_pr/core/utils/ext/widget_ext.dart';

class NicknameLayout extends StatelessWidget {
  const NicknameLayout({
    super.key,
    required this.title,
    required this.input,
    required this.submitButton,
  });

  final Widget title;
  final Widget input;
  final Button submitButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: context.responsiveH(
        true,
        small: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 66,
                        left: 20,
                        right: 20,
                        bottom: 40,
                      ),
                      child: title,
                    ),

                    /// Input
                    input,
                  ],
                ),
              ),
            ),

            /// Submit button
            submitButton,
          ].conditionalWrap(
            builder: (child, index) => AnimTransOpacity(
              delayIndex: index,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
