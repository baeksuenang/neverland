import 'package:flutter/material.dart';

class InviteResponseScreen extends StatelessWidget {
  final String inviterName;

  const InviteResponseScreen({Key? key, required this.inviterName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 120),
            child: Column(
              children: [
                Text(
                  'Neverland',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.cyanAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),
                Icon(
                  Icons.mark_email_unread_rounded,
                  size: 80,
                  color: Colors.cyanAccent,
                ),
                SizedBox(height: 30),
                Text(
                  'someone invite you',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          /// 초대 응답 카드
          Positioned(
            bottom: 80,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    'Invitation',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.cyanAccent,
                    child: Icon(Icons.person, size: 30, color: Colors.black),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '$inviterName invite you.\nDo you want to join?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // 수락 로직
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: StadiumBorder(),
                    ),
                    child: Text('Let\'s go'),
                  ),
                  TextButton(
                    onPressed: () {
                      // 거절 로직
                    },
                    child: Text(
                      'No, thanks',
                      style: TextStyle(color: Colors.white54),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
