import 'package:aurora_teacher/app/routes.dart';
import 'package:aurora_teacher/cubits/appConfigurationCubit.dart';
import 'package:aurora_teacher/cubits/authCubit.dart';
import 'package:aurora_teacher/cubits/userProfileCubit.dart';
import 'package:aurora_teacher/data/repositories/authRepository.dart';
import 'package:aurora_teacher/ui/widgets/errorContainer.dart';
import 'package:aurora_teacher/utils/animationConfiguration.dart';
import 'package:aurora_teacher/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<UserProfileCubit>(
            create: (_) => UserProfileCubit(AuthRepository()),
          ),
        ],
        child: const SplashScreen(),
      ),
    );
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    fetchAppConfiguration();
  }

  void fetchAndSetUserProfile() {
    Future.delayed(Duration.zero, () {
      context.read<UserProfileCubit>().fetchAndSetUserProfile();
    });
  }

  void fetchAppConfiguration() {
    Future.delayed(Duration.zero, () {
      context.read<AppConfigurationCubit>().fetchAppConfiguration();
    });
  }

  void navigateToNextScreen() {
    if (context.read<AuthCubit>().state is Unauthenticated) {
      Navigator.of(context).pushReplacementNamed(Routes.login);
    } else {
      Navigator.of(context).pushReplacementNamed(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UserProfileCubit, UserProfileState>(
        listener: (context, profileState) {
          if (profileState is UserProfileFetchSuccess) {
            navigateToNextScreen();
          }
        },
        builder: (context, profileState) {
          return BlocConsumer<AppConfigurationCubit, AppConfigurationState>(
            listener: (context, appConfigState) {
              if (appConfigState is AppConfigurationFetchSuccess) {
                fetchAndSetUserProfile();
              }
            },
            builder: (context, appConfigState) {
              if (appConfigState is AppConfigurationFetchFailure) {
                return Center(
                  child: ErrorContainer(
                    onTapRetry: () {
                      fetchAppConfiguration();
                    },
                    errorMessageCode: appConfigState.errorMessage,
                  ),
                );
              } else if (profileState is UserProfileFetchFailure) {
                return Center(
                  child: ErrorContainer(
                    onTapRetry: () {
                      fetchAndSetUserProfile();
                    },
                    errorMessageCode: profileState.errorMessage,
                  ),
                );
              }
              return Center(
                child: Animate(
                  effects: customItemZoomAppearanceEffects(
                    delay: const Duration(
                      milliseconds: 10,
                    ),
                    duration: const Duration(
                      seconds: 1,
                    ),
                  ),
                  child: SvgPicture.asset(
                    UiUtils.getImagePath("appLogo.png"),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
