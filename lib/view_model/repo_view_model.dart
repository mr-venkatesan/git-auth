import 'package:flutter/cupertino.dart';
import 'package:git_auth/model/branchs_and_commits_list_model.dart';

import '../bloc/git_bloc/git_bloc.dart';

class RepoViewModel {
  final GitBloc gitBloc;
  final BuildContext context;
  final String owner;
  final String repo;
  int selectedBranch = 0;
  bool isLoading = false;

  BranchsAndCommitsListModel? branchesAndCommitsList;

  RepoViewModel( {required this.context,required this.owner, required this.repo,}) : gitBloc = GitBloc();

  void init() {
    gitBloc.add(GetUserBranchWithCommitsEvent(context,owner,repo));

    // Listen to GitBloc for state changes
    gitBloc.stream.listen((state) {
      if (state is ApiSuccess) {
        branchesAndCommitsList = BranchsAndCommitsListModel.fromJson(state.data);
      }
    });
  }

  void dispose() {
    gitBloc.close();
  }

  void retryFetch() {
    gitBloc.add(GetUserOrganizationsEvent(context,));
  }
}