import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeWebsite extends StatelessWidget {
  const HomeWebsite({super.key});

  void _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'rabbitopiafarm@gmail.com',
      query: 'subject=Inquiry from Website',
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fur.png'),
            fit: BoxFit.cover,
            opacity: 0.6,
          ),
        ),
        child: CustomScrollView(
          slivers: [
            // Professional Navigation Bar
            SliverAppBar(
              floating: true,
              pinned: true,
              backgroundColor: Colors.black.withOpacity(0.8),
              title: const Text('Rabbitopia Farms', 
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              actions: [
                TextButton(onPressed: () {}, child: const Text('Home', style: TextStyle(color: Colors.white))),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/marketplace'), 
                  child: const Text('Marketplace', style: TextStyle(color: Colors.white))
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/auth'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                    child: const Text('Customer App', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),

            // Hero Section
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
                child: Column(
                  children: [
                    Image.asset('assets/images/rabbitopia_icon.png', height: 150),
                    const SizedBox(height: 20),
                    const Text(
                      'Welcome to Rabbitopia Farms',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Text(
                          'We are a small family owned rabbit breeder, specializing in both purebred Mini-Rex rabbits in broken pattern and all black as well as our meat rabbit line of New Zealand and Silver Fox breeds.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Contact Section
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(40),
                color: Colors.blueAccent.withOpacity(0.1),
                child: Column(
                  children: [
                    const Text('Get In Touch', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 20,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => Navigator.pushNamed(context, '/auth'),
                          icon: const Icon(Icons.app_registration),
                          label: const Text('Use the Web App to DM us'),
                          style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
                        ),
                        OutlinedButton.icon(
                          onPressed: _launchEmail,
                          icon: const Icon(Icons.email),
                          label: const Text('Send us an Email'),
                          style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Mission Statement Footer
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
                color: Colors.black87,
                child: Column(
                  children: [
                    const Text('Our Mission', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                    const SizedBox(height: 20),
                    const Text(
                      '“We believe that any animal who\'s life or offspring will be given for the benefit of the farm should have the best life possible. In lieu of this we go to great lengths to ensure each animal we raise is kept in clean well maintained hutches, fed a high quality combination of feed and supliments and are loved on regularly. We ask that anyone who purchases one of our animals and later finds that they cannot keep it for any reason please return the animal to our farm. We do not offer refunds, however we will see to the humane treatment of the animal as it completes it\'s life-cycle”',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white70, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 40),
                    const Text('© 2024 Rabbitopia Farms', style: TextStyle(color: Colors.white24)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
