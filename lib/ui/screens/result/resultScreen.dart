import 'package:aurora_teacher/cubits/examCubit.dart';
import 'package:aurora_teacher/cubits/studentCompletedExamWithResultCubit.dart';
import 'package:aurora_teacher/data/repositories/studentRepository.dart';
import 'package:aurora_teacher/ui/screens/result/widget/resultsContainer.dart';
import 'package:aurora_teacher/ui/widgets/customAppbar.dart';
import 'package:aurora_teacher/utils/labelKeys.dart';
import 'package:aurora_teacher/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResultListScreen extends StatelessWidget {
  final int? studentId;
  final String? studentName;
  final String? className;
  final int classSectionId;

  const ResultListScreen(
      {Key? key,
      this.studentId,
      this.studentName,
      this.className,
      required this.classSectionId})
      : super(key: key);

  static Route route(RouteSettings routeSettings) {
    final studentData = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<ExamDetailsCubit>(
            create: (context) => ExamDetailsCubit(StudentRepository()),
          ),
          BlocProvider<StudentCompletedExamWithResultCubit>(
            create: (context) => StudentCompletedExamWithResultCubit(
              StudentRepository(),
            ),
          ),
        ],
        child: ResultListScreen(
          studentId: studentData['studentId'],
          studentName: studentData['studentName'],
          className: studentData['className'],
          classSectionId: studentData['classSectionId'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ResultsContainer(
            studentId: studentId,
            studentName: studentName,
            className: className,
            classSectionId: classSectionId,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: CustomAppBar(
              title: UiUtils.getTranslatedLabel(context, resultKey),
              subTitle: studentName,
              showBackButton: true,
              onPressBackButton: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
