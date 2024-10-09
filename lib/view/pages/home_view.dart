import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:git_auth/bloc/git_bloc/git_bloc.dart';
import 'package:git_auth/utils/app_assets.dart';
import 'package:git_auth/utils/app_color.dart';

import '../../model/organization_and_repos_list_model.dart';
import '../../router/routes.dart';
import '../../view_model/home_view_model.dart';
import '../widgets/project_card_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late HomeViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = HomeViewModel(context: context);
    viewModel.init();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: viewModel.isLoading? AppColor.primaryColor : AppColor.bgPrimaryColor,
      drawerEnableOpenDragGesture: false,
      appBar: _buildAppBar(),
      body: _buildBody(),
      drawer: _buildDrawer(),
    );
  }
  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColor.primaryColor,
      leading: IconButton(
        onPressed: () => scaffoldKey.currentState?.openDrawer(),
        icon: const Icon(Icons.menu, color: Colors.white),
      ),
      title: Text(
        "Github",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColor.textSecondaryColor,
        ),
      ),
      actions: [
        InkWell(
          onTap: () {
            // Add functionality for notifications
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: SvgPicture.asset(AppAssets.icNotification),
          ),
        ),
      ],
    );
  }
  Widget _buildBody() {
    return BlocProvider(
      create: (_) => viewModel.gitBloc,
      child: BlocListener<GitBloc, GitState>(
        listener: (context, state) {
          if (state is ApiSuccess || state is ApiFailure) {
            setState(() => viewModel.isLoading = true);
            if (state is ApiFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          }else{
            setState(() => viewModel.isLoading = false);
          }
        },
        child: BlocBuilder<GitBloc, GitState>(
          builder: (context, state) {
            if (state is ApiSuccess) {
              return state.data != null
                  ? _buildHomePage(
                  OrganizationAndReposListModel.fromJson(state.data))
                  : const Center(child: Text("No organizations found for the user"),
              );
            } else if (state is ApiFailure) {
              return Center(
                child: TextButton(
                  onPressed: viewModel.retryFetch,
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
  Widget _buildHomePage(OrganizationAndReposListModel data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Hi, ${viewModel.userName}",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColor.textSecondaryColor),
                    ),
                  ),
                ),
              ),
              Positioned(
                  top: 90,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColor.bgPrimaryColor,
                      )
                  )
              ),
              _buildProjectsList(data),
              Container(
                height: 140,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 25),
                decoration: BoxDecoration(
                  color: Colors.white, // Background color of the card
                  borderRadius: BorderRadius.circular(16.0), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2), // Shadow color
                      spreadRadius: 2, // How much the shadow spreads
                      blurRadius: 8, // Softness of the shadow
                      offset: const Offset(0, 4), // Offset of the shadow (x, y)
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE4F7F7),
                      ),
                      child:CircleAvatar(
                          radius: 48,
                          backgroundImage: NetworkImage(data.selectedOrg.avatarUrl)
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.selectedOrg.login,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF00C2AE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(12.0),
                          child: const Text(
                            'VGTS',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildProjectsList(OrganizationAndReposListModel data) {
    return Positioned(
      top: 180,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(color: AppColor.bgPrimaryColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Projects',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: data.repos.map((repo) {
                  return ProjectCardView(
                    title: repo.name,
                    subtitle: repo.owner.login,
                    onTap: () => Navigator.pushNamed(context, Routes.repo,arguments: {
                     "owner":repo.owner.login,
                     "repo":repo.name,
                     "updatedAt":repo.updatedAt,
                     "avatarUrl":repo.owner.avatarUrl
                    }),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Drawer _buildDrawer(){
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Drawer(
      backgroundColor: AppColor.bgPrimaryColor,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: statusBarHeight,left: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColor.bgPrimaryColor,
                    border: Border.all(color: AppColor.textPrimaryColor.withOpacity(0.1)),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      viewModel.organizationAndReposList?.selectedOrg.avatarUrl ?? "",
                      width: 50, // Ensure the width matches the container
                      height: 50, // Ensure the height matches the container
                      fit: BoxFit.cover, // Use BoxFit to cover the circular area
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width>500 ? MediaQuery.of(context).size.width * 0.2 : MediaQuery.of(context).size.width * 0.4), // Set max width
                      child: Text(
                        viewModel.organizationAndReposList?.selectedOrg.login ?? 'REPO NAME',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                        maxLines: 1, // Limit to a single line
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width>500 ? MediaQuery.of(context).size.width * 0.2 : MediaQuery.of(context).size.width * 0.4), // Set max width
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      child: Text(
                        '${viewModel.userName}VGTS',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0,),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 15.0),
              itemCount: (viewModel.organizationAndReposList?.orgs.length ?? 0) + 1, // +1 for the logout option
              itemBuilder: (context, orgIndex) {
                // Check if this is the last item (Logout)
                if (orgIndex == (viewModel.organizationAndReposList?.orgs.length ?? 0)) {
                  return ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColor.bgPrimaryColor,
                        border: Border.all(color: AppColor.textPrimaryColor.withOpacity(0.1)),
                        borderRadius: const BorderRadius.all(Radius.circular(8.0))
                      ),
                        child: const Icon(
                            Icons.logout,
                        )
                    ),
                    title: Text(
                      'Logout',
                      style: TextStyle(
                        color: AppColor.textPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      _showSignOutDialog(context);
                    },
                  );
                }
                // Otherwise, render the organization item
                return _buildDrawerItem(
                  avatarUrl: viewModel.organizationAndReposList?.orgs[orgIndex].avatarUrl ?? "",
                  text: viewModel.organizationAndReposList?.orgs[orgIndex].login ?? "",
                  onTap: () {
                    viewModel.gitBloc.add(GetUserOrganizationsByNameEvent(
                        context, viewModel.organizationAndReposList?.orgs[orgIndex].login ?? ""));
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildDrawerItem({
    required String avatarUrl,
    required String text,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 70,
      alignment: Alignment.center,
      child: ListTile(
        leading:  Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: AppColor.bgPrimaryColor,
                border: Border.all(color: AppColor.textPrimaryColor.withOpacity(0.1)),
                borderRadius: const BorderRadius.all(Radius.circular(8.0))
            ),
            child: Image.network(avatarUrl)
        ),
        title: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Perform sign-out
                await _signOut();
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(context,Routes.root,(Route<dynamic> route) => false);
      // Optionally, navigate to the login screen or show a success message
    } catch (e) {
      // Handle any errors that occur during sign-out
      log('Sign out error: $e');
    }
  }


}
