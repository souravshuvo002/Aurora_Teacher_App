import 'package:aurora_teacher/data/models/reviewAssignmentssubmition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aurora_teacher/cubits/editreviewassignmetcubit.dart';
import 'package:aurora_teacher/data/models/assignment.dart';
import 'package:aurora_teacher/ui/widgets/bottomSheetTextFiledContainer.dart';
import 'package:aurora_teacher/ui/widgets/bottomSheetTopBarMenu.dart';
import 'package:aurora_teacher/ui/widgets/customCircularProgressIndicator.dart';
import 'package:aurora_teacher/ui/widgets/customRoundedButton.dart';
import 'package:aurora_teacher/utils/labelKeys.dart';
import 'package:aurora_teacher/utils/uiUtils.dart';

class RejectAssignmentBottomsheetContainer extends StatefulWidget {
  final Assignment assignment;
  final ReviewAssignmentssubmition reviewAssignment;
  const RejectAssignmentBottomsheetContainer({
    Key? key,
    required this.assignment,
    required this.reviewAssignment,
  }) : super(key: key);

  @override
  State<RejectAssignmentBottomsheetContainer> createState() =>
      _RejectAssignmentBottomsheetContainerState();
}

class _RejectAssignmentBottomsheetContainerState
    extends State<RejectAssignmentBottomsheetContainer> {
  late final TextEditingController _remarkTextEditingController =
      TextEditingController();
  void showErrorMessage(String errorMessage) {
    UiUtils.showBottomToastOverlay(
      context: context,
      errorMessage: errorMessage,
      backgroundColor: Theme.of(context).colorScheme.error,
    );
  }

  void updateReviewAssignment() {
    if (_remarkTextEditingController.text.trim().isEmpty) {
      showErrorMessage(
        UiUtils.getTranslatedLabel(context, pleaseEnterRemarkkey),
      );
    } else {
      context.read<EditReviewAssignmetCubit>().updateReviewAssignmet(
            reviewAssignmetId: widget.reviewAssignment.id,
            reviewAssignmentFeedBack: _remarkTextEditingController.text.trim(),
            reviewAssignmentPoints: "0",
            reviewAssignmentStatus: 2,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BottomSheetTopBarMenu(
              onTapCloseButton: () {
                Navigator.of(context).pop();
              },
              title: UiUtils.getTranslatedLabel(context, rejectKey),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: UiUtils.bottomSheetHorizontalContentPadding,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * (0.0125),
                  ),
                  BottomSheetTextFieldContainer(
                    hintText: UiUtils.getTranslatedLabel(context, addRemarkKey),
                    maxLines: 2,
                    textEditingController: _remarkTextEditingController,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * (0.025),
                  ),
                  BlocConsumer<EditReviewAssignmetCubit,
                      EditReviewAssignmetState>(
                    listener: (context, state) {
                      if (state is EditReviewAssignmetSuccess) {
                        UiUtils.showBottomToastOverlay(
                          context: context,
                          errorMessage: UiUtils.getTranslatedLabel(
                            context,
                            reviewAssignmentsucessfullukey,
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                        );
                        Navigator.of(context).pop(
                          widget.reviewAssignment.copywith(
                            id: widget.reviewAssignment.id,
                            feedback: _remarkTextEditingController.text.trim(),
                            status: 2,
                          ),
                        );
                      }
                      if (state is EditReviewAssignmetFailure) {
                        UiUtils.showBottomToastOverlay(
                          context: context,
                          errorMessage: UiUtils.getTranslatedLabel(
                            context,
                            failureAssignmentReviewkey,
                          ),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        );
                        Navigator.of(context).pop();
                      }
                    },
                    builder: (context, state) {
                      return CustomRoundedButton(
                        height: UiUtils.bottomSheetButtonHeight,
                        widthPercentage:
                            UiUtils.bottomSheetButtonWidthPercentage,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        buttonTitle:
                            UiUtils.getTranslatedLabel(context, submitKey),
                        showBorder: false,
                        child: state is EditReviewAssignmetInProgress
                            ? const CustomCircularProgressIndicator(
                                strokeWidth: 2,
                                widthAndHeight: 20,
                              )
                            : null,
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          updateReviewAssignment();
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * (0.05),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onWillPop: () {
        return Future.value(true);
      },
    );
  }
}
