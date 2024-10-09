import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:git_auth/bloc/git_bloc/git_bloc.dart';
import 'package:git_auth/model/branchs_and_commits_list_model.dart';
import 'package:git_auth/utils/app_assets.dart';
import '../../utils/app_color.dart';
import '../../view_model/repo_view_model.dart';

class RepoView extends StatefulWidget {
  final String owner,repo,avatarUrl;
  final DateTime updatedAt;
  const RepoView({super.key, required this.owner, required this.repo, required this.updatedAt, required this.avatarUrl});

  @override
  State<RepoView> createState() => _RepoViewState();
}

class _RepoViewState extends State<RepoView> {
  late RepoViewModel repoViewModel;
  @override
  void initState() {
    super.initState();
    repoViewModel = RepoViewModel(context: context, owner: widget.owner, repo: widget.repo);
    repoViewModel.init();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: repoViewModel.isLoading? AppColor.primaryColor : AppColor.bgPrimaryColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  // Builds the AppBar for the RepoView screen.
  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColor.primaryColor,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
      ),
      title: Text(
        "Project",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColor.textSecondaryColor,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody() {
    return BlocProvider(
      create: (_) => repoViewModel.gitBloc,
      child: BlocListener<GitBloc, GitState>(
        listener: (context, state) {
          if (state is ApiSuccess || state is ApiFailure) {
            setState(() => repoViewModel.isLoading = true);
            if(state is ApiSuccess){
              repoViewModel.branchesAndCommitsList=BranchsAndCommitsListModel.fromJson(state.data);
            }
            if (state is ApiFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          }else{
            setState(() => repoViewModel.isLoading = false);
          }
        },
        child: BlocBuilder<GitBloc, GitState>(
          builder: (context, state) {
            if (state is ApiSuccess) {
              return _buildRepo();
            } else if (state is ApiFailure) {
              return Center(
                child: TextButton(
                  onPressed:(){},
                  child: const Text("Please try again later"),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(color: AppColor.primaryColor),
              );
            }
          },
        ),
      ),
    );
  }

  // Builds the repository view UI structure.
  Widget _buildRepo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            children: [
              // The top part of the screen showing user information and last update.
              _buildUserInfo(),
              // The bottom part containing branches and changes list.
              _buildBranchesAndChanges(),
            ],
          ),
        ),
      ],
    );
  }

  // Builds the user info section at the top of the screen.
  Widget _buildUserInfo() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColor.primaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User details with avatar and name.
              _buildUserDetails(),
              const SizedBox(height: 8.0),
              // Last update time display.
              Text(
                "Last update : ${widget.updatedAt}",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: AppColor.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Builds the user details section with an avatar and name.
  Widget _buildUserDetails() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Circular avatar with a placeholder character.
        Container(
          height: 60,
          width: 60,
          padding: const EdgeInsets.only(right: 8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(widget.avatarUrl),
          ),
        ),
        // User name and subtitle.
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.repo,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: AppColor.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.owner,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColor.textSecondaryColor,
              ),
            ),
          ],
        )
      ],
    );
  }

  // Builds the branches list and changes list section.
  Widget _buildBranchesAndChanges() {
    return Positioned(
      top: 110,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: AppColor.bgPrimaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Branches list at the top.
            _buildBranchesList(),
            const SizedBox(height: 8),
            // Expanded changes list view.
            _buildChangesList(),
          ],
        ),
      ),
    );
  }

  // Builds a horizontal list of branches.
  Widget _buildBranchesList() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      height: 80,
      child: ListView.builder(
        itemCount: repoViewModel.branchesAndCommitsList?.branches.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, branchIndex) {
          return Container(
            margin: const EdgeInsets.only(right: 8.0),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              color: repoViewModel.selectedBranch==branchIndex? AppColor.selectedBranchColor:AppColor.unSelectedBranchColor,
            ),
            child: TextButton(
                  onPressed: (){
                    setState(() {
                      repoViewModel.selectedBranch=branchIndex;
                      repoViewModel.gitBloc.add(GetUserBranchWithCommitsByBranchEvent(context, widget.owner, widget.repo, repoViewModel.branchesAndCommitsList!.branches[branchIndex].name));
                    });
                  },
                  child: Text(
                      repoViewModel.branchesAndCommitsList!.branches[branchIndex].name,
                      style: TextStyle(
                        color: repoViewModel.selectedBranch==branchIndex?AppColor.textSecondaryColor:AppColor.textAccentColor
                      ),
                  ),
            ),
          );
        },
      ),
    );
  }

  // Builds the list of changes.
  Widget _buildChangesList() {
    return Expanded(
      child: ListView.builder(
        itemCount: repoViewModel.branchesAndCommitsList!.commits.length, // You can adjust the number of items as needed.
        itemBuilder: (context, changesIndex) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
            child: Column(
              children: [
                // Displays each change with folder icon and user details.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      AppAssets.icFolder,
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          repoViewModel.branchesAndCommitsList!.commits[changesIndex].commit.message,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: AppColor.textPrimaryColor,
                          ),
                        ),
                        Text(
                          "${repoViewModel.branchesAndCommitsList!.commits[changesIndex].commit.author.date}",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: AppColor.textAccentColor,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            SvgPicture.asset(AppAssets.icUser),
                            const SizedBox(width: 8.0),
                            Text(
                              repoViewModel.branchesAndCommitsList!.commits[changesIndex].commit.author.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: AppColor.textAccentColor,
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
                const Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}

