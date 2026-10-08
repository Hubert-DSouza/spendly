// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../theme/app_theme.dart';
// import '../widgets/app_text_field.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   bool isLogin = true;
//   bool loading = false;

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> submit() async {
//     final email = emailController.text.trim();
//     final password = passwordController.text.trim();

//     if (email.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill in all fields')),
//       );
//       return;
//     }

//     setState(() => loading = true);

//     try {
//       if (isLogin) {
//         await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: email,
//           password: password,
//         );
//       } else {
//         await FirebaseAuth.instance.createUserWithEmailAndPassword(
//           email: email,
//           password: password,
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.message ?? 'Authentication failed')),
//       );
//     } finally {
//       if (mounted) setState(() => loading = false);
//     }
//   }

//   Future<void> forgotPassword() async {
//     final email = emailController.text.trim();
//     if (email.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Enter your email first')),
//       );
//       return;
//     }

//     try {
//       await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Password reset email sent')),
//       );
//     } on FirebaseAuthException catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.message ?? 'Could not send reset email')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(maxWidth: 420),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     isLogin ? 'Welcome back' : 'Create an account',
//                     style: GoogleFonts.poppins(
//                       fontSize: 24,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.ink,
//                       height: 1.2,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     isLogin
//                         ? 'Log in to continue to Spendly'
//                         : 'Start managing your money better',
//                     style: GoogleFonts.poppins(
//                       fontSize: 12,
//                       color: AppColors.muted,
//                     ),
//                   ),
//                   const SizedBox(height: 28),

//                   // Email
//                   AppTextField(
//                     controller: emailController,
//                     hint: 'Email',
//                     icon: Icons.mail_outline,
//                     keyboardType: TextInputType.emailAddress,
//                   ),
//                   const SizedBox(height: 12),

//                   // Password
//                   AppTextField(
//                     controller: passwordController,
//                     hint: 'Password',
//                     icon: Icons.lock_outline,
//                     obscureText: true,
//                   ),

//                   // Forgot Password Link
//                   if (isLogin)
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: TextButton(
//                         onPressed: loading ? null : forgotPassword,
//                         style: TextButton.styleFrom(
//                           padding: const EdgeInsets.only(top: 4, bottom: 4),
//                           minimumSize: Size.zero,
//                           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                         ),
//                         child: Text(
//                           'Forgot password?',
//                           style: GoogleFonts.poppins(
//                             fontSize: 11,
//                             color: AppColors.primary,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),

//                   const SizedBox(height: 18),

//                   // Submit Button
//                   SizedBox(
//                     width: double.infinity,
//                     height: 46,
//                     child: ElevatedButton(
//                       onPressed: loading ? null : submit,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primary,
//                         foregroundColor: Colors.white,
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: Text(
//                         loading
//                             ? 'Please wait...'
//                             : isLogin
//                                 ? 'Log in'
//                                 : 'Create account',
//                         style: GoogleFonts.poppins(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 18),

//                   // Mode Toggle Button
//                   Center(
//                     child: TextButton(
//                       onPressed: loading ? null : () => setState(() => isLogin = !isLogin),
//                       style: TextButton.styleFrom(
//                         padding: EdgeInsets.zero,
//                         minimumSize: Size.zero,
//                         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                       ),
//                       child: Text(
//                         isLogin
//                             ? "Don't have an account? Create an account"
//                             : "Already have an account? Log in",
//                         style: GoogleFonts.poppins(
//                           fontSize: 11,
//                           color: AppColors.muted,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLogin = true;

  Future<void> signUp() async {
    if (passwordController.text == confirmPasswordController.text) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } on FirebaseAuthException catch (e) {
        print("CODE: ${e.code}");
        print("MESSAGE: ${e.message}");

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("${e.code}: ${e.message}")));
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Passwords are not matching.")));
    }
  }

  Future<void> forgotPassword() async {
    try {
      print("Sending to: ${emailController.text.trim()}");

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      print("RESET EMAIL SENT");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Reset email sent!")));
    } on FirebaseAuthException catch (e) {
      print("ERROR CODE: ${e.code}");
      print("ERROR MESSAGE: ${e.message}");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("${e.code}: ${e.message}")));
    }
  }

  Future<void> login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Invalid Email or Password")));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin == true) {
      return Scaffold(
        //Login Modal
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.asset('lib/assets/images/splash_image.png', scale: 5),
                  // Text(
                  //   "Login",
                  //   style: GoogleFonts.poppins(
                  //     fontSize: 24,
                  //     fontWeight: FontWeight.bold,
                  //     color: AppColors.primary,
                  //   ),
                  // ),
                  SizedBox(height: AppSpacing.lg),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hint: Text(
                        "Email",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hint: Text(
                        "Password",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl),
                  ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: WidgetStatePropertyAll(
                        Size(double.infinity, 50),
                      ),
                      backgroundColor: WidgetStatePropertyAll(
                        AppColors.primary,
                      ),
                      foregroundColor: WidgetStatePropertyAll(
                        AppColors.surface,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      textStyle: WidgetStatePropertyAll(
                        GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    onPressed: () {
                      login();
                    },
                    child: Text("Login"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Dont have an account yet? ",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Forgot Password?",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          forgotPassword();
                        },
                        child: Text(
                          "Reset Password",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      //Sign up modal
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset('lib/assets/images/splash_image.png', scale: 5),
                // Text(
                //   "Sign Up",
                //   style: GoogleFonts.poppins(
                //     fontSize: 24,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                SizedBox(height: AppSpacing.lg),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hint: Text(
                      "Email",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hint: Text(
                      "Password",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                TextField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    hint: Text(
                      "Confirm Password",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.xl),
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: WidgetStatePropertyAll(
                      Size(double.infinity, 50),
                    ),
                    backgroundColor: WidgetStatePropertyAll(AppColors.primary),
                    foregroundColor: WidgetStatePropertyAll(AppColors.surface),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    textStyle: WidgetStatePropertyAll(
                      GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  onPressed: () {
                    signUp();
                  },
                  child: Text("Sign Up"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Have an account? ",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(
                        "Login",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
