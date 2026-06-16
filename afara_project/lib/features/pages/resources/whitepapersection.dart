import 'dart:async';
import 'package:flutter/material.dart';
import 'package:afara_project/core/theme/app_theme.dart';

// Define the ResourceItem class as it was missing.
// This class represents the data structure for each item in the carousel.
class ResourceItem {
  final String title;
  final String imageUrl;
  final int docCount;
  final String readCount;
  final bool isTrending;

  const ResourceItem({
    required this.title,
    required this.imageUrl,
    required this.docCount,
    required this.readCount,
    this.isTrending = false, // Default to false if not provided
  });
}

class WhitepaperSection extends StatefulWidget {
  const WhitepaperSection({super.key});

  @override
  State<WhitepaperSection> createState() => _WhitepaperSectionState();
}

class _WhitepaperSectionState extends State<WhitepaperSection> {
  // 1. Controller and Timer setup
  late final PageController _pageController;
  Timer? _timer;
  // Use a large initial page to simulate infinite scrolling, allowing movement in both directions
  final int _initialPage = 10000;
  int _currentPage = 10000; // Track the current page in the "infinite" range

  // Mock data (same as before)
  final List<ResourceItem> _items = <ResourceItem>[
    ResourceItem(
      title: 'Our Whitepapers',
      imageUrl: 'lib/assets/images/white_paper1.png',
      docCount: 12,
      readCount: '1055',
      isTrending: true,
    ),
    ResourceItem(
      title: 'Webinars',
      imageUrl: 'lib/assets/images/webinar.png',
      docCount: 21,
      readCount: '980',
    ),
    ResourceItem(
      title: 'Case Studies',
      imageUrl: 'lib/assets/images/white_paper3.png',
      docCount: 8,
      readCount: '450',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // viewportFraction < 1.0 allows seeing the edges of next/previous cards
    _pageController = PageController(
      initialPage: _initialPage,
      viewportFraction: 0.85,
    );

    // 2. Start the auto-scroll heartbeat
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_items.isEmpty) {
        return; // Prevent errors if _items is empty
      }

      // Increment _currentPage without looping back, as we are in an effectively infinite range
      _currentPage++;

      // Only attempt to animate if the controller is attached to a PageView
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    // CRITICAL: Always cancel timers and dispose controllers to prevent memory leaks
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return const SizedBox.shrink(); // Display nothing if there are no items
    }

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 1.0, // Responsive height
      padding: AppTheme.responsivePadding(context),
      decoration: ShapeDecoration(
        color: const Color.fromARGB(255, 253, 253, 253),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMD),
        ),
      ),
      child: PageView.builder(
        controller: _pageController,
        itemCount: _items.length * 20000,
        itemBuilder: (BuildContext context, int index) {
          final int itemIndex = index % _items.length;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMD),
            child: ResourceCard(item: _items[itemIndex]),
          );
        },
      ),
    );
  }
}

// Define the ResourceCard widget, which was also missing but used in the code.
class ResourceCard extends StatelessWidget {
  final ResourceItem item;

  const ResourceCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSM),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Image.asset(
              item.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder:
                  (
                    BuildContext context,
                    Object error,
                    StackTrace? stackTrace,
                  ) => Container(
                    color: Colors.white,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppTheme.spacingXS),
                  Text(
                    '${item.docCount} documents',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${item.readCount} reads',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (item.isTrending)
                    Padding(
                      padding: const EdgeInsets.only(top: AppTheme.spacingXS),
                      child: Row(
                        children: const <Widget>[
                          Icon(
                            Icons.trending_up,
                            color: Colors.orange,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Trending',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
