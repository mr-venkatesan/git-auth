import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_auth/router/routes.dart';
import 'package:git_auth/utils/app_assets.dart';
import 'package:git_auth/utils/app_color.dart';
import 'package:git_auth/utils/app_secure_storage.dart';
import 'package:github_signin_promax/github_signin_promax.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  bool _isLoading = false; // State variable for loading

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgPrimaryColor,
      body: buildSignInDesign(),
    );
  }

  Widget buildSignInDesign() {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
                      child: Image.asset(AppAssets.signInLogo),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.13),
                    Image.asset(AppAssets.signInIllustrator),
                    Text(
                      "Lets build from here ...",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: AppColor.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "Our platform drives innovation with tools that boost developer velocity",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: AppColor.textSecondaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: constraints.maxHeight * 0.13),
                    if (_isLoading) // Show loading indicator if loading
                      const CircularProgressIndicator()
                    else
                      SizedBox(
                        width: constraints.maxWidth,
                        child: ElevatedButton(
                          onPressed: onSignInPressed,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            backgroundColor: AppColor.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            'Sign in with GitHub',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void onSignInPressed() async {
    // Start loading
    setState(() {
      _isLoading = true;
    });

    const String clientId = 'Ov23li7kdEQ2tssOunn2';
    const String clientSecret = '97ed824e6a890cfb18faa7fb47ce3626a07c8aa8';
    const String redirectUrl = 'https://git-auth-237fb.firebaseapp.com/__/auth/handler';

    var params = GithubSignInParams(
      clientId: clientId,
      clientSecret: clientSecret,
      redirectUrl: redirectUrl,
      scopes: 'repo,read:user,user:email,read:org',
    );

    Navigator.of(context).push(MaterialPageRoute(builder: (builder) {
      return GithubSigninScreen(
        params: params,
        headerColor: AppColor.primaryColor,
        title: 'Login with GitHub',
      );
    })).then((value) async {
      GithubSignInResponse githubSignInResponse = value as GithubSignInResponse;

      // Stop loading
      setState(() =>_isLoading = true);

      if (githubSignInResponse.accessToken != null) {
        AppSecureStorage.storeAccessToken(githubSignInResponse.accessToken ?? "");
        final githubAuthCredential = GithubAuthProvider.credential(githubSignInResponse.accessToken ?? "");

        var userCredential = await FirebaseAuth.instance.signInWithCredential(githubAuthCredential);
        AppSecureStorage.storeUserName(userCredential.additionalUserInfo?.username ?? "Guest");
        // Stop loading
        setState(() =>_isLoading = false);
        Navigator.pushReplacementNamed(context, Routes.home);
      } else {
        setState(() =>_isLoading = true);
        // Handle the error scenario here if needed (e.g., showing an error message)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to sign in with GitHub.')),
        );
      }
    });
  }
}
