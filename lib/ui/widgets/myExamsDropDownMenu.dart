import 'package:aurora_teacher/cubits/examCubit.dart';
import 'package:aurora_teacher/cubits/myClassesCubit.dart';
import 'package:aurora_teacher/cubits/subjectsOfClassSectionCubit.dart';
import 'package:aurora_teacher/ui/widgets/customDropDownMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyExamsDropDownMenu extends StatelessWidget {
  final CustomDropDownItem currentSelectedItem;
  final Function(CustomDropDownItem) changeSelectedItem;
  final double width;

  const MyExamsDropDownMenu({
    Key? key,
    required this.currentSelectedItem,
    required this.width,
    required this.changeSelectedItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropDownMenu(
      width: width,
      onChanged: (result) {
        if (result != null && result != currentSelectedItem) {
          changeSelectedItem(result);
          //
          context.read<SubjectsOfClassSectionCubit>().fetchSubjects(
                context
                    .read<MyClassesCubit>()
                    .getClassSectionDetails(index: result.index)
                    .id,
              );
        }
      },
      menu: context.read<ExamDetailsCubit>().getExamName(),
      currentSelectedItem: currentSelectedItem,
    );
  }
}
