// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:aurora_teacher/data/repositories/studentRepository.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

@immutable
abstract class SubjectMarksByStudentIdState {}

class SubjectMarksByStudentIdInitial extends SubjectMarksByStudentIdState {}

class SubjectMarksByStudentIdSubmitInProgress
    extends SubjectMarksByStudentIdState {}

class SubjectMarksByStudentIdSubmitSuccess
    extends SubjectMarksByStudentIdState {
  final bool isMarksUpdated;
  final String successMessage;

  SubjectMarksByStudentIdSubmitSuccess({
    required this.isMarksUpdated,
    required this.successMessage,
  });
}

class SubjectMarksByStudentIdSubmitFailure
    extends SubjectMarksByStudentIdState {
  final String errorMessage;

  SubjectMarksByStudentIdSubmitFailure({required this.errorMessage});
}

class SubjectMarksByStudentIdCubit extends Cubit<SubjectMarksByStudentIdState> {
  StudentRepository studentRepository;

  SubjectMarksByStudentIdCubit({required this.studentRepository})
      : super(SubjectMarksByStudentIdInitial());
//
  //This method is used to submit subject marks by student Id
  Future<void> submitSubjectMarksByStudentId({
    required int studentId,
    required int examId,
    required int classSectionId,
    required List<Map<String, dynamic>> bodyParameter,
  }) async {
    try {
      var parameter = {"marks_data": bodyParameter};
      emit(SubjectMarksByStudentIdSubmitInProgress());
      Map<String, dynamic> result =
          await studentRepository.updateSubjectMarksByStudentId(
              studentId: studentId,
              examId: examId,
              bodyParameter: parameter,
              classSectionId: classSectionId);

      emit(
        SubjectMarksByStudentIdSubmitSuccess(
          isMarksUpdated: !result['error'],
          successMessage: result['message'],
        ),
      );
    } catch (e) {
      emit(SubjectMarksByStudentIdSubmitFailure(errorMessage: e.toString()));
    }
  }
}
