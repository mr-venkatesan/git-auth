import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:git_auth/bloc/git_bloc/git_bloc.dart';
import 'package:git_auth/utils/app_color.dart';

import '../../router/routes.dart';
import '../widgets/project_card_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GitBloc gitBloc = GitBloc();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    gitBloc.add(GetUserOrgEvent(context));
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColor.primaryColor,
      drawerEnableOpenDragGesture: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.primaryColor,
        surfaceTintColor: AppColor.primaryColor,
        leading: IconButton(
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Github",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColor.textSecondaryColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Add functionality for notifications
            },
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: buildHomePage(),
      drawer: CustomDrawer(),
    );
  }

  Widget getUserOrgBloc() {
    return BlocProvider(
      create: (_) => gitBloc,
      child: BlocListener<GitBloc, GitState>(
        listener: (BuildContext context, GitState state) {
          if (state is ApiSuccess) {
            print("${state.data}");
          }
          if (state is ApiFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: BlocBuilder<GitBloc, GitState>(
          builder: (BuildContext context, GitState state) {
            return buildHomePage();
          },
        ),
      ),
    );
  }

  Widget buildHomePage() {
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
                      "Hi Venkatesan",
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
              Positioned(
                  top: 180,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.bgPrimaryColor,
                    ),
                    child: Container(
                      color: AppColor.bgPrimaryColor,
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
                              children: [
                                ProjectCardView(
                                  title: 'Heavenly',
                                  subtitle: 'Rajesh kannan',
                                  onTap: () => Navigator.pushNamed(context, Routes.repo),
                                ),
                                ProjectCardView(
                                  title: 'Surgtest',
                                  subtitle: 'Vijay',
                                  onTap: () => Navigator.pushNamed(context, Routes.repo),
                                ),
                                ProjectCardView(
                                  title: 'TNULM',
                                  subtitle: 'Vikky',
                                  onTap: () => Navigator.pushNamed(context, Routes.repo),
                                ),
                                ProjectCardView(
                                  title: 'Erp one',
                                  subtitle: 'Vikky',
                                  onTap: () => Navigator.pushNamed(context, Routes.repo),
                                ),
                                ProjectCardView(
                                  title: 'Aggromalie',
                                  subtitle: 'Rajesh kannan',
                                  onTap: () => Navigator.pushNamed(context, Routes.repo),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ),
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
                      child:
                          const Icon(Icons.business, color: Color(0xFF00C2AE)),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Organisation Name',
                          style: TextStyle(
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

}


class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.white),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(
                        'assets/profile.jpg'), // Replace with your image asset
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'REPO NAME',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    child: const Text(
                      'SanthoshVGTS',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.business,
                  text: 'Vithea',
                  onTap: () {
                    // Add your navigation logic here
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.description,
                  text: 'Yolo works',
                  onTap: () {
                    // Add your navigation logic here
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.book,
                  text: 'One gold',
                  onTap: () {
                    // Add your navigation logic here
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.book_online,
                  text: 'Zoho books',
                  onTap: () {
                    // Add your navigation logic here
                  },
                ),
                const Divider(),
                _buildDrawerItem(
                  icon: Icons.logout,
                  text: 'Logout',
                  onTap: () {
                    // Add your logout logic here
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFE4F7F7),
        child: Icon(icon, color: const Color(0xFF00C2AE)),
      ),
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
