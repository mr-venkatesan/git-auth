import 'package:flutter/material.dart';
import 'package:git_auth/bloc/git_bloc/git_bloc.dart';
import '../../utils/app_secure_storage.dart';
import '../model/organization_and_repos_list_model.dart';

class HomeViewModel {
  final GitBloc gitBloc;
  final BuildContext context;
  bool isLoading = false;
  String userName = "Guest";
  OrganizationAndReposListModel? organizationAndReposList;

  HomeViewModel({required this.context}) : gitBloc = GitBloc();

  void init() {
    gitBloc.add(GetUserOrganizationsEvent(context));
    getUserName();
    // Listen to GitBloc for state changes
    gitBloc.stream.listen((state) {
      if (state is ApiSuccess) {
        organizationAndReposList = OrganizationAndReposListModel.fromJson(state.data);
      }
    });
  }

  void dispose() {
    gitBloc.close();
  }

  Future<void> getUserName() async {
    userName = await AppSecureStorage.getUserName() ?? "Guest";
  }

  void retryFetch() {
    gitBloc.add(GetUserOrganizationsEvent(context,));
  }
}
