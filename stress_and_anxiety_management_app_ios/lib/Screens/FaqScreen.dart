import 'package:flutter/material.dart';
import '../Components/FaqCard.dart'; // Adjust path if needed

class FaqScreen extends StatelessWidget {
  const FaqScreen({Key? key}) : super(key: key);

  List<FaqItem> get faqList => [
    FaqItem("What is HowRU?",
        "HowRU is a mental wellness and stress management application designed to help users track emotional patterns and practice mindfulness."),
    FaqItem("How does HowRU work?",
        "You can log emotions, track stress levels, and access personalized coping strategies like breathing exercises and journaling prompts."),
    FaqItem("Does HowRU replace therapy?",
        "No. HowRU is not a substitute for professional mental health care."),
    FaqItem("Is my data secure?",
        "Yes. All personal information is stored securely and encrypted."),
    FaqItem("Who can use HowRU?",
        "Designed for ages 18+, minors should have supervision."),
    FaqItem("Can I delete my data?",
        "Yes, permanently delete your account/data in Settings."),
    FaqItem("Does HowRU share my info?",
        "No. Your data is not sold or shared with advertisers."),
    FaqItem("What if I’m in crisis?",
        "Please contact local emergency services or a crisis hotline."),
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF2E3A40),
      appBar: AppBar(
        title: const Text("FAQ"),
        backgroundColor: const Color(0xFF5D727C),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqList.length,
        itemBuilder: (context, index) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: screenWidth),
            child: FaqCard(faqItem: faqList[index]),
          );
        },
      ),
    );
  }
}
