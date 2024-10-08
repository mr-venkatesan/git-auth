part of 'git_bloc.dart';

sealed class GitEvent extends Equatable {
  const GitEvent();
}

class GetUserOrgEvent extends GitEvent{
  final dynamic context;
  const GetUserOrgEvent(this.context);
  @override
  List<Object> get props => [context];
}