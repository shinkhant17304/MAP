import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: Text('My Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://www.iconarchive.com/download/i144764/gartoon-team/gartoon-apps/amarok-wolf.128.png',
                ),
                radius: 60,
                backgroundColor: Colors.blue,
              ),
            ),
            Divider(color: Colors.grey, height: 40,),
            Text('Name', style: TextStyle(color: Colors.grey),),
            Text('John Doe', style: TextStyle(color: Colors.amber, fontSize: 22),),
            SizedBox(height: 12,),
            Text('Age', style: TextStyle(color: Colors.grey),),
            Text('22', style: TextStyle(color: Colors.amber, fontSize: 22),),
            SizedBox(height: 16,),
            Row(children: [
              Icon(Icons.email, color: Colors.grey,),
              SizedBox(width: 8,),
              Text('johndoe@email.com', style: TextStyle(color: Colors.grey),),
            ],)
          ],
        ),
      ),
    );
  }
}
