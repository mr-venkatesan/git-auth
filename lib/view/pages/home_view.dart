
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
  GitBloc gitBloc=GitBloc();
  @override
  void initState() {
    super.initState();
    gitBloc.add(GetUserOrgEvent(context));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColor.bgPrimaryColor,
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: AppColor.primaryColor,
        surfaceTintColor: AppColor.primaryColor,
        leading: IconButton(
          onPressed: () {
            // Add functionality to open a drawer or perform another action
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
  Widget buildHomePage(){
    double topPad = MediaQuery.of(context).padding.top;
    return Container(
      decoration: BoxDecoration(
        color: AppColor.bgPrimaryColor
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background color transition between primary and secondary colors
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 100,
                      child: Container(
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
                                color: AppColor.textSecondaryColor
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 100,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColor.bgPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 140,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 20.0),
                  margin: const EdgeInsets.all(15),
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
                        child: const Icon(Icons.business, color: Color(0xFF00C2AE)),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Organisation Name',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                              style: TextStyle(color: Colors.white, fontSize: 12,fontWeight: FontWeight.w500),
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
                ProjectCardView(title: 'Heavenly', subtitle: 'Rajesh kannan', onTap: ()=>Navigator.pushNamed(context,Routes.repo),),
                ProjectCardView(title: 'Surgtest', subtitle: 'Vijay', onTap: ()=>Navigator.pushNamed(context,Routes.repo),),
                ProjectCardView(title: 'TNULM', subtitle: 'Vikky', onTap: ()=>Navigator.pushNamed(context,Routes.repo),),
                ProjectCardView(title: 'Erp one', subtitle: 'Vikky', onTap: ()=>Navigator.pushNamed(context,Routes.repo),),
                ProjectCardView(title: 'Aggromalie', subtitle: 'Rajesh kannan', onTap: ()=>Navigator.pushNamed(context,Routes.repo),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
