

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contact_list_app/Modal/contacts.dart';
import 'package:flutter_contact_list_app/storage_helper.dart';
import 'package:permission_handler/permission_handler.dart';

import 'addContactPage.dart';



void main() {
  runApp(MyApp());
}
const iOSLocalizedLabels = false;
class MyApp extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Contact> _contacts;
  List<ContactSaved> fromDatabase = [];

  @override
  void initState() {
    _askPermissions();
  }

  Future<void> _askPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
    refreshContacts();
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      final snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      final snackBar =
      SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> refreshContacts() async {
    // Load without thumbnails initially.
    var contacts = (await ContactsService.getContacts(
        withThumbnails: false, iOSLocalizedLabels: iOSLocalizedLabels))
        .toList();

    setState(() {
      _contacts = contacts;
    });
    List<ContactSaved> savedContact = [];
    // Lazy load thumbnails after rendering initial contacts.
    for (final contact in contacts) {
      if(contact.displayName != null) {
        ContactSaved contactSaved = new ContactSaved(contact.displayName);
        savedContact.add(contactSaved);

      saveContactInPreference(savedContact);}
      ContactsService.getAvatar(contact).then((avatar) async {
        if (avatar == null) return; // Don't redraw if no change.
         // getContactFromDataBase();
        setState(() => contact.avatar = avatar);

      });
getContactFromDataBase();
    }

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: SafeArea(
        child: _contacts != null
            ? ListView.builder(
          itemCount: _contacts?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            Contact c = _contacts?.elementAt(index);
            return Dismissible(

              key: ObjectKey(_contacts[index]),
       onDismissed: (direction){
        deleteContact(index);
             _contacts.removeAt(index);
           setState(() {

                });
},
              child: ListTile(

                leading: (c.avatar != null && c.avatar.length > 0)
                    ? CircleAvatar(backgroundImage: MemoryImage(c.avatar))
                    : CircleAvatar(child: Text(c.initials())),
                title: Text(c.displayName ?? ""),
              ),
            );
          },
        )
            : Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddContactPage())
          ).then((value) => refreshContacts());
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> deleteContact(int index) async {
    await ContactsService.deleteContact(_contacts[index]);

  }

  void saveContactInPreference(List<ContactSaved> contactSaved) {
    StorageHelper.save(StorageHelper.KEY, contactSaved);
  }
 
  Future<void> getContactFromDataBase() async {
    fromDatabase = await StorageHelper.read(StorageHelper.KEY);
    print(fromDatabase.length);
  }




}
