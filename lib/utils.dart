import 'package:login_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';



Future<void> SetupFirebase() async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}