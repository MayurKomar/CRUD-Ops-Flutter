import 'package:crud_operations/contact.dart';
import 'package:crud_operations/database_helper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Contact> contacts = [];
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String number = '';
  Contact _contact = Contact();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshContactList();
  }

  void refreshContactList() async {
    List<Contact> x = await _dbHelper.fetchContacts();
    setState(() {
      contacts = x;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "CRUD Operations",
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 15),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            validator: (value) => (value!.isEmpty ? "Please enter username" : null),
                            onSaved: (val) {
                              setState(() {
                                _contact.name = val!;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: "Username",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _numberController,
                            validator: (value) => (value!.isEmpty || value.length != 10? "Please enter correct number" : null),
                            onSaved: (val) {
                              setState(() {
                                _contact.number = val!;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: "Mobile Number",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                              onPressed: () async {
                                var form = _formKey.currentState;
                                if (form!.validate()) {
                                  form.save();
                                  if (_contact.id == null) {
                                    await _dbHelper.insertContact(_contact);
                                  } else {
                                    await _dbHelper.updateContact(_contact);
                                  }
                                  refreshContactList();
                                  setState(() {
                                    form.reset();
                                    _nameController.clear();
                                    _numberController.clear();
                                    _contact.id = null;
                                  });
                                }
                              },
                              child: const Text("Submit"))
                        ],
                      ),
                    )),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: ((context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _contact = contacts[index];
                        _nameController.text = _contact.name!;
                        _numberController.text = _contact.number!;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Row(children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: CircleAvatar(
                              child: Image.asset('assets/images/user.png'),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(contacts[index].name!),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(contacts[index].number!),
                                )
                              ],
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                _dbHelper.deleteContact(contacts[index].id!);
                                refreshContactList();
                              },
                              icon: const Icon(
                                Icons.delete_forever_rounded,
                                color: Colors.red,
                              )),
                          const SizedBox(
                            width: 16,
                          )
                        ]),
                      ),
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
