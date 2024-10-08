part of 'git_bloc.dart';

sealed class GitState extends Equatable {
  const GitState();
}

final class GitInitial extends GitState {
  @override
  List<Object> get props => [];
}

class ApiSuccess extends GitState {
  final dynamic data; // Adjust according to your response data

  const ApiSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class ApiFailure extends GitState {
  final String error;

  const ApiFailure(this.error);

  @override
  List<Object?> get props => [error];
}