import 'package:flutter_bloc/flutter_bloc.dart';

class ErrorCubit extends Cubit<String> {
  ErrorCubit() : super('');

  void setError(String error) {
    emit(error);
  }
}
