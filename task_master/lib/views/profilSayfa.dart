import 'package:flutter/material.dart';
import 'package:task_master/views/hakkinda.dart';
import 'package:task_master/views/sifreDegistirme.dart';

class ProfilSayfa extends StatefulWidget {
  const ProfilSayfa({super.key});

  @override
  State<ProfilSayfa> createState() => _ProfilSayfaState();
}

class _ProfilSayfaState extends State<ProfilSayfa> {

  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil",style: TextStyle(color: Colors.white),),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlue, Colors.lightBlueAccent], // Gradient renkleri
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(

        children: [


          Padding(
            padding: const EdgeInsets.only(top:10,bottom: 10),
            child: ListTile(
              title: const Text("Şifre Değiştir",style: TextStyle(fontSize: 20),),
              trailing: const Icon(Icons.arrow_right,color: Colors.blue,),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SifreDegistirme()));
              },
            ),
          ),



          Padding(
            padding: const EdgeInsets.only(top:10,bottom: 10),
            child: ListTile(
              title: const Text("Hakkında",style: TextStyle(fontSize: 20),),
              trailing: const Icon(Icons.arrow_right,color: Colors.blue,),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Hakkinda()));
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 10,bottom: 10),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text("Bildirimler", style: TextStyle(color: Colors.black, fontSize: 20),),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isSwitched = !isSwitched;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only( right: 12.0),
                      child: Container(
                        width: 40.0,  // Switch genişliği
                        height: 20.0, // Switch yüksekliği
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: isSwitched ? Colors.blue : Colors.grey,
                        ),
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          alignment: isSwitched ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            width: 16.0, // Thumb boyutu
                            height: 16.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

          ),
        ],
      ),
    );
  }
}
