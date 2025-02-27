import 'package:flutter/material.dart';
import '../HomeScreen/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 1,
        title: Text(
          "About Us",
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.07,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(screenWidth * 0.1),
            bottomLeft: Radius.circular(screenWidth * 0.1),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/ForeverBandhan.png',
              width: 80,
              height: 80,
            ),
            const SizedBox(height: 10),
            const Text(
              "Shaadi Sphere App",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.purpleAccent),
            ),
            const SizedBox(height: 20),
            _buildSectionCard("Meet Our Team", [
              _buildInfoRow("Developed by", "Niyati Sapariya (23010101242)"),
              _buildInfoRow("Mentored by",
                  "Prof. Mehul Bhundiya, School of Computer Science"),
              _buildInfoRow("Explored by", "ASWDC, School Of Computer Science"),
              _buildInfoRow("Eulogized by", "Darshan University, India"),
            ]),
            _buildSectionCard("About ASWDC", [
              _buildDescription(
                  "ASWDC is an Application, Software, and Website Development Center at Darshan University. It aims to bridge the gap between university curriculum and industry."),
            ]),
            _buildSectionCard("Contact Us", [
              _buildIconRow(Icons.email, "aswdc@darshan.ac.in",
                  "mailto:aswdc@darshan.ac.in"),
              _buildIconRow(Icons.phone, "+91-9727473717", "tel:+919727473717"),
              _buildIconRow(Icons.language, "www.darshan.ac.in",
                  "https://www.darshan.ac.in"),
            ]),
            _buildSectionCard("Social & Links", [
              _buildIconRow(Icons.share, "Share App", ""),
              _buildIconRow(Icons.apps, "More Apps", ""),
              _buildIconRow(Icons.star, "Rate Us", ""),
              _buildIconRow(Icons.thumb_up, "Like us on Facebook", ""),
              _buildIconRow(Icons.update, "Check for Update", ""),
            ]),
            const SizedBox(height: 20),
            const Text(
              "© 2025 Darshan University\nAll Rights Reserved - Privacy Policy\nMade with ❤ in India",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purpleAccent),
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14, color: Colors.black),
          children: [
            TextSpan(
                text: "$label: ",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
    );
  }

  Widget _buildIconRow(IconData icon, String text, String url) {
    return ListTile(
      leading: Icon(icon, color: Colors.purpleAccent),
      title: Text(text, style: const TextStyle(fontSize: 14)),
      onTap: () async {
        if (url.isNotEmpty) {
          Uri uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {
            debugPrint("Could not launch $url");
          }
        }
      },
    );
  }
}
