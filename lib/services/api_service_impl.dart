import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:git_auth/services/api_service.dart';

import '../utils/dio_error_handler.dart';
import 'api_interceptor.dart';

class ApiServiceImpl implements ApiService{
  final Dio dio;

  ApiServiceImpl() : dio = Dio() {
    // Add the custom interceptor during initialization
    dio.interceptors.add(ApiInterceptor());
  }

  @override
  Future<Response?> getOrganizationsAndRepos() async {
    try {
      // Step 1: Fetch the organizations for the authenticated user
      final organizationsResponse = await dio.get(
        'https://api.github.com/user/orgs'
      );

      // Check if the request was successful
      if (organizationsResponse.statusCode == 200) {
        List<dynamic> organizations = organizationsResponse.data;

        // Check if any organizations are returned
        if (organizations.isNotEmpty) {
          // Use the first organization
          String orgName = organizations[0]['login'];
          log('First Organization: $orgName');

          // Step 2: Fetch the repositories of the specific organization
          final reposResponse = await dio.get(
            'https://api.github.com/orgs/$orgName/repos',
          );

          // Check if the second request was successful
          if (reposResponse.statusCode == 200) {
            var repos = reposResponse.data;

            reposResponse.data={
              "organizations":organizations,
              "repos":repos,
              "selectedOrganizations":organizations[0]
            };
            return reposResponse;
          } else {
            reposResponse.data={
              "organizations":organizations,
              "repos":[],
              "selectedOrganizations":organizations[0]
            };
            return reposResponse;
          }
        }
        else {
          log('No organizations found for the user.');
          return null;
        }
      }
      else {
        log('Failed to load organizations: ${organizationsResponse.statusCode}');
        return null;
      }
    } on DioException catch (dioError) {
      // Handle DioException (network errors, timeouts, etc.)
      final errorMessage = DioErrorHandler.handleDioError(dioError);
      log('Error: $errorMessage'); // Log the error message for debugging
      return dioError.response; // Return the response if available
    } catch (e) {
      // Handle any other unexpected errors
      log('Unexpected Error: $e'); // Log unexpected errors for debugging
      return null; // Return null if an unexpected error occurs
    }
  }

  @override
  Future<Response?> getOrganizationsAndReposByOrgName(String org) async {
    try {
      // Fetch organizations and repositories concurrently
      final List<Response> responses = await Future.wait([
        dio.get('https://api.github.com/user/orgs'),
        dio.get('https://api.github.com/orgs/$org'), // Fetch the specific organization
        dio.get('https://api.github.com/orgs/$org/repos'), // Fetch the organization's repos
      ]);

      // Ensure all requests were successful
      if (responses[0].statusCode == 200 &&
          responses[1].statusCode == 200 &&
          responses[2].statusCode == 200) {

        // Extract data from responses
        List<dynamic> organizations = responses[0].data; // User organizations
        var selectedOrganization = responses[1].data; // Specific organization
        List<dynamic> repos = responses[2].data; // Organization repositories

        // Return the combined results
        Response response=Response(
            data: {
              "organizations":organizations,
              "repos":repos,
              "selectedOrganizations":selectedOrganization
          },
          requestOptions: RequestOptions(),
          statusCode: 200
        );
        return response;
      } else {
        log('One or more requests failed: ${responses.map((res) => res.statusCode).toList()}');
        return null; // Return null if any response failed
      }
    } on DioException catch (dioError) {
      // Handle DioException (network errors, timeouts, etc.)
      final errorMessage = DioErrorHandler.handleDioError(dioError);
      log('Error: $errorMessage'); // Log the error message for debugging
      return null; // Return null if an error occurs
    } catch (e) {
      // Handle any other unexpected errors
      log('Unexpected Error: $e'); // Log unexpected errors for debugging
      return null; // Return null if an unexpected error occurs
    }
  }

  @override
  Future<Response?> getUserBranchWithCommits(String owner,String repo) async {
    try{
      // Fetch branches from the specified repository.
      final branchesResponse = await dio.get('https://api.github.com/repos/$owner/$repo/branches');

      // Check if the request was successful.
      if (branchesResponse.statusCode == 200) {
        List<dynamic> branches = branchesResponse.data;

        // Check if there are any branches returned.
        if (branches.isNotEmpty) {
          // Use the first branch's name to get commits.
          String branchName = branches[0]["name"];
          final commitsResponse = await dio.get(
            'https://api.github.com/repos/$owner/$repo/commits',
            queryParameters: {'sha': branchName},
          );

          // Combine the branches and commits data in a custom response.
          return Response(
            data: {
              "branches": branches, // List of branches.
              "commits": commitsResponse.data, // List of commits for the selected branch.
              "selectedBranch": branches[0], // The selected branch.
            },
            requestOptions: commitsResponse.requestOptions,
            statusCode: 200,
          );
        } else {
          log('No branches found in the repository.');
          return null;
        }
      } else {
        log('Failed to fetch branches. Status code: ${branchesResponse.statusCode}');
        return null;
      }
    }on DioException catch (dioError) {
      // Handle DioException (network errors, timeouts, etc.)
      final errorMessage = DioErrorHandler.handleDioError(dioError);
      log('Error: $errorMessage'); // Log the error message for debugging
      return dioError.response; // Return the response if available
    } catch (e) {
      // Handle any other unexpected errors
      log('Unexpected Error: $e'); // Log unexpected errors for debugging
      return null; // Return null if an unexpected error occurs
    }

  }

  @override
  Future<Response?> getUserBranchWithCommitsByBranch(String owner,String repo,String branch) async {
    try {
      // Perform both API requests concurrently.
      final List<Response> responses = await Future.wait([
        dio.get('https://api.github.com/repos/$owner/$repo/branches'),
        dio.get('https://api.github.com/repos/$owner/$repo/commits', queryParameters: {'sha': branch}),
      ]);

      // Check if both requests were successful.
      if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
        // Extract data from the responses.
        List<dynamic> branches = responses[0].data; // List of branches.
        List<dynamic> commits = responses[1].data;  // List of commits for the specified branch.

        // Prepare the combined response data.
        return Response(
          requestOptions: responses[0].requestOptions,
          data: {
            "branches": branches,
            "commits": commits,
          },
          statusCode: 200,
        );
      } else {
        // Handle unsuccessful response statuses.
        log('Failed to fetch branches or commits. Status codes: '
            '${responses[0].statusCode}, ${responses[1].statusCode}');
        return null;
      }
    } on DioException catch (dioError) {
      // Handle Dio-specific errors like network issues.
      final errorMessage = DioErrorHandler.handleDioError(dioError);
      log('Dio error: $errorMessage');
      return null;
    } catch (e) {
      // Handle any unexpected errors.
      log('Unexpected error: $e');
      return null;
    }

  }


}