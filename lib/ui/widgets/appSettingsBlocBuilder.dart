import 'package:aurora_teacher/cubits/appSettingsCubit.dart';
import 'package:aurora_teacher/ui/widgets/customCircularProgressIndicator.dart';
import 'package:aurora_teacher/ui/widgets/errorContainer.dart';
import 'package:aurora_teacher/utils/uiUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

class AppSettingsBlocBuilder extends StatelessWidget {
  final String appSettingsType;

  const AppSettingsBlocBuilder({Key? key, required this.appSettingsType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsCubit, AppSettingsState>(
      builder: (context, state) {
        if (state is AppSettingsFetchSuccess) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height *
                  (UiUtils.appBarSmallerHeightPercentage + 0.025),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Html(
                    data: state.appSettingsResult,
                  ),
                )
              ],
            ),
          );
        }
        if (state is AppSettingsFetchFailure) {
          return Center(
            child: ErrorContainer(
              errorMessageCode: state.errorMessage,
              onTapRetry: () {
                context
                    .read<AppSettingsCubit>()
                    .fetchAppSettings(type: appSettingsType);
              },
            ),
          );
        }
        return Center(
          child: CustomCircularProgressIndicator(
            indicatorColor: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }
}
