
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:git_auth/services/api_service_impl.dart';

part 'git_event.dart';
part 'git_state.dart';

class GitBloc extends Bloc<GitEvent, GitState> {
  final ApiServiceImpl apiService = ApiServiceImpl();
  GitBloc() : super(GitInitial()) {
    on<GitEvent>((event, emit) {});
    on<GetUserOrgEvent>(_onGetUserOrg);
  }
  Future<void> _onGetUserOrg(GetUserOrgEvent event, Emitter<GitState> emit) async {
    try {
      final response = await apiService.getOrganization();
      if (response?.statusCode != null && response!.statusCode! >= 200 && response.statusCode! < 300) {
        emit(ApiSuccess(response.data));
      } else {
        emit(const ApiFailure('Data Not Found. Please try again.'));
      }
    } catch (e) {
      emit(const ApiFailure('An unexpected error occurred. Please try again.'));
    }
  }
}
