class OnboardingItem {
  final String imagePath;
  final String networkFallback;
  final String title1;
  final String title2;
  final String description;
  final String buttonText;
  final bool isLastPage;

  const OnboardingItem({
    required this.imagePath,
    required this.networkFallback,
    required this.title1,
    required this.title2,
    required this.description,
    required this.buttonText,
    this.isLastPage = false,
  });
}
