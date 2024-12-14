import 'package:aurora_teacher/ui/widgets/customRoundedButton.dart';
import 'package:aurora_teacher/utils/animationConfiguration.dart';
import 'package:aurora_teacher/utils/labelKeys.dart';
import 'package:aurora_teacher/utils/uiUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoDataContainer extends StatelessWidget {
  final Color? textColor;
  final String titleKey;
  final Function? onTapRetry;
  final Color? retryButtonBackgroundColor;
  final Color? retryButtonTextColor;
  final bool? showRetryButton;
  const NoDataContainer({
    Key? key,
    this.textColor,
    required this.titleKey,
    this.onTapRetry,
    this.retryButtonBackgroundColor,
    this.retryButtonTextColor,
    this.showRetryButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: customItemBounceScaleAppearanceEffects(),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * (0.025),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (0.35),
              child: SvgPicture.asset(UiUtils.getImagePath("fileNotFound.svg")),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (0.025),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                UiUtils.getTranslatedLabel(context, titleKey),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor ?? Theme.of(context).colorScheme.secondary,
                  fontSize: 16,
                ),
              ),
            ),
            if (showRetryButton ?? false)
              const SizedBox(
                height: 15,
              ),
            (showRetryButton ?? false)
                ? CustomRoundedButton(
                    height: 40,
                    widthPercentage: 0.3,
                    backgroundColor: retryButtonBackgroundColor ??
                        Theme.of(context).colorScheme.primary,
                    onTap: () {
                      onTapRetry?.call();
                    },
                    titleColor: retryButtonTextColor ??
                        Theme.of(context).scaffoldBackgroundColor,
                    buttonTitle: UiUtils.getTranslatedLabel(context, retryKey),
                    showBorder: false,
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
