import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Hakkinda extends StatefulWidget {
  const Hakkinda({super.key});

  @override
  State<Hakkinda> createState() => _HakkindaState();
}

class _HakkindaState extends State<Hakkinda> {
  String appVersion = "";

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text(
          'Hakkında',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlue,Colors.lightBlueAccent], // Gradient renkleri
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent, // Sınır rengini değiştirmek için
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: ExpansionTile(
                title: Text("Hizmetlerimiz",style: TextStyle(fontSize: 20,color: Colors.black),),
                iconColor: Colors.blueAccent, // İkonun rengi açık olduğunda
                collapsedIconColor: Colors.blueAccent, // İkonun rengi kapalı olduğunda
                children: <Widget>[
                  ListTile(
                    title: Text("Gündelik yaşantınızda size yardımcı olmak adına günlük yapılacak listesi oluşturma, "
                        "farklı kategoride görev tanımlama ve yaklaşan görevleri hatırlatan bir yardımcı mobil uygulama."),
                  ),
                ],
              ),
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent, // Sınır rengini değiştirmek için
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: ExpansionTile(
                title: Text("Misyonumuz",style: TextStyle(fontSize: 20,color: Colors.black),),
                iconColor: Colors.blueAccent, // İkonun rengi açık olduğunda
                collapsedIconColor: Colors.blueAccent, // İkonun rengi kapalı olduğunda
                children: <Widget>[
                  ListTile(
                    title: Text("Günlük yaşantınızda görevlerinizi sizin yerinize takip etmek "
                        "ve zaman yönetiminize yardımcı olmak."),
                  ),
                ],
              ),
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent, // Sınır rengini değiştirmek için
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: ExpansionTile(
                title: Text("Vizyonumuz",style: TextStyle(fontSize: 20,color: Colors.black),),
                iconColor: Colors.blueAccent, // İkonun rengi açık olduğunda
                collapsedIconColor: Colors.blueAccent, // İkonun rengi kapalı olduğunda
                children: <Widget>[
                  ListTile(
                    title: Text("Dünya çapında kullanıcıların zaman yönetimini ve görev organizasyonunu mükemmelleştiren,"
                        " modern ve erişilebilir bir araç sunarak, hayatı daha organize ve dengeli hale getirmek."),
                  ),
                ],
              ),
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent, // Sınır rengini değiştirmek için
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExpansionTile(
                title: const Text("Uygulama Versiyonu",style: TextStyle(fontSize: 20,color: Colors.black),),
                iconColor: Colors.blueAccent, // İkonun rengi açık olduğunda
                collapsedIconColor: Colors.blueAccent, // İkonun rengi kapalı olduğunda
                children: <Widget>[
                  ListTile(
                    title: Text(appVersion),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
