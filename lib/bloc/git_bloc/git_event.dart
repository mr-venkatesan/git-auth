part of 'git_bloc.dart';

sealed class GitEvent extends Equatable {
  const GitEvent();
}

class GetUserOrganizationsEvent extends GitEvent{
  final dynamic context;
  const GetUserOrganizationsEvent(this.context);
  @override
  List<Object> get props => [context];
}

class GetUserOrganizationsByNameEvent extends GitEvent{
  final dynamic context;
  final String organizations;
  const GetUserOrganizationsByNameEvent(this.context,this.organizations);
  @override
  List<Object> get props => [context,organizations];
}

class GetUserBranchWithCommitsEvent extends GitEvent{
  final dynamic context;
  final String owner;
  final String repo;
  const GetUserBranchWithCommitsEvent(this.context,this.owner,this.repo);
  @override
  List<Object> get props => [context];
}

class GetUserBranchWithCommitsByBranchEvent extends GitEvent{
  final dynamic context;
  final String owner;
  final String repo;
  final String branch;
  const GetUserBranchWithCommitsByBranchEvent(this.context,this.owner,this.repo,this.branch);
  @override
  List<Object> get props => [context,branch];
}