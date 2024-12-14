import 'package:aurora_teacher/app/routes.dart';
import 'package:aurora_teacher/cubits/studentCompletedExamWithResultCubit.dart';
import 'package:aurora_teacher/data/models/studentResult.dart';
import 'package:aurora_teacher/ui/widgets/customRefreshIndicator.dart';
import 'package:aurora_teacher/ui/widgets/customShimmerContainer.dart';
import 'package:aurora_teacher/ui/widgets/errorContainer.dart';
import 'package:aurora_teacher/ui/widgets/listItemForExamAndResult.dart';
import 'package:aurora_teacher/ui/widgets/noDataContainer.dart';
import 'package:aurora_teacher/ui/widgets/shimmerLoadingContainer.dart';
import 'package:aurora_teacher/utils/animationConfiguration.dart';
import 'package:aurora_teacher/utils/labelKeys.dart';

import 'package:aurora_teacher/utils/uiUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResultsContainer extends StatefulWidget {
  final int? studentId;
  final String? studentName;
  final String? className;
  final int classSectionId;

  const ResultsContainer(
      {Key? key,
      this.studentId,
      this.studentName,
      this.className,
      required this.classSectionId})
      : super(key: key);

  @override
  State<ResultsContainer> createState() => _ResultsContainerState();
}

class _ResultsContainerState extends State<ResultsContainer> {
  void fetchCompletedExamList() {
    context
        .read<StudentCompletedExamWithResultCubit>()
        .fetchStudentCompletedExamWithResult(studentId: widget.studentId!);
  }

  Widget _buildResultListShimmerLoadingContainer() {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 20,
      ),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(
        horizontal: UiUtils.screenContentHorizontalPaddingPercentage *
            MediaQuery.of(context).size.width,
      ),
      child: ShimmerLoadingContainer(
        child: LayoutBuilder(
          builder: (context, boxConstraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                    height: 9,
                    width: boxConstraints.maxWidth * (0.3),
                  ),
                ),
                SizedBox(
                  height: boxConstraints.maxWidth * (0.02),
                ),
                ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                    height: 10,
                    width: boxConstraints.maxWidth * (0.8),
                  ),
                ),
                SizedBox(
                  height: boxConstraints.maxWidth * (0.1),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildResultLoading() {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: UiUtils.appBarMediumtHeightPercentage *
                MediaQuery.of(context).size.height,
            right: 20.0,
            left: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              UiUtils.defaultShimmerLoadingContentCount,
              (index) => _buildResultListShimmerLoadingContainer(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) => fetchCompletedExamList());
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: CustomRefreshIndicator(
        onRefreshCallback: () {
          fetchCompletedExamList();
        },
        displacment: UiUtils.getScrollViewTopPadding(
          context: context,
          appBarHeightPercentage: UiUtils.appBarSmallerHeightPercentage,
        ),
        child: BlocBuilder<StudentCompletedExamWithResultCubit,
            StudentCompletedExamWithResultState>(
          builder: (context, state) {
            if (state is StudentCompletedExamWithResultFetchFailure) {
              return Center(
                child: ErrorContainer(
                  errorMessageCode: state.errorMessage,
                  onTapRetry: () {
                    fetchCompletedExamList();
                  },
                ),
              );
            } else if (state is StudentCompletedExamWithResultFetchSuccess) {
              return state.studentCompletedExamWithResultList.isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: UiUtils.getScrollViewTopPadding(
                          context: context,
                          appBarHeightPercentage:
                              UiUtils.appBarSmallerHeightPercentage,
                        ),
                      ),
                      child: const NoDataContainer(titleKey: noExamsKey),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.only(
                        top: UiUtils.getScrollViewTopPadding(
                          context: context,
                          appBarHeightPercentage:
                              UiUtils.appBarSmallerHeightPercentage,
                        ),
                      ),
                      itemCount:
                          state.studentCompletedExamWithResultList.length,
                      itemBuilder: (context, index) {
                        StudentResult resultData =
                            state.studentCompletedExamWithResultList[index];
                        return Animate(
                          effects: listItemAppearanceEffects(
                              itemIndex: index,
                              totalLoadedItems: state
                                  .studentCompletedExamWithResultList.length),
                          child: ListItemForExamAndResult(
                            examName: resultData.examName!,
                            examStartingDate: resultData.examDate!,
                            className: widget.className!,
                            resultGrade: resultData.result != {} &&
                                    resultData.result != null
                                ? resultData.result!.grade!
                                : '',
                            resultPercentage: resultData.result != {} &&
                                    resultData.result != null &&
                                    resultData.result!.percentage != null
                                ? resultData.result!.percentage!
                                : 0,
                            onItemTap: () {
                              Navigator.of(context).pushNamed(
                                Routes.addResult,
                                arguments: {
                                  'studentResultData': resultData,
                                  'studentName': widget.studentName,
                                  'studentId': widget.studentId,
                                  'classSectionId': widget.classSectionId,
                                },
                              ).then((value) {
                                //If marks is submitted then re-call the API to get updated data
                                if (value == 'true') {
                                  fetchCompletedExamList();
                                }
                              });
                            },
                          ),
                        );

                        //_buildCompletedExamListContainer(studentExamList: state.studentCompletedExamWithResultList[index]);
                      },
                    );
            }
            return _buildResultLoading();
          },
        ),
      ),
    );
  }
}
