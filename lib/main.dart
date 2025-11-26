import 'package:flutter/material.dart';

void main() {
  runApp(const NewsAppUI());
}

// --- 1. THEME AND CONSTANTS ---

class AppColors {
  static const Color primary = Color(0xFF005792); // Deep Blue for News/Action
  static const Color accent = Color(0xFFFF6B6B); // Coral/Red for highlight
  static const Color textDark = Color(0xFF1E272E);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8F9FA); // Light background
  static const Color surface = Color(0xFFFFFFFF); // Card/Button background
  static const Color disabled = Color(0xFFCED4DA);
}

class AppTextStyles {
  static const TextStyle headline = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );
  static const TextStyle subTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Color(0xFF6C757D),
    height: 1.5,
  );
  static const TextStyle buttonText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textLight,
  );
}

// --- 2. MAIN APPLICATION WIDGET ---

class NewsAppUI extends StatelessWidget {
  const NewsAppUI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto', // Default font
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textDark,
          elevation: 0.5,
          centerTitle: false,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: AppColors.accent,
          primary: AppColors.primary,
        ),
      ), // <-- close ThemeData here
      // These belong to MaterialApp, not ThemeData:
      initialRoute: AppRoutes.onboarding,
      routes: {
        AppRoutes.onboarding: (context) => const OnboardingScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
      },
    );
  }
}

// --- 3. ROUTE DEFINITIONS ---

class AppRoutes {
  static const String onboarding = '/';
  static const String login = '/login';
  static const String home = '/home';
}

// --- 4. SHARED COMPONENTS ---

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          shadowColor: AppColors.primary.withOpacity(0.3),
        ),
        child: Text(
          text,
          style: AppTextStyles.buttonText.copyWith(fontSize: 18),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.disabled),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.disabled, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
      ),
    );
  }
}

// --- 5. ONBOARDING SCREENS (1, 2, 3) ---

class OnboardingContent {
  final String title;
  final String description;
  final IconData icon;

  OnboardingContent(this.title, this.description, this.icon);
}

