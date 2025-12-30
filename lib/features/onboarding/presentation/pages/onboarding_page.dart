import 'package:dental_mobile/common/widgets/primary_button.dart';
import 'package:dental_mobile/core/storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      title: 'Klinikanızı asanlıqla idarə edin',
      description:
      'Görüşləri, pasiyentləri və ödənişləri bir platformada rahat şəkildə izləyin.',
      image: 'assets/icons/icon_hero.svg',
    ),
    OnboardingContent(
      title: 'Real vaxt statistikası',
      description:
      'Klinikanızın fəaliyyətini real vaxtda statistik göstəricilərlə analiz edin.',
      image: 'assets/icons/icon_hero.svg',
    ),
    OnboardingContent(
      title: 'Təhlükəsiz və etibarlı',
      description:
      'Məlumatlarınız şifrələnmiş şəkildə qorunur və yalnız sizin üçün əlçatandır.',
      image: 'assets/icons/icon_hero.svg',
    ),
  ];

  void _onNext() async {
    if (_currentPage < _contents.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    final storage = GetIt.I<SecureStorage>();
    await storage.write('hasSeenOnboarding', 'true');
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _completeOnboarding,
                child: const Text('Keç'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _contents.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff212327),
                          ),
                          child: SvgPicture.asset(
                            _contents[index].image,
                            width: 120,
                            height: 120,
                            colorFilter: ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          _contents[index].title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _contents[index].description,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _contents.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: _currentPage == index
                              ? theme.colorScheme.primary
                              : theme.colorScheme.primary.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  PrimaryButton(
                    text: _currentPage == _contents.length - 1 ? 'Başla' : 'Növbəti',
                    onPressed: _onNext,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingContent {
  final String title;
  final String description;
  final String image;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.image,
  });
}
