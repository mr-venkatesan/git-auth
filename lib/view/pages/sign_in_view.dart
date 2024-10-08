import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:git_auth/utils/app_assets.dart';
import 'package:git_auth/utils/app_color.dart';
import 'package:git_auth/utils/app_secure_storage.dart';
import 'package:github_signin_promax/github_signin_promax.dart';

import '../../router/routes.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sets the background color of the scaffold.
      backgroundColor: AppColor.bgPrimaryColor,

      // Calls the method to build the sign-in screen design.
      body: buildSignInDesign(),
    );
  }

  // This method builds the design for the sign-in screen.
  Widget buildSignInDesign() {
    return SafeArea(
      // Ensures the content is placed within the safe area of the device.
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            // Takes up the maximum width and height of the available space.
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: SingleChildScrollView(
              child: Padding(
                // Adds padding around the content for spacing.
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  // Aligns the children to the center horizontally.
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Displays the logo at the top with spacing.
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
                      child: Image.asset(AppAssets.signInLogo),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.13),

                    // Displays an illustration below the logo.
                    Image.asset(AppAssets.signInIllustrator),

                    // Displays a headline text.
                    Text(
                      "Lets build from here ...",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: AppColor.textPrimaryColor,
                      ),
                    ),

                    // Adds some space between the texts.
                    const SizedBox(height: 8.0),

                    // Displays a secondary description text.
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

                    // A button to initiate GitHub sign-in.
                    SizedBox(
                      width: constraints.maxWidth,
                      child: ElevatedButton(
                        onPressed: onSignInPressed,
                        style: ElevatedButton.styleFrom(
                          // Adds vertical padding for the button.
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          backgroundColor: AppColor.primaryColor,
                          shape: RoundedRectangleBorder(
                            // Rounds the button corners.
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

  // This method is triggered when the sign-in button is pressed.
  void onSignInPressed() async {
    // Initiates GitHub sign-in and gets user credentials.
    UserCredential? userCredential = await signInWithGitHub();

    // If the sign-in is successful, navigate to the home screen.
    if (userCredential != null) {
      Navigator.pushReplacementNamed(context, Routes.home);
    }
  }

// Handles the sign-in process with GitHub.
  Future<UserCredential?> signInWithGitHub() async {
    // GitHub OAuth client details.
    const String clientId = 'Ov23linHJhhsM8D01BkM'; // Your GitHub OAuth client ID.
    const String clientSecret = '6e99e670cb7dc0f3b9328503b77d94917b670c7b'; // Your GitHub OAuth client secret.
    const String redirectUrl = 'https://git-auth-237fb.firebaseapp.com/__/auth/handler'; // Adjust this to your app's URL scheme.

    // Defines parameters for the GitHub sign-in.
    var params = GithubSignInParams(
      clientId: clientId, // Client ID for the GitHub OAuth.
      clientSecret: clientSecret, // Client secret for the GitHub OAuth.
      redirectUrl: redirectUrl, // Redirect URL after sign-in.
      scopes: 'repo,read:user,user:email,read:org', // Permissions requested from the user.
    );

    // Pushes the GitHub sign-in screen and waits for the sign-in response.
    Navigator.of(context).push(MaterialPageRoute(builder: (builder) {
      return GithubSigninScreen(
        params: params, // Parameters for GitHub sign-in.
        headerColor: AppColor.primaryColor, // Color of the header for the sign-in screen.
        title: 'Login with GitHub', // Title displayed on the sign-in screen.
      );
    })).then((value) async {
      // Casts the response to the expected type.
      GithubSignInResponse githubSignInResponse = value as GithubSignInResponse;

      // If the access token is valid, create a credential.
      if (githubSignInResponse.accessToken != null) {

        // Store the access token securely.
        AppSecureStorage.storeAccessToken(githubSignInResponse.accessToken ?? "");

        // Create a GitHub credential using the access token.
        final githubAuthCredential = GithubAuthProvider.credential(
            githubSignInResponse.accessToken ?? "" // Use the access token.
        );

        // Use the credential to sign in with Firebase and return the UserCredential.
        return await FirebaseAuth.instance.signInWithCredential(githubAuthCredential);
      }
    });

    // Return null if the sign-in process does not complete successfully.
    return null;
  }

}

