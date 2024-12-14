import 'package:aurora_teacher/data/models/student.dart';
import 'package:aurora_teacher/data/repositories/studentRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class StudentsByClassSectionState {}

class StudentsByClassSectionInitial extends StudentsByClassSectionState {}

class StudentsByClassSectionFetchInProgress
    extends StudentsByClassSectionState {}

class StudentsByClassSectionFetchSuccess extends StudentsByClassSectionState {
  final List<Student> students;

  StudentsByClassSectionFetchSuccess({required this.students});
}

class StudentsByClassSectionFetchFailure extends StudentsByClassSectionState {
  final String errorMessage;

  StudentsByClassSectionFetchFailure(this.errorMessage);
}

class StudentsByClassSectionCubit extends Cubit<StudentsByClassSectionState> {
  final StudentRepository _studentRepository;

  StudentsByClassSectionCubit(this._studentRepository)
      : super(StudentsByClassSectionInitial());

  void updateState(StudentsByClassSectionState updatedState) {
    emit(updatedState);
  }

  Future<void> fetchStudents(
      {required int classSectionId, required int? subjectId}) async {
    emit(StudentsByClassSectionFetchInProgress());
    try {
      emit(
        StudentsByClassSectionFetchSuccess(
          students:
              await _studentRepository.getStudentsByClassSectionAndSubject(
            classSectionId: classSectionId,
            subjectId: subjectId,
          ),
        ),
      );
    } catch (e) {
      emit(StudentsByClassSectionFetchFailure(e.toString()));
    }
  }

  List<Student> getStudents() {
    return (state is StudentsByClassSectionFetchSuccess)
        ? (state as StudentsByClassSectionFetchSuccess).students
        : [];
  }
}
