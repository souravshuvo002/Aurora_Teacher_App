import 'package:aurora_teacher/app/routes.dart';
import 'package:aurora_teacher/cubits/lessonsCubit.dart';
import 'package:aurora_teacher/cubits/myClassesCubit.dart';
import 'package:aurora_teacher/cubits/subjectsOfClassSectionCubit.dart';
import 'package:aurora_teacher/data/models/subject.dart';
import 'package:aurora_teacher/data/repositories/lessonRepository.dart';
import 'package:aurora_teacher/data/repositories/teacherRepository.dart';
import 'package:aurora_teacher/ui/widgets/classSubjectsDropDownMenu.dart';
import 'package:aurora_teacher/ui/widgets/customAppbar.dart';
import 'package:aurora_teacher/ui/widgets/customDropDownMenu.dart';
import 'package:aurora_teacher/ui/widgets/customFloatingActionButton.dart';
import 'package:aurora_teacher/ui/widgets/customRefreshIndicator.dart';
import 'package:aurora_teacher/ui/widgets/lessonsContainer.dart';
import 'package:aurora_teacher/ui/widgets/myClassesDropDownMenu.dart';
import 'package:aurora_teacher/utils/labelKeys.dart';
import 'package:aurora_teacher/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({Key? key}) : super(key: key);

  static Route<dynamic> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LessonsCubit(LessonRepository()),
          ),
          BlocProvider(
            create: (context) =>
                SubjectsOfClassSectionCubit(TeacherRepository()),
          ),
        ],
        child: const LessonsScreen(),
      ),
    );
  }

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  late CustomDropDownItem currentSelectedClassSection = CustomDropDownItem(
      index: 0,
      title: context.read<MyClassesCubit>().getClassSectionName().first);

  late CustomDropDownItem currentSelectedSubject = CustomDropDownItem(
      index: 0,
      title: UiUtils.getTranslatedLabel(context, fetchingSubjectsKey));

  @override
  void initState() {
    context.read<SubjectsOfClassSectionCubit>().fetchSubjects(
          context
              .read<MyClassesCubit>()
              .getClassSectionDetails(index: currentSelectedClassSection.index)
              .id,
        );
    super.initState();
  }

  void fetchLessons() {
    final subjectState = context.read<SubjectsOfClassSectionCubit>().state;
    if (subjectState is SubjectsOfClassSectionFetchSuccess &&
        subjectState.subjects.isNotEmpty) {
      final subjectId = context
          .read<SubjectsOfClassSectionCubit>()
          .getSubjectId(currentSelectedSubject.index);
      if (subjectId != -1) {
        context.read<LessonsCubit>().fetchLessons(
              classSectionId: context
                  .read<MyClassesCubit>()
                  .getClassSectionDetails(
                    index: currentSelectedClassSection.index,
                  )
                  .id,
              subjectId: subjectId,
            );
      }
    }
  }

  Widget _buildAppbar() {
    return Align(
      alignment: Alignment.topCenter,
      child:
          CustomAppBar(title: UiUtils.getTranslatedLabel(context, lessonsKey)),
    );
  }

  Widget _buildClassAndSubjectDropDowns() {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        return Column(
          children: [
            MyClassesDropDownMenu(
              currentSelectedItem: currentSelectedClassSection,
              width: boxConstraints.maxWidth,
              changeSelectedItem: (result) {
                setState(() {
                  currentSelectedClassSection = result;
                });
                context.read<LessonsCubit>().updateState(LessonsInitial());
              },
            ),

            //
            BlocListener<SubjectsOfClassSectionCubit,
                SubjectsOfClassSectionState>(
              listener: (context, state) {
                if (state is SubjectsOfClassSectionFetchSuccess) {
                  if (state.subjects.isEmpty) {
                    context
                        .read<LessonsCubit>()
                        .updateState(LessonsFetchSuccess([]));
                  }
                }
              },
              child: ClassSubjectsDropDownMenu(
                changeSelectedItem: (result) {
                  setState(() {
                    currentSelectedSubject = result;
                  });
                  fetchLessons();
                },
                currentSelectedItem: currentSelectedSubject,
                width: boxConstraints.maxWidth,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionAddButton(
        onTap: () {
          Navigator.of(context)
              .pushNamed<bool?>(Routes.addOrEditLesson)
              .then((value) {
            if (value != null && value) {
              fetchLessons();
            }
          });
        },
      ),
      body: Stack(
        children: [
          CustomRefreshIndicator(
            displacment: UiUtils.getScrollViewTopPadding(
              context: context,
              appBarHeightPercentage: UiUtils.appBarSmallerHeightPercentage,
            ),
            onRefreshCallback: () {
              fetchLessons();
            },
            child: ListView(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width *
                    UiUtils.screenContentHorizontalPaddingPercentage,
                right: MediaQuery.of(context).size.width *
                    UiUtils.screenContentHorizontalPaddingPercentage,
                top: UiUtils.getScrollViewTopPadding(
                  context: context,
                  appBarHeightPercentage: UiUtils.appBarSmallerHeightPercentage,
                ),
              ),
              children: [
                _buildClassAndSubjectDropDowns(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * (0.0125),
                ),
                LessonsContainer(
                  classSectionDetails:
                      context.read<MyClassesCubit>().getClassSectionDetails(
                            index: currentSelectedClassSection.index,
                          ),
                  subject: (context.read<SubjectsOfClassSectionCubit>().state
                              is SubjectsOfClassSectionFetchSuccess &&
                          (context.read<SubjectsOfClassSectionCubit>().state
                                  as SubjectsOfClassSectionFetchSuccess)
                              .subjects
                              .isNotEmpty)
                      ? context
                          .read<SubjectsOfClassSectionCubit>()
                          .getSubjectDetails(currentSelectedSubject.index)
                      : Subject.fromJson({}),
                )
              ],
            ),
          ),
          _buildAppbar()
        ],
      ),
    );
  }
}
