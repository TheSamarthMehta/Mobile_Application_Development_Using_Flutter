import 'package:flutter/material.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2
                ),
                image: DecorationImage(
                    image: AssetImage('assets/images/ForeverBandhan.png'),
                    fit: BoxFit.cover,
                )
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              "ForeverBandhan",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle("Meet Our Team"),
            _buildInfoCard([
              _buildInfoRow("Developed by", "Samarth Mehta (23010101167)"),
              _buildInfoRow(
                  "Mentored by", "Prof. Mehul Bhundiya (Computer Engineering)"),
              _buildInfoRow("Explored by", "ASWDC, School of Computer Science"),
              _buildInfoRow("Eulogized by",
                  "Darshan University, Rajkot, Gujarat - INDIA"),
            ]),
            const SizedBox(height: 20),
            // About ASWDC
            _buildSectionTitle("About ASWDC"),
            _buildDescriptionCard(
                "ASWDC is an Application, Software, and Website Development Center at Darshan University. "
                "It is run by students and staff of the School of Computer Science. The main goal is to bridge the gap "
                "between university curriculum and industry requirements."),
            const SizedBox(height: 20),

            // Contact Us
            _buildSectionTitle("Contact Us"),
            _buildInfoCard([
              _buildIconRow(Icons.email, "aswdc@darshan.ac.in"),
              _buildIconRow(Icons.phone, "+91-9727473717"),
              _buildIconRow(Icons.language, "www.darshan.ac.in"),
            ]),
            const SizedBox(height: 20),

            // Social & Links
            _buildInfoCard([
              _buildIconRow(Icons.share, "Share App"),
              _buildIconRow(Icons.apps, "More Apps"),
              _buildIconRow(Icons.star, "Rate Us"),
              _buildIconRow(Icons.thumb_up, "Like us on Facebook"),
              _buildIconRow(Icons.update, "Check for Update"),
            ]),

            // Footer
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

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildDescriptionCard(String text) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          text,
          style: const TextStyle(fontSize: 14, height: 1.5),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14, color: Colors.black),
          children: [
            TextSpan(
                text: "$title: ",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Widget _buildIconRow(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon, color: Colors.purple),
      title: Text(text, style: const TextStyle(fontSize: 14)),
      onTap: () {},
    );
  }
}
