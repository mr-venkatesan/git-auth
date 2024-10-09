
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:git_auth/services/api_service_impl.dart';

part 'git_event.dart';
part 'git_state.dart';

class GitBloc extends Bloc<GitEvent, GitState> {
  final ApiServiceImpl apiService = ApiServiceImpl();
  GitBloc() : super(GitInitial()) {
    on<GitEvent>((event, emit) {});
    on<GetUserOrganizationsEvent>(_onGetUserOrg);
    on<GetUserOrganizationsByNameEvent>(_onGetUserOrganizationsByName);

    on<GetUserBranchWithCommitsEvent>(_onGetUserBranchWithCommits);
    on<GetUserBranchWithCommitsByBranchEvent>(_onGetUserBranchWithCommitsByBranch);
  }
  Future<void> _onGetUserOrg(GetUserOrganizationsEvent event, Emitter<GitState> emit) async {
    emit(GitInitial());
    try {
      final response = await apiService.getOrganizationsAndRepos();
      if (response?.statusCode != null && response!.statusCode! >= 200 && response.statusCode! < 300) {
        emit(ApiSuccess(response.data));
      } else {
        emit(const ApiFailure('Data Not Found. Please try again.'));
      }
    } catch (e) {
      emit(const ApiFailure('An unexpected error occurred. Please try again.'));
    }
  }
  Future<void> _onGetUserOrganizationsByName(GetUserOrganizationsByNameEvent event, Emitter<GitState> emit) async {
    emit(GitInitial());
    try {
      final response = await apiService.getOrganizationsAndReposByOrgName(event.organizations);
      if (response?.statusCode != null && response!.statusCode! >= 200 && response.statusCode! < 300) {
        emit(ApiSuccess(response.data));
      } else {
        emit(const ApiFailure('Data Not Found. Please try again.'));
      }
    } catch (e) {
      emit(const ApiFailure('An unexpected error occurred. Please try again.'));
    }
  }

  Future<void> _onGetUserBranchWithCommits(GetUserBranchWithCommitsEvent event, Emitter<GitState> emit) async {
    emit(GitInitial());
    try {
      final response = await apiService.getUserBranchWithCommits(event.owner,event.repo);
      if (response?.statusCode != null && response!.statusCode! >= 200 && response.statusCode! < 300) {
        emit(ApiSuccess(response.data));
      } else {
        emit(const ApiFailure('Data Not Found. Please try again.'));
      }
    } catch (e) {
      emit(const ApiFailure('An unexpected error occurred. Please try again.'));
    }
  }
  Future<void> _onGetUserBranchWithCommitsByBranch(GetUserBranchWithCommitsByBranchEvent event, Emitter<GitState> emit) async {
    emit(GitInitial());
    try {
      final response = await apiService.getUserBranchWithCommitsByBranch(event.owner,event.repo,event.branch);
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
