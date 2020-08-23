import 'package:eopy_management_system/ui/firebase/login_op.dart';
import 'package:eopy_management_system/ui/main/main_frame.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(EopyMS());
}

class EopyMS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(primarySwatch: Colors.blue, backgroundColor: Colors.white),
      home: MainFramePage(),
    );
  }
}
