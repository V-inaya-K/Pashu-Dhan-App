// // import 'package:flutter/material.dart';
// // import 'package:pashudhan/Authentication/Authentication.dart';
// // import 'package:pashudhan/Authentication/Authkey.dart';
// // import 'package:pashudhan/pages/Homepage.dart';
// // import 'package:pashudhan/pages/intro.dart';
// // import 'package:supabase_flutter/supabase_flutter.dart';
// //
// // Future<void> main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //
// //   await Supabase.initialize(
// //     url: supabaseUrl,
// //     anonKey: supabaseAnonKey,
// //   );
// //
// //   runApp(MyApp());
// // }
// //
// //
// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});
// //
// //   // This widget is the root of your application.
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Flutter Demo',
// //       debugShowCheckedModeBanner: false,
// //       theme: ThemeData(
// //
// //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
// //         useMaterial3: true,
// //       ),
// //       // home: Login(),
// //       home:MyIntro(),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:pashudhan/Authentication/Authentication.dart';
// import 'package:pashudhan/Authentication/Authkey.dart';
// import 'package:pashudhan/pages/Homepage.dart';
// import 'package:pashudhan/pages/intro.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await Supabase.initialize(
//     url: supabaseUrl,
//     anonKey: supabaseAnonKey,
//   );
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final supabase = Supabase.instance.client;
//
//     // Check if user is already logged in
//     final user = supabase.auth.currentUser;
//
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       // If user is logged in, go to MyIntro, else Login
//       home: user != null ? MyIntro() : const Login(),
//     );
//   }
// }
// -------------
// import 'package:flutter/material.dart';
// import 'package:pashudhan/Authentication/Authentication.dart';
// import 'package:pashudhan/Authentication/Authkey.dart';
// import 'package:pashudhan/pages/Homepage.dart';
// import 'package:pashudhan/pages/intro.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await Supabase.initialize(
//     url: supabaseUrl,
//     anonKey: supabaseAnonKey,
//   );
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Pashu Dhan',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const Splash(),
//     );
//   }
// }
//
// /// Splash screen to check login and fetch user data
// class Splash extends StatefulWidget {
//   const Splash({super.key});
//
//   @override
//   State<Splash> createState() => _SplashState();
// }
//
// class _SplashState extends State<Splash> {
//   final supabase = Supabase.instance.client;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkUser();
//   }
//
//   Future<void> _checkUser() async {
//     final user = supabase.auth.currentUser;
//
//     if (user == null) {
//       // Not logged in
//       if (!mounted) return;
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const Login()),
//       );
//       return;
//     }
//
//     try {
//       // Fetch user info from user_data table using user_id
//       final userData = await supabase
//           .from('user_data')
//           .select('user_id, name')
//           .eq('user_id', user.id)
//           .single();
//
//       if (userData == null) throw Exception("User data not found");
//
//       if (!mounted) return;
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => MyIntro(
//             userEmail: user.email!,
//             userName: userData['name'],
//           ),
//         ),
//       );
//     } catch (e) {
//       await supabase.auth.signOut();
//       if (!mounted) return;
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const Login()),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(child: CircularProgressIndicator()),
//     );
//   }
// }
// ----------------------------
import 'package:flutter/material.dart';
import 'package:pashudhan/Authentication/Authentication.dart';
import 'package:pashudhan/Authentication/Authkey.dart';
import 'package:pashudhan/pages/Homepage.dart';
import 'package:pashudhan/pages/intro.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pashu Dhan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // 👇 directly handle auth check here instead of Splash
      home: const AuthRedirect(),
    );
  }
}

/// Decides which screen to show based on auth state
class AuthRedirect extends StatefulWidget {
  const AuthRedirect({super.key});

  @override
  State<AuthRedirect> createState() => _AuthRedirectState();
}

class _AuthRedirectState extends State<AuthRedirect> {
  final supabase = Supabase.instance.client;
  bool _loading = true;
  Widget? _screen;

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      // Not logged in → go to login
      if (!mounted) return;
      setState(() {
        _screen = const Login();
        _loading = false;
      });
      return;
    }

    try {
      // Fetch user info
      final userData = await supabase
          .from('user_data')
          .select('user_id, name')
          .eq('user_id', user.id)
          .single();

      if (userData == null) throw Exception("User data not found");

      if (!mounted) return;
      setState(() {
        _screen = MyIntro(
          userEmail: user.email!,
          userName: userData['name'],
        );
        _loading = false;
      });
    } catch (e) {
      await supabase.auth.signOut();
      if (!mounted) return;
      setState(() {
        _screen = const Login();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return _screen!;
  }
}
