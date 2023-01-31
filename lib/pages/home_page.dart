import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/pages/auth/login_page.dart';
import 'package:chatapp_firebase/pages/profile_page.dart';
import 'package:chatapp_firebase/pages/search_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/service/database_service.dart';
import 'package:chatapp_firebase/widgets/group_tile.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";
  List<Map> category = [
    {"name": "PROCEDURE", "isChecked": false, "title": true},
    {"name": "Epidermal Cyst Excision", "isChecked": false, "title": false},
    {"name": "Pilar cyst Excision", "isChecked": false, "title": false},
    {"name": "Lipoma Excision", "isChecked": false, "title": false},
    {"name": "SITE", "isChecked": false, "title": true},
    {"name": "Scalp", "isChecked": false, "title": false},
    {"name": "Chest/Abdomen", "isChecked": false, "title": false},
    {"name": "Back", "isChecked": false, "title": false},
    {"name": "Upper Extremity", "isChecked": false, "title": false},
    {"name": "Lower Extremity", "isChecked": false, "title": false},
    {"name": "SCALPEL", "isChecked": false, "title": true},
    {"name": "15-Blade", "isChecked": false, "title": false},
    {"name": "11-Blade", "isChecked": false, "title": false},
    {"name": "10-Blade", "isChecked": false, "title": false},
    {"name": "TOP SUTURE", "isChecked": false, "title": true},
    {"name": "3-0 Prolene (Polypropylene)", "isChecked": false, "title": false},
    {"name": "4-0 Prolene (Polypropylene)", "isChecked": false, "title": false},
    {"name": "5-0 Prolene (Polypropylene)", "isChecked": false, "title": false},
    {"name": "5-0 Fast Gut", "isChecked": false, "title": false},
    {"name": "DEEP SUTURE", "isChecked": false, "title": true},
    {"name": "None", "isChecked": false, "title": false},
    {
      "name": "3-0 Vicryl (Polyglactin 910)",
      "isChecked": false,
      "title": false
    },
    {
      "name": "4-0 Vicryl (Polyglactin 910)",
      "isChecked": false,
      "title": false
    },
    {
      "name": "5-0 Vicryl (Polyglactin 910)",
      "isChecked": false,
      "title": false
    },
    {
      "name": "3-0 Monocryl (Poliglecaprone 25)",
      "isChecked": false,
      "title": false
    },
    {
      "name": "4-0 Monocryl (Poliglecaprone 25)",
      "isChecked": false,
      "title": false
    },
    {
      "name": "5-0 Monocryl (Poliglecaprone 25)",
      "isChecked": false,
      "title": false
    },
    {"name": "TOOLS", "isChecked": false, "title": true},
    {"name": "Needle Driver", "isChecked": false, "title": false},
    {"name": "Adson Tissue Forceps", "isChecked": false, "title": false},
    {"name": "Bishop-Harmon Forceps", "isChecked": false, "title": false},
    {"name": "Iris Scissors", "isChecked": false, "title": false},
    {
      "name": "Wescott/Castroviejo Scissors",
      "isChecked": false,
      "title": false
    },
    {"name": "Undermining Scissors", "isChecked": false, "title": false},
    {"name": "Hemostat", "isChecked": false, "title": false},
    {"name": "Skin Hooks", "isChecked": false, "title": false},
    {"name": "PATIENT POSITION", "isChecked": false, "title": true},
    {"name": "Supine", "isChecked": false, "title": false},
    {"name": "Prone", "isChecked": false, "title": false},
    {"name": "Trendelenburg", "isChecked": false, "title": false},
    {"name": "Reverse Trendelenburg", "isChecked": false, "title": false},
    {"name": "On left side", "isChecked": false, "title": false},
    {"name": "On right side ", "isChecked": false, "title": false},
    {"name": "TOP STITCHES", "isChecked": false, "title": true},
    {"name": "Simple Interrupted", "isChecked": false, "title": false},
    {"name": "Simple Running", "isChecked": false, "title": false},
    {"name": "Horizontal Mattress", "isChecked": false, "title": false},
    {"name": "Vertical Mattress", "isChecked": false, "title": false},
  ];

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  //string manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
    //getting list of snapshots in stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  nextScreen(context, const SearchPage());
                },
                icon: const Icon(Icons.search, color: Colors.black))
          ],
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Text(
            "My Cases",
            style: TextStyle(color: Colors.black, fontSize: 27),
          ),
          iconTheme: const IconThemeData(
            color: Colors.black,
          )),
      drawer: Drawer(
          child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: <Widget>[
          Icon(Icons.account_circle, size: 150, color: Colors.grey[700]),
          const SizedBox(height: 15),
          Text(
            userName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          const Divider(
            height: 2,
          ),
          ListTile(
            onTap: () {},
            selectedColor: Theme.of(context).primaryColor,
            selected: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.group),
            title: const Text(
              "Cases",
              style: TextStyle(color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () {
              nextScreenReplace(
                  context,
                  ProfilePage(
                    userName: userName,
                    email: email,
                  ));
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(
              Icons.group,
            ),
            title: const Text(
              "Profile",
              style: TextStyle(color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () async {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await authService.signOut();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                                (route) => false);
                          },
                          icon: const Icon(
                            Icons.done,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    );
                  });
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.exit_to_app),
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      )),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: const Text(
                "Create a case",
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor),
                        )
                      : TextField(
                          onChanged: (val) {
                            setState(() {
                              groupName = val;
                            });
                          },
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(25)),
                            errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(25)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(25)),
                          ),
                        ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                  child: const Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (groupName != "") {
                      setState(() {
                        _isLoading = true;
                      });
                      DatabaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(
                        userName,
                        FirebaseAuth.instance.currentUser!.uid,
                        groupName,
                        category,
                      )
                          .whenComplete(() {
                        _isLoading = false;
                      });
                      Navigator.of(context).pop();
                      showSnackBar(
                          context, Colors.green, "Case created successfully.");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                  child: const Text("CREATE"),
                )
              ],
            );
          }));
        });
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        //make checks
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                      height: 1,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 237, 234, 234)),
                      )),
                  itemCount: snapshot.data['groups'].length,
                  itemBuilder: (context, index) {
                    int reverseIndex =
                        snapshot.data['groups'].length - index - 1;
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        // Theme.of(context).primaryColor.withOpacity(0.1),
                        // borderRadius:
                        //     const BorderRadius.all(Radius.circular(0))
                      ),
                      child: GroupTile(
                          groupId: getId(snapshot.data['groups'][reverseIndex]),
                          groupName:
                              getName(snapshot.data['groups'][reverseIndex]),
                          userName: snapshot.data['fullName']),
                    );
                  });
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          );
        }
      },
    );
  }

  noGroupWidget() {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                popUpDialog(context);
              },
              child: Icon(
                Icons.add_circle,
                color: Colors.grey[700],
                size: 75,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "You have not joined any cases, press add button to join",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
