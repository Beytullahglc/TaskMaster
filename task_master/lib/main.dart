
import 'dart:collection';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_master/cubits/gorevlerCubit.dart';
import 'package:task_master/firebase_options.dart';
import 'package:task_master/views/sayfalar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GorevlerCubit>(
          create: (context) => GorevlerCubit(),
        ),

      ],
      child: MaterialApp(
        title: '',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(

          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginPage(title: ''),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late AnimationController iconKontrol;
  late Animation<double> iconAnimasyonDegerleri;

  var refGorevler = FirebaseDatabase.instance.ref().child("gorevler_tablo");

  /*Future<void> gorevEkle() async{
    var bilgi = HashMap<String,dynamic>();
    bilgi["gorevId"] = "";
    bilgi["gorevAdi"] = "Ders çalışma";
    bilgi["aciklama"] = "Deneme çözülecek";
    bilgi["kategori"] = "Öğrenim";
    bilgi["bitisTarihi"] = DateTime.now().add(Duration(days: 1)).toIso8601String();
    bilgi["bittiMi"] = false;

    refGorevler.push().set(bilgi);
  }*/

  @override
  void initState() {
    super.initState();

   // gorevEkle();

    iconKontrol = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);

    iconAnimasyonDegerleri = Tween(begin: 0.0, end: 220.0)
        .animate(CurvedAnimation(parent: iconKontrol, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      });

    iconKontrol.forward();
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorMassage;
  bool isLogin = true;
  String? userId;

  void _showSnackBar() {
    const snackBar = SnackBar(
      content: Text('Hesap Başarıyla Kaydedildi!'),
      backgroundColor: Colors.blueAccent,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    double ekranYuksekligi = ekranBilgisi.size.height;
    double ekranGenisligi = ekranBilgisi.size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: ekranYuksekligi / 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: ekranYuksekligi / 15, bottom: 20),
                  child: SizedBox(
                    width: iconAnimasyonDegerleri.value,
                    height: iconAnimasyonDegerleri.value,
                    child: Image.asset("assets/TaskMaster.png"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: ekranGenisligi * 4 / 5,
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "E mail",
                      hintStyle: TextStyle(color: Colors.blueAccent),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: ekranGenisligi * 4 / 5,
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.blueAccent),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    ),
                  ),
                ),
              ),
              if (errorMassage != null)
                Text(errorMassage!),
              Padding(
                padding: const EdgeInsets.only(top: 60, bottom: 20),
                child: SizedBox(
                  width: ekranGenisligi *3/ 7,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Sayfalar()),
                      );
                      /*if (isLogin) {
                        signIn(context);
                      } else {
                        createUser();
                      }*/
                    },
                    child: Text(
                      isLogin ? "Giriş Yap" : "Kayıt Ol",
                      style: TextStyle(
                        fontSize: ekranGenisligi / 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    isLogin ? "Kayıt Ol" : "Giriş Yap",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: ekranGenisligi / 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
