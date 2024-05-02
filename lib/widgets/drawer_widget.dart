import 'dart:io';

import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Colors.black12,
                        Colors.grey,
                      ]
                  )
              ),
              child: CircleAvatar(
                backgroundImage: AssetImage("images/elon.jpg"),
                radius: 50,
              ))

          , ListTile(
            title: Text("Notes", style: TextStyle(fontSize: 20),),
            leading: Icon(Icons.book, color: Colors.black,),
            trailing: Icon(Icons.arrow_right, color: Colors.grey,),
            onTap: (){
              Navigator.pushNamed(context, "/home");
            },
          )
          ,
          Divider(height: 5, color: Colors.black,),
          ListTile(
            title: Text("Urgent", style: TextStyle(fontSize: 20),),
            leading: Icon(Icons.notification_important, color: Colors.redAccent,),
            trailing: Icon(Icons.arrow_right, color: Colors.grey,),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.pushNamed(context, "/Urgent");
            },
          )

          ,
          Divider(height: 5, color: Colors.black,),
          ListTile(
            title: Text("Important", style: TextStyle(fontSize: 20),),
            leading: Icon(Icons.notification_important, color: Colors.greenAccent,),
            trailing: Icon(Icons.arrow_right, color: Colors.grey,),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.pushNamed(context, "/Important");
            },
          )
          ,
          Divider(height: 5, color: Colors.black,),
          ListTile(
            title: Text("Casual", style: TextStyle(fontSize: 20),),
            leading: Icon(Icons.notification_important, color: Colors.lightBlueAccent,),
            trailing: Icon(Icons.arrow_right, color: Colors.grey,),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.pushNamed(context, "/Casual");
            },
          )
          ,
          Divider(height: 5, color: Colors.black,),
          ListTile(
            title: Text("Quit", style: TextStyle(fontSize: 20),),
            leading: Icon(Icons.close, color: Colors.black,),
            onTap: (){
              exit(0);
            },
          ),
          Divider(height: 5, color: Colors.black,),
        ],
      ),
    );
  }
}