
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../../app/routes.dart';
import '../../../cubits/appConfigurationCubit.dart';
import '../../../utils/labelKeys.dart';
import '../../../utils/uiUtils.dart';
import '../../widgets/customRoundedButton.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  late final AnimationController _bottomMenuHeightAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );

  late final Animation<double> _bottomMenuHeightUpAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _bottomMenuHeightAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ),
  );
  late final Animation<double> _bottomMenuHeightDownAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _bottomMenuHeightAnimationController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
    ),
  );

  Future<void> startAnimation() async {
    //cupertino page transtion duration
    await Future.delayed(const Duration(milliseconds: 300));

    _bottomMenuHeightAnimationController.forward();
  }

  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  @override
  void dispose() {
    _bottomMenuHeightAnimationController.dispose();
    super.dispose();
  }

  Widget _buildLottieAnimation() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top +
              MediaQuery.of(context).size.height * (0.05),
        ),
        height: MediaQuery.of(context).size.height * (0.4),
        child: SvgPicture.asset(
          UiUtils.getImagePath("splash.svg"),
        ),

      ),
    );
  }

  Widget _buildBottomMenu() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedBuilder(
        animation: _bottomMenuHeightAnimationController,
        builder: (context, child) {
          final height = MediaQuery.of(context).size.height *
                  (0.525) *
                  _bottomMenuHeightUpAnimation.value -
              MediaQuery.of(context).size.height *
                  (0.05) *
                  _bottomMenuHeightDownAnimation.value;
          return Container(
            width: MediaQuery.of(context).size.width,
            height: height,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: AnimatedSwitcher(
              switchInCurve: Curves.easeInOut,
              duration: const Duration(milliseconds: 400),
              child: _bottomMenuHeightAnimationController.value != 1.0
                  ? const SizedBox()
                  : LayoutBuilder(
                      builder: (context, boxConstraints) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * (0.1),
                              ),
                              child: Text(
                                context
                                    .read<AppConfigurationCubit>()
                                    .getAppConfiguration()
                                    .schoolName,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      UiUtils.getColorScheme(context).secondary,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: boxConstraints.maxHeight * (0.0125),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * (0.1),
                              ),
                              child: Text(
                                context
                                    .read<AppConfigurationCubit>()
                                    .getAppConfiguration()
                                    .schoolTagline,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w300,
                                  color: UiUtils.getColorScheme(context)
                                      .onBackground,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: boxConstraints.maxHeight * (0.05),
                            ),
                            CustomRoundedButton(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  Routes.teacherLogin,
                                );
                              },
                              widthPercentage: 0.8,
                              backgroundColor:
                                  UiUtils.getColorScheme(context).primary,
                              buttonTitle:
                                  "${UiUtils.getTranslatedLabel(context, loginAsKey)} ${UiUtils.getTranslatedLabel(context, teacherKey)}",
                              showBorder: false,
                            ),
                            SizedBox(
                              height: boxConstraints.maxHeight * (0.04),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          _buildLottieAnimation(),
          _buildBottomMenu(),
        ],
      ),
    );
  }
}