final List<OnboardingContent> onboardingPages = [
  OnboardingContent(
    'Stay Informed, Instantly',
    'Get the latest breaking news and personalized stories delivered right to your fingertips. Never miss a beat.',
    Icons.newspaper_rounded,
  ),
  OnboardingContent(
    'Personalized Feed Just For You',
    'Select your interests and topics to build a customized news feed that focuses on what you care about most.',
    Icons.tune_rounded,
  ),
  OnboardingContent(
    'Offline Reading & Bookmarks',
    'Save articles for later and read them offline. Manage your favorite stories effortlessly across all devices.',
    Icons.bookmark_rounded,
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onNextPressed() {
    if (_currentPage < onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeIn,
      );
    } else {
      // Last page: Navigate to Login
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    }
  }

  void _onSkipPressed() {
    // Skip to Login
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button (Only visible on first two screens)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _currentPage < onboardingPages.length - 1
                    ? TextButton(
                        onPressed: _onSkipPressed,
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),

            // PageView for Onboarding 1, 2, 3
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingPages.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  final page = onboardingPages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Placeholder for Image/Illustration
                        Icon(
                          page.icon,
                          size: 150,
                          color: AppColors.primary.withOpacity(0.8),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          page.title,
                          style: AppTextStyles.headline,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page.description,
                          style: AppTextStyles.subTitle,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Indicator Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingPages.length,
                (index) => buildDot(index, context),
              ),
            ),
            const SizedBox(height: 30),

            // Action Button
            Padding(
              padding: const EdgeInsets.only(
                left: 32.0,
                right: 32.0,
                bottom: 40.0,
              ),
              child: PrimaryButton(
                text: _currentPage == onboardingPages.length - 1
                    ? 'Get Started'
                    : 'Next',
                onPressed: _onNextPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dot Indicator component
  Widget buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 5),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? AppColors.primary : AppColors.disabled,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

// --- 6. LOGIN SCREEN ---

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _onLoginPressed(BuildContext context) {
    // Perform login logic here
    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }

  void _onSignUpPressed(BuildContext context) {
    // Navigate to Sign Up screen (if implemented)
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Navigate to Sign Up Screen')));
  }

  void _onSocialLogin(BuildContext context, String provider) {
    // Handle social login
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Logging in with $provider...')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome Back!'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Log in to your account',
                style: AppTextStyles.headline,
              ),
              const SizedBox(height: 8),
              Text(
                'Stay updated with the latest news.',
                style: AppTextStyles.subTitle,
              ),
              const SizedBox(height: 40),

              // Email Field
              const CustomTextField(
                label: 'Email Address',
                hint: 'you@example.com',
                icon: Icons.email_rounded,
              ),
              const SizedBox(height: 20),

              // Password Field
              const CustomTextField(
                label: 'Password',
                hint: 'Enter your secure password',
                icon: Icons.lock_rounded,
                isPassword: true,
              ),
              const SizedBox(height: 10),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Forgot Password flow triggered'),
                      ),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Login Button
              PrimaryButton(
                text: 'Log In',
                onPressed: () => _onLoginPressed(context),
              ),
              const SizedBox(height: 30),

              // Divider
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.disabled)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'OR',
                      style: AppTextStyles.subTitle.copyWith(fontSize: 14),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.disabled)),
                ],
              ),
              const SizedBox(height: 30),

              // Social Login Buttons
              SocialLoginButton(
                icon: Icons.g_mobiledata_rounded,
                text: 'Continue with Google',
                onPressed: () => _onSocialLogin(context, 'Google'),
              ),
              const SizedBox(height: 15),
              SocialLoginButton(
                icon: Icons.facebook_rounded,
                text: 'Continue with Facebook',
                onPressed: () => _onSocialLogin(context, 'Facebook'),
                color: const Color(0xFF4267B2),
              ),
              const SizedBox(height: 40),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?", style: AppTextStyles.subTitle),
                  TextButton(
                    onPressed: () => _onSignUpPressed(context),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final Color? color;

  const SocialLoginButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.disabled, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.surface,
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color ?? AppColors.textDark),
            const SizedBox(width: 10),
            Text(
              text,
              style: AppTextStyles.subTitle.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 7. HOME SCREEN (5TH SCREEN) ---

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Headlines'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Search triggered')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications triggered')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Tabs
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: CategorySelector(),
            ),

            // Featured News Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Featured Stories',
                style: AppTextStyles.headline.copyWith(fontSize: 22),
              ),
            ),
            const FeaturedNewsCard(),

            // Latest News List
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Latest News',
                style: AppTextStyles.headline.copyWith(fontSize: 22),
              ),
            ),
            ...List.generate(5, (index) => NewsListItem(index: index)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class CategorySelector extends StatefulWidget {
  const CategorySelector({super.key});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  final List<String> categories = [
    'All',
    'Politics',
    'Tech',
    'Sports',
    'Health',
    'Finance',
  ];
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategory = category;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Selected category: $category')),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.disabled,
                  ),
                ),
                child: Center(
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.textLight
                          : AppColors.textDark,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FeaturedNewsCard extends StatelessWidget {
  const FeaturedNewsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [AppColors.primary.withOpacity(0.8), AppColors.primary],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          padding: const EdgeInsets.all(20.0),
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'WORLD',
                style: TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Global markets surge as new economic deal is finalized.',
                style: AppTextStyles.headline.copyWith(
                  color: AppColors.textLight,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '5 min ago • John Doe',
                style: AppTextStyles.subTitle.copyWith(
                  color: AppColors.textLight.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewsListItem extends StatelessWidget {
  final int index;
  const NewsListItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final title =
        "Local Election Results Finalized: Party A takes control ($index)";
    final subtitle =
        "The final tally confirms the shift in local governance, promising new policies for the next term.";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.headline.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.subTitle.copyWith(fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  '1 hour ago • Politics',
                  style: AppTextStyles.subTitle.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Image Placeholder
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.disabled,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                Icons.image_search_rounded,
                color: AppColors.surface.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
