import 'package:flutter/material.dart';

class LandingPageScreen extends StatefulWidget {
  const LandingPageScreen({super.key});

  @override
  State<LandingPageScreen> createState() => _LandingPageScreenState();
}

class _LandingPageScreenState extends State<LandingPageScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'nconnect',
          style: TextStyle(
            color: Color(0xFF0B5FCC),
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: false,
        actions: isMobile
            ? null
            : [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'About',
                    style: TextStyle(
                      color: Color(0xFF4B5563),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'How It Works',
                    style: TextStyle(
                      color: Color(0xFF4B5563),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Testimonials',
                    style: TextStyle(
                      color: Color(0xFF4B5563),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Help',
                    style: TextStyle(
                      color: Color(0xFF4B5563),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B5FCC),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Get Started'),
                ),
                const SizedBox(width: 20),
              ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Hero Section
            _buildHeroSection(context, isMobile),
            
            // Stats Section
            _buildStatsSection(context, isMobile),
            
            // About Section
            _buildAboutSection(context, isMobile),
            
            // How It Works Section
            _buildHowItWorksSection(context, isMobile),
            
            // Real Testimonials Section
            _buildTestimonialsSection(context, isMobile),
            
            // Partners Section
            _buildPartnersSection(context, isMobile),
            
            // FAQ Section
            _buildFAQSection(context, isMobile),
            
            // CTA Section
            _buildCTASection(context, isMobile),
            
            // Footer
            _buildFooter(context, isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0B5FCC).withOpacity(0.05),
            const Color(0xFF0B5FCC).withOpacity(0.02),
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 60,
          vertical: isMobile ? 60 : 120,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF0B5FCC).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF0B5FCC).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Text(
                '✨ Trusted by 10,000+ users',
                style: TextStyle(
                  color: Color(0xFF0B5FCC),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Main Headline
            Text(
              'Find & Book Local Services\nYour Way',
              style: TextStyle(
                fontSize: isMobile ? 36 : 56,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A202C),
                height: 1.2,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 24),
            // Subheadline
            Text(
              'Connect with verified professionals in your area. Book plumbing, cleaning, repairs, and more in seconds. Real people. Real results. Zero hassle.',
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                color: const Color(0xFF4B5563),
                height: 1.6,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 40),
            // CTA Buttons
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B5FCC),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Get Started Free',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFF0B5FCC),
                      width: 2,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 36,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Watch Demo',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF0B5FCC),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            // Trust Indicators
            Wrap(
              spacing: 32,
              runSpacing: 16,
              children: [
                _buildTrustIndicator('100%', 'Secure Payments'),
                _buildTrustIndicator('24/7', 'Support'),
                _buildTrustIndicator('500+', 'Professionals'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustIndicator(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0B5FCC),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF4B5563),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: isMobile ? 40 : 60,
      ),
      color: Colors.white,
      child: GridView.count(
        crossAxisCount: isMobile ? 3 : 4,
        crossAxisSpacing: isMobile ? 12 : 30,
        mainAxisSpacing: isMobile ? 20 : 30,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildStatCard('10,000+', 'Active Users'),
          _buildStatCard('500+', 'Verified Pros'),
          _buildStatCard('15K+', 'Services Booked'),
          _buildStatCard('4.8★', 'Avg Rating'),
        ],
      ),
    );
  }

  Widget _buildStatCard(String stat, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          stat,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0B5FCC),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF4B5563),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context, bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: isMobile ? 60 : 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B5FCC).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'WHY NCONNECT',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0B5FCC),
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Why Customers Choose Us',
                  style: TextStyle(
                    fontSize: isMobile ? 28 : 40,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A202C),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
          GridView.count(
            crossAxisCount: isMobile ? 1 : 3,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildAboutCard(
                icon: Icons.verified_user,
                title: 'Verified Professionals',
                description:
                    'Every professional is background checked and verified. Read real reviews from verified customers.',
                color: const Color(0xFF0B5FCC),
              ),
              _buildAboutCard(
                icon: Icons.calendar_today,
                title: 'Easy & Fast Booking',
                description:
                    'Book in 60 seconds. Schedule at your convenience. Get instant confirmation and reminders.',
                color: const Color(0xFF00B074),
              ),
              _buildAboutCard(
                icon: Icons.shield,
                title: 'Safe & Secure',
                description:
                    'Encrypted payments. Secure data. Transparent pricing. No hidden charges ever.',
                color: const Color(0xFFFFA500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A202C),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4B5563),
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorksSection(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFAFBFC),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: isMobile ? 60 : 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Section Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF0B5FCC).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'SIMPLE 4-STEP PROCESS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0B5FCC),
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'How It Works',
            style: TextStyle(
              fontSize: isMobile ? 28 : 40,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A202C),
            ),
          ),
          const SizedBox(height: 60),
          GridView.count(
            crossAxisCount: isMobile ? 1 : 4,
            crossAxisSpacing: 20,
            mainAxisSpacing: 40,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStepCard(
                number: '1',
                title: 'Search Services',
                description: 'Find the service you need',
              ),
              _buildStepCard(
                number: '2',
                title: 'Pick a Professional',
                description: 'Check ratings & availability',
              ),
              _buildStepCard(
                number: '3',
                title: 'Book Instantly',
                description: 'Confirm your appointment',
              ),
              _buildStepCard(
                number: '4',
                title: 'Leave a Review',
                description: 'Share your experience',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard({
    required String number,
    required String title,
    required String description,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFF0B5FCC),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0B5FCC).withOpacity(0.2),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A202C),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF4B5563),
            height: 1.5,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildTestimonialsSection(BuildContext context, bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: isMobile ? 60 : 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Section Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF0B5FCC).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'REAL TESTIMONIALS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0B5FCC),
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loved by Users & Professionals',
            style: TextStyle(
              fontSize: isMobile ? 28 : 40,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A202C),
            ),
          ),
          const SizedBox(height: 60),
          GridView.count(
            crossAxisCount: isMobile ? 1 : 3,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildTestimonialCard(
                name: 'Sarah Johnson',
                role: 'Homeowner',
                text:
                    'Found a plumber in 5 minutes! The booking was seamless and the service was excellent. Will definitely use nconnect again.',
                rating: 5,
              ),
              _buildTestimonialCard(
                name: 'Mike Chen',
                role: 'Electrician',
                text:
                    'As a professional, this platform has transformed my business. Quality leads, reliable customers, easy payments. Highly recommended!',
                rating: 5,
              ),
              _buildTestimonialCard(
                name: 'Emma Davis',
                role: 'Customer',
                text:
                    'The security features gave me peace of mind. Knew exactly who was coming, real-time updates, and transparent pricing. Perfect!',
                rating: 5,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard({
    required String name,
    required String role,
    required String text,
    required int rating,
  }) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stars
          Wrap(
            spacing: 4,
            children: List.generate(
              rating,
              (index) => const Icon(
                Icons.star,
                color: Color(0xFFFDB022),
                size: 18,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Testimonial Text
          Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF4B5563),
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          // Profile
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF0B5FCC).withOpacity(0.1),
                child: Text(
                  name[0],
                  style: const TextStyle(
                    color: Color(0xFF0B5FCC),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A202C),
                    ),
                  ),
                  Text(
                    role,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF4B5563),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPartnersSection(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: isMobile ? 60 : 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Trusted by Companies Worldwide',
            style: TextStyle(
              fontSize: isMobile ? 24 : 32,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A202C),
            ),
          ),
          const SizedBox(height: 50),
          GridView.count(
            crossAxisCount: isMobile ? 2 : 4,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildPartnerLogo('Stripe', Icons.payment),
              _buildPartnerLogo('Twilio', Icons.message),
              _buildPartnerLogo('Google Cloud', Icons.cloud),
              _buildPartnerLogo('Firebase', Icons.analytics),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPartnerLogo(String name, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
            color: const Color(0xFF0B5FCC),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A202C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection(BuildContext context, bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: isMobile ? 60 : 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B5FCC).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'HELP CENTER',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0B5FCC),
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Frequently Asked Questions',
                  style: TextStyle(
                    fontSize: isMobile ? 28 : 40,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A202C),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
          GridView.count(
            crossAxisCount: isMobile ? 1 : 2,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildFAQCard(
                question: 'How do I get started?',
                answer:
                    'Sign up in seconds, choose your role (customer or professional), complete your profile, and start booking or accepting jobs.',
              ),
              _buildFAQCard(
                question: 'Is my payment information safe?',
                answer:
                    'Absolutely! We use end-to-end encryption and comply with PCI DSS standards. All payment data is securely processed.',
              ),
              _buildFAQCard(
                question: 'How are professionals verified?',
                answer:
                    'All professionals undergo identity verification, background checks, and skill validation before going live on the platform.',
              ),
              _buildFAQCard(
                question: 'Can I cancel a booking?',
                answer:
                    'Yes! Cancel up to 24 hours before your appointment for a full refund. Refunds process within 3-5 business days.',
              ),
              _buildFAQCard(
                question: 'What support is available?',
                answer:
                    'We offer 24/7 email support and a comprehensive help center. Response time is typically under 2 hours.',
              ),
              _buildFAQCard(
                question: 'How much does it cost?',
                answer:
                    'The platform is free for customers. Professionals pay a small commission only on completed bookings.',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFAQCard({
    required String question,
    required String answer,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A202C),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            answer,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4B5563),
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCTASection(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0B5FCC),
            const Color(0xFF0B5FCC).withOpacity(0.85),
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: isMobile ? 60 : 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Ready to Find Your Next Service Pro?',
            style: TextStyle(
              fontSize: isMobile ? 28 : 40,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            'Join thousands of happy customers who found the perfect professional for their needs',
            style: TextStyle(
              fontSize: isMobile ? 15 : 18,
              color: Colors.white.withOpacity(0.9),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0B5FCC),
              padding: const EdgeInsets.symmetric(
                horizontal: 48,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Create Your Free Account',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1A202C),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: isMobile ? 60 : 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Footer Grid
          GridView.count(
            crossAxisCount: isMobile ? 2 : 4,
            crossAxisSpacing: isMobile ? 20 : 40,
            mainAxisSpacing: isMobile ? 30 : 40,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildFooterColumn(
                title: 'Product',
                items: const ['Features', 'Pricing', 'Security', 'Mobile App'],
              ),
              _buildFooterColumn(
                title: 'Company',
                items: const ['About Us', 'Blog', 'Careers', 'Press'],
              ),
              _buildFooterColumn(
                title: 'Resources',
                items: const ['Help Center', 'Contact', 'Terms', 'Privacy'],
              ),
              _buildFooterColumn(
                title: 'Follow',
                items: const ['Facebook', 'Twitter', 'Instagram', 'LinkedIn'],
              ),
            ],
          ),
          const SizedBox(height: 60),
          // Divider
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.1),
          ),
          const SizedBox(height: 30),
          // Copyright & Links
          Wrap(
            spacing: 24,
            runSpacing: 12,
            children: [
              Text(
                '© ${DateTime.now().year} nconnect. All rights reserved.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (!isMobile) ...[
                Text(
                  '•',
                  style: TextStyle(color: Colors.white.withOpacity(0.3)),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Privacy Policy',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Text(
                  '•',
                  style: TextStyle(color: Colors.white.withOpacity(0.3)),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Terms of Service',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterColumn({
    required String title,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 16),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              item,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
