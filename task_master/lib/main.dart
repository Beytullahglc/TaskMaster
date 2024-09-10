import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:task_master/cubits/bildirimlerCubit.dart';
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
        BlocProvider<BildirimlerCubit>(
          create: (context) => BildirimlerCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Task Master',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginPage(title: 'Task Master Login'),
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
  late AnimationController iconController;
  late Animation<double> iconAnimation;

  final refGorevler = FirebaseDatabase.instance.ref().child("gorevler_tablo");
  final refBildirimler = FirebaseDatabase.instance.ref().child("bildirimler_tablo"); // Bildirimler için referans
  final FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();

  Timer? hourlyNotificationTimer;
  bool dailyNotificationShown = false;

  @override
  void initState() {
    super.initState();

    _initializeNotifications();
    _setupDatabaseListener();
    _startHourlyNotificationTimer();

    iconController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    iconAnimation = Tween<double>(begin: 0.0, end: 220.0)
        .animate(CurvedAnimation(parent: iconController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      });
    iconController.forward();

    _checkForDailyNotification();
  }

  Future<void> _initializeNotifications() async {
    const androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInitializationSettings = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    await flp.initialize(initializationSettings, onDidReceiveNotificationResponse: _onNotificationSelect);
  }

  Future<void> _onNotificationSelect(NotificationResponse notificationResponse) async {
    final payload = notificationResponse.payload;
    if (payload != null) {
      print("Notification Selected: $payload");
      // Burada bildirim seçildiğinde yapılacak işlemler
    }
  }

  void _setupDatabaseListener() {
    refGorevler.onValue.listen((event) {
      _checkHourlyTasks();
    });
  }

  void _startHourlyNotificationTimer() {
    hourlyNotificationTimer = Timer.periodic(const Duration(minutes: 10), (timer) => _checkHourlyTasks());
  }

  void _checkForDailyNotification() async {
    final now = DateTime.now();

    // Check if daily notification has already been shown
    if (!dailyNotificationShown && now.hour >= 8) {
      await _showDailyNotification();
      setState(() {
        dailyNotificationShown = true;
      });
    }
  }

  Future<void> _showDailyNotification() async {
    final event = await refGorevler.once();
    final snapshot = event.snapshot;

    final now = DateTime.now();
    final List<String> dailyTasks = [];

    if (snapshot.value != null) {
      final tasks = snapshot.value as Map<dynamic, dynamic>;
      tasks.forEach((key, task) {
        final endDate = DateTime.parse(task['bitisTarihi']);
        final taskName = task['gorevAdi'];

        if (endDate.day == now.day && endDate.month == now.month && endDate.year == now.year) {
          dailyTasks.add(taskName);
        }
      });
    }

    if (dailyTasks.isNotEmpty) {
      const androidNotificationDetails = AndroidNotificationDetails(
        "daily_channel_id", "Daily Tasks", channelDescription: "Daily Tasks Channel",
        priority: Priority.high, importance: Importance.max,
      );

      const iosNotificationDetails = DarwinNotificationDetails();
      const notificationDetails = NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails);

      await flp.show(
        0,
        "Daily Tasks",
        "Today's tasks: ${dailyTasks.join(", ")}",
        notificationDetails,
        payload: "Daily Task Notification",
      );

      // Firebase'e bildirim kaydet
      await _saveNotificationToFirebase("Daily Tasks", "Today's tasks: ${dailyTasks.join(", ")}");
    }
  }

  Future<void> _checkHourlyTasks() async {
    final event = await refGorevler.once();
    final snapshot = event.snapshot;

    final now = DateTime.now();
    final List<String> hourlyTasks = [];

    if (snapshot.value != null) {
      final tasks = snapshot.value as Map<dynamic, dynamic>;
      tasks.forEach((key, task) {
        final endDate = DateTime.parse(task['bitisTarihi']);
        final taskName = task['gorevAdi'];

        if (endDate.difference(now).inMinutes <= 60 && endDate.isAfter(now)) {
          hourlyTasks.add(taskName);
        }
      });
    }

    if (hourlyTasks.isNotEmpty) {
      const androidNotificationDetails = AndroidNotificationDetails(
        "hourly_channel_id", "Hourly Tasks", channelDescription: "Hourly Tasks Channel",
        priority: Priority.high, importance: Importance.max,
      );

      const iosNotificationDetails = DarwinNotificationDetails();
      const notificationDetails = NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails);

      await flp.show(
        1,
        "Upcoming Tasks",
        "Tasks ending within an hour: ${hourlyTasks.join(", ")}",
        notificationDetails,
        payload: "Hourly Task Notification",
      );

      // Firebase'e bildirim kaydet
      await _saveNotificationToFirebase("Upcoming Tasks", "Tasks ending within an hour: ${hourlyTasks.join(", ")}");
    }
  }

  Future<void> _saveNotificationToFirebase(String title, String body) async {
    final now = DateTime.now().toIso8601String();

    await refBildirimler.push().set({
      'baslik': title,
      'icerik': body,
      'tarih': now,
    });
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorMessage;
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context);
    final screenHeight = screenSize.size.height;
    final screenWidth = screenSize.size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: screenHeight / 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: screenHeight / 15, bottom: 20),
                  child: SizedBox(
                    width: iconAnimation.value,
                    height: iconAnimation.value,
                    child: Image.asset("assets/TaskMaster.png"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: screenWidth * 4 / 5,
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.blueAccent),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: screenWidth * 4 / 5,
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.blueAccent),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
              ),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 60, bottom: 20),
                child: SizedBox(
                  width: screenWidth * 3 / 7,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    onPressed: () async {
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();

                      if (isLogin) {
                        try {
                          await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Sayfalar(),
                            ),
                          );
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            errorMessage = e.message;
                          });
                        }
                      } else {
                        try {
                          await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Sayfalar(),
                            ),
                          );
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            errorMessage = e.message;
                          });
                        }
                      }
                    },
                    child: Text(isLogin ? 'Giriş Yap' : 'Kayıt Ol', style: const TextStyle(color: Colors.white),),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                    errorMessage = null;
                  });
                },
                child: Text(isLogin ? 'Kayıt ol' : 'Giriş yap', style: const TextStyle(color: Colors.blue),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    hourlyNotificationTimer?.cancel();
    iconController.dispose();
    super.dispose();
  }
}
