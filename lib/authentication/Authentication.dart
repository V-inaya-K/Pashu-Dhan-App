// // // import 'package:flutter/material.dart';
// // // import 'package:google_fonts/google_fonts.dart';
// // // import 'package:animated_splash_screen/animated_splash_screen.dart';
// // // import 'package:lottie/lottie.dart';
// // // import 'package:supabase_flutter/supabase_flutter.dart';
// // // import 'package:pashudhan/pages/Homepage.dart';
// // //
// // // class SplashScreen extends StatelessWidget {
// // //   final Widget? nextScreen;
// // //
// // //   const SplashScreen({super.key, this.nextScreen});
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return AnimatedSplashScreen(
// // //       splash: Center(child: Lottie.asset('assets/success.json')),
// // //       nextScreen: nextScreen ?? const Login(),
// // //       duration: 1000,
// // //       backgroundColor: Colors.black,
// // //       splashIconSize: 500,
// // //     );
// // //   }
// // // }
// // //
// // // class Login extends StatefulWidget {
// // //   const Login({super.key});
// // //
// // //   @override
// // //   State<Login> createState() => _LoginState();
// // // }
// // //
// // // class _LoginState extends State<Login> {
// // //   final TextEditingController useridController = TextEditingController();
// // //   final TextEditingController passwordController = TextEditingController();
// // //   bool passwordVisible=false;
// // //   bool isSignup = true;
// // //   final supabase = Supabase.instance.client;
// // //
// // //   // Future<void> onSubmit() async {
// // //   //   final userid = useridController.text.trim();
// // //   //   final password = passwordController.text.trim();
// // //   //
// // //   //   if (userid.isEmpty || password.isEmpty ) {
// // //   //     ScaffoldMessenger.of(context).showSnackBar(
// // //   //       const SnackBar(content: Text("All fields are required.")),
// // //   //     );
// // //   //     return;
// // //   //   }
// // //   //
// // //   //   try {
// // //   //     if (isSignup) {
// // //   //       final response = await supabase.auth.signUp(
// // //   //         email: userid,
// // //   //         password: password,
// // //   //         data: {
// // //   //           'name': useridController.text.trim(),
// // //   //         },
// // //   //       );
// // //   //       if (response.user == null) {
// // //   //         throw Exception("Signup failed");
// // //   //       }
// // //   //     } else {
// // //   //       final response = await supabase.auth.signInWithPassword(
// // //   //         email: userid,
// // //   //         password: password,
// // //   //       );
// // //   //       if (response.user == null) {
// // //   //         throw Exception("Login failed");
// // //   //       }
// // //   //     }
// // //   //
// // //   //     Navigator.pushReplacement(
// // //   //       context,
// // //   //       MaterialPageRoute(builder: (context) => MyIntro()),
// // //   //     );
// // //   //   } catch (e) {
// // //   //     ScaffoldMessenger.of(context).showSnackBar(
// // //   //       SnackBar(content: Text('Error: ${e.toString()}')),
// // //   //     );
// // //   //   }
// // //   // }
// // //   Future<void> onSubmit() async {
// // //     final userid = useridController.text.trim();
// // //     final password = passwordController.text.trim();
// // //
// // //     if (userid.isEmpty || password.isEmpty) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         const SnackBar(content: Text("All fields are required.")),
// // //       );
// // //       return;
// // //     }
// // //
// // //     try {
// // //       if (isSignup) {
// // //         final response = await supabase.auth.signUp(
// // //           email: userid,
// // //           password: password,
// // //           data: {'name': userid}, // optional metadata
// // //         );
// // //         if (response.user == null) throw Exception("Signup failed");
// // //       } else {
// // //         final response = await supabase.auth.signInWithPassword(
// // //           email: userid,
// // //           password: password,
// // //         );
// // //         if (response.user == null) throw Exception("Login failed");
// // //       }
// // //
// // //       // ✅ After login/signup success
// // //       Navigator.pushReplacement(
// // //         context,
// // //         MaterialPageRoute(builder: (context) => MyIntro()),
// // //       );
// // //     } catch (e) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text('Error: ${e.toString()}')),
// // //       );
// // //     }
// // //   }
// // //
// // //
// // //   Future<void> signInWithGoogle() async {
// // //     try {
// // //       await Supabase.instance.client.auth.signInWithOAuth(
// // //         OAuthProvider.google,redirectTo:'http://localhost:55613/',);
// // //
// // //       // OAuth redirects will bring user back to app if configured properly
// // //     } catch (e) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         SnackBar(content: Text('Google Sign-In failed: ${e.toString()}')),
// // //       );
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: Colors.blueAccent,
// // //       body: SingleChildScrollView(
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.center,
// // //           children: [
// // //             Container(
// // //               height: 150,
// // //               decoration: const BoxDecoration(
// // //                 color: Colors.white,
// // //                 borderRadius: BorderRadius.only(
// // //                   bottomLeft: Radius.circular(20),
// // //                   bottomRight: Radius.circular(20),
// // //                 ),
// // //               ),
// // //               child: Center(
// // //                 child: Image.asset('uio.jpg', height: double.maxFinite),
// // //               ),
// // //             ),
// // //             const SizedBox(height: 20,),
// // //             Container(
// // //               margin: const EdgeInsets.symmetric(horizontal: 40),
// // //               child: Column(
// // //                 children: [
// // //                   Text(
// // //                     "LOGIN",
// // //
// // //                     style: GoogleFonts.poppins(
// // //                         fontSize: 30,
// // //                         color: Colors.white
// // //                     ),
// // //                   ),
// // //                   const SizedBox(height: 20),
// // //                   Column(
// // //                       children: [
// // //                         TextField(
// // //                           controller: useridController,
// // //                           decoration: const InputDecoration(
// // //                             filled: true,
// // //                             fillColor: Colors.white,
// // //                             hintText: "Enter Your Id",
// // //                             focusedBorder: OutlineInputBorder(
// // //                               borderRadius: BorderRadius.all(Radius.circular(100)),
// // //                               borderSide: BorderSide(width: 3, color: Colors.black),
// // //                             ),
// // //                             enabledBorder: OutlineInputBorder(
// // //                               borderRadius: BorderRadius.all(Radius.circular(4)),
// // //                               borderSide: BorderSide(width: 3, color: Colors.black),
// // //                             ),
// // //                           ),
// // //                         ),
// // //                         const SizedBox(height: 10),
// // //                       ],
// // //                     ),
// // //                   TextField(
// // //                     controller: passwordController,
// // //                     maxLength: 8,
// // //                     obscureText: !passwordVisible, // <-- controls hiding/showing
// // //                     decoration: InputDecoration(
// // //                       filled: true,
// // //                       fillColor: Colors.white,
// // //                       hintText: "Enter 8 digit Password",
// // //                       focusedBorder: const OutlineInputBorder(
// // //                         borderRadius: BorderRadius.all(Radius.circular(100)),
// // //                         borderSide: BorderSide(width: 3, color: Colors.black),
// // //                       ),
// // //                       enabledBorder: const OutlineInputBorder(
// // //                         borderRadius: BorderRadius.all(Radius.circular(4)),
// // //                         borderSide: BorderSide(width: 3, color: Colors.black),
// // //                       ),
// // //                       suffixIcon: IconButton(
// // //                         icon: Icon(
// // //                           passwordVisible ? Icons.visibility : Icons.visibility_off,
// // //                           color: Colors.black87,
// // //                         ),
// // //                         onPressed: () {
// // //                           setState(() {
// // //                             passwordVisible = !passwordVisible;
// // //                           });
// // //                         },
// // //                       ),
// // //                     ),
// // //                   ),
// // //                   const SizedBox(height: 20),
// // //                   SizedBox(
// // //                     height: 50,
// // //                     child: ElevatedButton(
// // //                       onPressed: onSubmit,
// // //                       style: ElevatedButton.styleFrom(
// // //                         backgroundColor: Colors.black,
// // //                         padding: const EdgeInsets.symmetric(
// // //                           vertical: 15,
// // //                           horizontal: 80,
// // //                         ),
// // //                         shape: RoundedRectangleBorder(
// // //                           borderRadius: BorderRadius.circular(10),
// // //                         ),
// // //                       ),
// // //                       child: Text(
// // //                         "Login",
// // //                         style: GoogleFonts.poppins(
// // //                           fontSize: 18,
// // //                           color: Colors.white,
// // //                         ),
// // //                       ),
// // //                     ),
// // //                   ),
// // //
// // //                 ],
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';
// // import 'package:pashudhan/pages/intro.dart';
// // import 'package:pashudhan/pages/Homepage.dart';
// //
// // class Login extends StatefulWidget {
// //   const Login({super.key});
// //
// //   @override
// //   State<Login> createState() => _LoginState();
// // }
// //
// // class _LoginState extends State<Login> {
// //   final TextEditingController useridController = TextEditingController();
// //   final TextEditingController passwordController = TextEditingController();
// //   bool passwordVisible = false;
// //   bool isSignup = false; // set false if default is login
// //   final supabase = Supabase.instance.client;
// //
// //   Future<void> onSubmit() async {
// //     final userid = useridController.text.trim();
// //     final password = passwordController.text.trim();
// //
// //     if (userid.isEmpty || password.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("All fields are required.")),
// //       );
// //       return;
// //     }
// //
// //     try {
// //       AuthResponse response;
// //       if (isSignup) {
// //         response = await supabase.auth.signUp(
// //           email: userid,
// //           password: password,
// //           data: {'name': userid},
// //         );
// //       } else {
// //         response = await supabase.auth.signInWithPassword(
// //           email: userid,
// //           password: password,
// //         );
// //       }
// //
// //       final user = response.user;
// //       if (user == null) throw Exception("Authentication failed");
// //
// //       // ✅ Wait for session to persist
// //       await supabase.auth.refreshSession();
// //
// //       // Navigate to homepage
// //       Navigator.pushReplacement(
// //         context,
// //         MaterialPageRoute(builder: (context) => MyIntro()),
// //       );
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Error: ${e.toString()}')),
// //       );
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.blueAccent,
// //       body: SingleChildScrollView(
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.center,
// //           children: [
// //             Container(
// //               height: 150,
// //               decoration: const BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.only(
// //                   bottomLeft: Radius.circular(20),
// //                   bottomRight: Radius.circular(20),
// //                 ),
// //               ),
// //               child: Center(
// //                 child: Image.asset('uio.jpg', height: double.maxFinite),
// //               ),
// //             ),
// //             const SizedBox(height: 20),
// //             Container(
// //               margin: const EdgeInsets.symmetric(horizontal: 40),
// //               child: Column(
// //                 children: [
// //                   Text("LOGIN",
// //                       style: GoogleFonts.poppins(
// //                           fontSize: 30, color: Colors.white)),
// //                   const SizedBox(height: 20),
// //                   TextField(
// //                     controller: useridController,
// //                     decoration: const InputDecoration(
// //                       filled: true,
// //                       fillColor: Colors.white,
// //                       hintText: "Enter Your Email",
// //                       focusedBorder: OutlineInputBorder(
// //                         borderRadius: BorderRadius.all(Radius.circular(100)),
// //                         borderSide: BorderSide(width: 3, color: Colors.black),
// //                       ),
// //                       enabledBorder: OutlineInputBorder(
// //                         borderRadius: BorderRadius.all(Radius.circular(4)),
// //                         borderSide: BorderSide(width: 3, color: Colors.black),
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 10),
// //                   TextField(
// //                     controller: passwordController,
// //                     maxLength: 8,
// //                     obscureText: !passwordVisible,
// //                     decoration: InputDecoration(
// //                       filled: true,
// //                       fillColor: Colors.white,
// //                       hintText: "Enter 8 digit Password",
// //                       focusedBorder: const OutlineInputBorder(
// //                         borderRadius: BorderRadius.all(Radius.circular(100)),
// //                         borderSide: BorderSide(width: 3, color: Colors.black),
// //                       ),
// //                       enabledBorder: const OutlineInputBorder(
// //                         borderRadius: BorderRadius.all(Radius.circular(4)),
// //                         borderSide: BorderSide(width: 3, color: Colors.black),
// //                       ),
// //                       suffixIcon: IconButton(
// //                         icon: Icon(
// //                           passwordVisible
// //                               ? Icons.visibility
// //                               : Icons.visibility_off,
// //                           color: Colors.black87,
// //                         ),
// //                         onPressed: () {
// //                           setState(() {
// //                             passwordVisible = !passwordVisible;
// //                           });
// //                         },
// //                       ),
// //                     ),
// //                   ),
// //                   const SizedBox(height: 20),
// //                   SizedBox(
// //                     height: 50,
// //                     child: ElevatedButton(
// //                       onPressed: onSubmit,
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: Colors.black,
// //                         padding: const EdgeInsets.symmetric(
// //                           vertical: 15,
// //                           horizontal: 80,
// //                         ),
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(10),
// //                         ),
// //                       ),
// //                       child: Text(
// //                         "Login",
// //                         style: GoogleFonts.poppins(
// //                           fontSize: 18,
// //                           color: Colors.white,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// // ----------------
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:pashudhan/pages/intro.dart';
// import 'package:pashudhan/pages/Homepage.dart';
//
// class Login extends StatefulWidget {
//   const Login({super.key});
//
//   @override
//   State<Login> createState() => _LoginState();
// }
//
// class _LoginState extends State<Login> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool passwordVisible = false;
//
//   final supabase = Supabase.instance.client;
//
//   Future<void> onSubmit() async {
//     final email = emailController.text.trim();
//     final password = passwordController.text.trim();
//
//     if (email.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("All fields are required.")),
//       );
//       return;
//     }
//
//     try {
//       // 1️⃣ Authenticate user via Supabase Auth
//       final AuthResponse response = await supabase.auth.signInWithPassword(
//         email: email,
//         password: password,
//       );
//
//       final user = response.user;
//       if (user == null) throw Exception("Authentication failed");
//
//       // 2️⃣ Fetch user details from user_data table
//       final userData = await supabase
//           .from('user_data')
//           .select('email, name')
//           .eq('email', email)
//           .single();
//
//       if (userData == null) {
//         throw Exception("User data not found in user_data table");
//       }
//
//       // Optional: Save user info locally if needed
//       // e.g., SharedPreferences, Provider, Riverpod, etc.
//
//       // 3️⃣ Navigate to homepage (pass user details if needed)
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => MyIntro(
//             userEmail: userData['email'],
//             userName: userData['name'],
//           ),
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: ${e.toString()}')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blueAccent,
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               height: 150,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(20),
//                   bottomRight: Radius.circular(20),
//                 ),
//               ),
//               child: Center(
//                 child: Image.asset('uio.jpg', height: double.maxFinite),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 40),
//               child: Column(
//                 children: [
//                   Text("LOGIN",
//                       style: GoogleFonts.poppins(
//                           fontSize: 30, color: Colors.white)),
//                   const SizedBox(height: 20),
//                   TextField(
//                     controller: emailController,
//                     decoration: const InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white,
//                       hintText: "Enter Your Email",
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   TextField(
//                     controller: passwordController,
//                     maxLength: 8,
//                     obscureText: !passwordVisible,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white,
//                       hintText: "Enter 8 digit Password",
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           passwordVisible
//                               ? Icons.visibility
//                               : Icons.visibility_off,
//                           color: Colors.black87,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             passwordVisible = !passwordVisible;
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   SizedBox(
//                     height: 50,
//                     child: ElevatedButton(
//                       onPressed: onSubmit,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.black,
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 15,
//                           horizontal: 80,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: Text(
//                         "Login",
//                         style: GoogleFonts.poppins(
//                           fontSize: 18,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// --------------------
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pashudhan/pages/intro.dart';
import 'package:pashudhan/pages/Homepage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController useridController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool passwordVisible = false;
  final supabase = Supabase.instance.client;

  Future<void> onSubmit() async {
    final userid = useridController.text.trim();
    final password = passwordController.text.trim();

    if (userid.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("All fields are required.")));
      return;
    }

    try {
      // Sign in using email/password
      final response = await supabase.auth.signInWithPassword(
        email: userid,
        password: password,
      );

      final user = response.user;
      if (user == null) throw Exception("Invalid credentials");

      // Fetch user info from user_data
      final userData = await supabase
          .from('user_data')
          .select('email, name')
          .eq('email', user.email as Object)
          .single();

      if (userData == null) throw Exception("User data not found");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyIntro(
            userEmail: userData['email'],
            userName: userData['name'],
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 230,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Image.asset('assets/images/uio.jpg', height: double.maxFinite),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Text("LOGIN",
                      style: GoogleFonts.poppins(
                          fontSize: 30, color: Colors.white)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: useridController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Enter Your Email",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        borderSide: BorderSide(width: 3, color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 3, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    maxLength: 8,
                    obscureText: !passwordVisible,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Enter 8 digit Password",
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        borderSide: BorderSide(width: 3, color: Colors.black),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 3, color: Colors.black),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black87,
                        ),
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 80,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Login",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
