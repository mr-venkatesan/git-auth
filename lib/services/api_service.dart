import 'package:dio/dio.dart';

abstract class ApiService {
  Future<Response?> getOrganizationsAndRepos();
  Future<Response?> getOrganizationsAndReposByOrgName(String org);

  Future<Response?> getUserBranchWithCommits(String owner,String repo);
  Future<Response?> getUserBranchWithCommitsByBranch(String owner,String repo,String branch);
}