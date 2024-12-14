import 'package:aurora_teacher/app/routes.dart';
import 'package:aurora_teacher/cubits/announcementsCubit.dart';
import 'package:aurora_teacher/cubits/myClassesCubit.dart';
import 'package:aurora_teacher/cubits/subjectsOfClassSectionCubit.dart';
import 'package:aurora_teacher/data/models/subject.dart';
import 'package:aurora_teacher/data/repositories/announcementRepository.dart';
import 'package:aurora_teacher/data/repositories/teacherRepository.dart';
import 'package:aurora_teacher/ui/widgets/announcementsContainer.dart';
import 'package:aurora_teacher/ui/widgets/classSubjectsDropDownMenu.dart';
import 'package:aurora_teacher/ui/widgets/customAppbar.dart';
import 'package:aurora_teacher/ui/widgets/customDropDownMenu.dart';
import 'package:aurora_teacher/ui/widgets/customFloatingActionButton.dart';
import 'package:aurora_teacher/ui/widgets/customRefreshIndicator.dart';
import 'package:aurora_teacher/ui/widgets/myClassesDropDownMenu.dart';
import 'package:aurora_teacher/utils/labelKeys.dart';
import 'package:aurora_teacher/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({Key? key}) : super(key: key);

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();

  static Route<dynamic> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                SubjectsOfClassSectionCubit(TeacherRepository()),
          ),
          BlocProvider(
            create: (context) => AnnouncementsCubit(AnnouncementRepository()),
          )
        ],
        child: const AnnouncementsScreen(),
      ),
    );
  }
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  late CustomDropDownItem currentSelectedClassSection = CustomDropDownItem(
      index: 0,
      title: context.read<MyClassesCubit>().getClassSectionName().first);

  late CustomDropDownItem currentSelectedSubject = CustomDropDownItem(
      index: 0,
      title: UiUtils.getTranslatedLabel(context, fetchingSubjectsKey));

  late final ScrollController _scrollController = ScrollController()
    ..addListener(_announcementsScrollListener);

  void _announcementsScrollListener() {
    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      if (context.read<AnnouncementsCubit>().hasMore()) {
        context.read<AnnouncementsCubit>().fetchMoreAnnouncements(
              subjectId: context
                  .read<SubjectsOfClassSectionCubit>()
                  .getSubjectDetails(currentSelectedSubject.index)
                  .id,
              classSectionId: context
                  .read<MyClassesCubit>()
                  .getClassSectionDetails(
                    index: currentSelectedClassSection.index,
                  )
                  .id,
            );
      }
    }
  }

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

  void fetchAnnouncements() {
    final subjectState = context.read<SubjectsOfClassSectionCubit>().state;

    if (subjectState is SubjectsOfClassSectionFetchSuccess &&
        subjectState.subjects.isNotEmpty) {
      final subjectId = context
          .read<SubjectsOfClassSectionCubit>()
          .getSubjectDetails(currentSelectedSubject.index)
          .id;
      if (subjectId != -1) {
        context.read<AnnouncementsCubit>().fetchAnnouncements(
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

                context
                    .read<AnnouncementsCubit>()
                    .updateState(AnnouncementsInitial());
              },
            ),
            BlocListener<SubjectsOfClassSectionCubit,
                SubjectsOfClassSectionState>(
              listener: (context, state) {
                if (state is SubjectsOfClassSectionFetchSuccess) {
                  if (state.subjects.isEmpty) {
                    context
                        .read<AnnouncementsCubit>()
                        .updateState(AnnouncementsFetchSuccess(
                          announcements: [],
                          fetchMoreAnnouncementsInProgress: false,
                          moreAnnouncementsFetchError: false,
                          totalPage: 0,
                          currentPage: 0,
                        ));
                  }
                }
              },
              child: ClassSubjectsDropDownMenu(
                changeSelectedItem: (result) {
                  setState(() {
                    currentSelectedSubject = result;
                  });
                  fetchAnnouncements();
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
              .pushNamed<bool?>(Routes.addOrEditAnnouncement)
              .then((value) {
            if (value != null && value) {
              fetchAnnouncements();
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
              fetchAnnouncements();
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
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
                AnnouncementsContainer(
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
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: CustomAppBar(
              title: UiUtils.getTranslatedLabel(context, announcementsKey),
            ),
          ),
        ],
      ),
    );
  }
}
