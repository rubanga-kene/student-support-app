import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myapp/messaging/chat/chat_service.dart';
import 'package:myapp/messaging/chat_page.dart';


class SendWorkRequestPage extends StatefulWidget {
  final Map<String, dynamic> professionalData;

  const SendWorkRequestPage({super.key, required this.professionalData});

  @override
  _SendWorkRequestPageState createState() => _SendWorkRequestPageState();
}

class _SendWorkRequestPageState extends State<SendWorkRequestPage> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  // final TextEditingController reasonController = TextEditingController();
  List<Map<String, dynamic>> requestList = [];


  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    // Initialize the local notification plugin
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    // final IOSInitializationSettings initializationSettingsIOS =
    //     IOSInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, );  //iOS: initializationSettingsIOS

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Message',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              fontSize: 23,
            )
        ),
        backgroundColor: const Color(0xff755dc1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Describe the issue:',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  )
              ),
              TextField(controller: descriptionController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Enter a description of the issue',
                ),
                textInputAction: TextInputAction.newline,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
      
              ),
              const SizedBox(height: 16),
              const Text('Reason:',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),),
              TextField(controller: budgetController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  // prefixText: '',
                  hintText: 'Enter your reason',
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                )
      
      
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Step 3: Send the work request
                   sendWorkRequest();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xff755dc1),
                  backgroundColor: Colors.deepPurple[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
      
                ),
                child: const Text('Send Question',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    )
              ),
              )],
          ),
        ),
      ),
    );
  }

void sendWorkRequest() async {
  final String description = descriptionController.text.trim();
  // final double budget = double.tryParse(budgetController.text.trim()) ?? 0;
  final String budget = budgetController.text.trim();

  if (description.isNotEmpty && budget != '') {
    // Notify the professional about the work request
    await notifyProfessional(description, budget);

    // Navigate to the ChatPage
    if(!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          receiverUserEmail: widget.professionalData['email'],
          receiverUserId: widget.professionalData['uid'],
        ),
      ),
    );

    // Optionally, you can show a success message or handle success
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message sent successfully!'),
        dismissDirection: DismissDirection.up,
        backgroundColor: Colors.green,
      ),
    );
  } else {
    // Show an error message to the user if the input is invalid
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please provide a valid description and reason.'),
        backgroundColor: Colors.red,
        dismissDirection: DismissDirection.up,
      ),
    );
  }
}

Future<void> notifyProfessional(String description, String budget) async {
  // Send the description and budget as a chat message
  final ChatService chatService = ChatService();
  await chatService.sendmessage(
    widget.professionalData['uid'],
    'Description - $description, Reason $budget',
  );
}

}
