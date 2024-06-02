import 'package:chatapp_firebase/pages/auth/login_page.dart';
import 'package:chatapp_firebase/pages/home_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  String userName;
  String email;
  ProfilePage({Key? key, required this.email, required this.userName})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profils",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 27,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Color.fromARGB(255, 0, 75, 23), Colors.teal],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40.0, 
                    backgroundColor: Colors.grey[700],
                    child: Icon(Icons.account_circle, size: 40.0, color: Colors.white),
                  ),
                  const SizedBox(width: 15.0),
                  Expanded(
                    child: Text(
                      widget.userName,
                      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Color.fromARGB(255, 0, 75, 23), Colors.teal],
                ),
              ),
            ),

            const Divider(height: 2.0, thickness: 2.0),

            Expanded(
              child: ListView.builder(
                itemCount: 1, 
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return ListTile(
                      onTap: () {
                        nextScreen(context, const HomePage()); 
                      },
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      leading: const Icon(Icons.group, size: 30.0),
                      title: const Text(
                        "Grupas",
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    );
                  } else {
                    return const SizedBox(); 
                  }
                },
              ),
            ),

            ListTile(
              onTap: () async {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Atslēgties"),
                      content: const Text("Vai tiešām vēlaties atslēgties?"),
                      actions: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.cancel, color: Colors.red),
                        ),
                        IconButton(
                          onPressed: () async {
                            await authService.signOut();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                              (route) => false,
                            );
                          },
                          icon: const Icon(Icons.done, color: Colors.green),
                        ),
                      ],
                    );
                  },
                );
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: const Icon(Icons.exit_to_app, size: 30.0),
              title: const Text(
                "Atslēgties",
                style: TextStyle(fontSize: 16.0, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 170),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.account_circle,
              size: 200,
              color: Colors.grey[700],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Lietotāja vārds un uzvārds", style: TextStyle(fontSize: 17)),
                Text(widget.userName, style: const TextStyle(fontSize: 17)),
              ],
            ),
            const Divider(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("E-pasts", style: TextStyle(fontSize: 17)),
                Text(widget.email, style: const TextStyle(fontSize: 17)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
