import 'package:flutter/material.dart';

final title = 'Create a photo filter carousel';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(fontFamily: 'Raleway'),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final _filters = <Color>[
    Colors.white,
    ...List.generate(
      Colors.primaries.length,
      (index) => Colors.primaries[(index * 4) % Colors.primaries.length],
    )
  ];
  final _filterColor = ValueNotifier<Color>(Colors.white);

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: _buildPhotoWithFilter()),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            top: 0.0,
            child: _buildFilterSelector(),
          )
        ],
      ),
    );
  }

  Widget _buildPhotoWithFilter() {
    return ValueListenableBuilder(
      valueListenable: _filterColor,
      builder: (context, value, child) {
        return Image.network(
          'https://flutter.dev/docs/cookbook/img-files/effects/instagram-buttons/millenial-dude.jpg',
          color: (value as Color).withOpacity(0.5),
          colorBlendMode: BlendMode.color,
          fit: BoxFit.cover,
        );
      },
    );
  }

  Widget _buildFilterSelector() {
    return FilterSelector(
      filters: _filters,
      onFilterSelected: _onFilterChanged,
    );
  }

  void _onFilterChanged(Color selectedColor) {
    _filterColor.value = selectedColor;
  }
}

class FilterSelector extends StatefulWidget {
  const FilterSelector({
    Key key,
    this.filters,
    this.padding = const EdgeInsets.symmetric(vertical: 24.0),
    this.onFilterSelected,
  }) : super(key: key);

  final List<Color> filters;
  final EdgeInsets padding;
  final void Function(Color selctedColor) onFilterSelected;

  @override
  State<StatefulWidget> createState() => _FilterSelectorState();
}

class _FilterSelectorState extends State<FilterSelector> {
  static const _filtersPerScreen = 5;
  static const _viewportFractionPerItem = 1.0 / _filtersPerScreen;
  PageController _pageController;

  Color itemColor(int index) => widget.filters[index % widget.filters.length];

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(viewportFraction: _viewportFractionPerItem);
    _pageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final itemSize = constraints.maxWidth * _viewportFractionPerItem;
      return Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          _buildShadowGradient(itemSize),
          _buildCarousel(itemSize),
          _buildSelectionRing(itemSize),
        ],
      );
    });
  }

  Widget _buildShadowGradient(double itemSize) {
    return SizedBox(
      height: itemSize * 2 + widget.padding.vertical,
      child: const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black],
          ),
        ),
        child: SizedBox.expand(),
      ),
    );
  }

  Widget _buildCarousel(double itemSize) {
    return Container(
      height: itemSize,
      margin: widget.padding,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.filters.length,
        itemBuilder: (context, index) {
          return Center(
            child: AnimatedBuilder(
              animation: _pageController,
              builder: (context, child) {
                if (!_pageController.hasClients ||
                    !_pageController.position.hasContentDimensions) {
                  return SizedBox();
                }
                final selectedIndex = _pageController.page.roundToDouble();
                final pageScrollAmount = _pageController.page - selectedIndex;
                final maxScrollDistance = _filtersPerScreen / 2;
                final pageDistanceFromSelected =
                    (selectedIndex - index + pageScrollAmount).abs();
                final percentFromCenter =
                    1.0 - pageDistanceFromSelected / maxScrollDistance;
                final double itemScale = 0.5 + (percentFromCenter * 0.5);
                final double opacity = 0.25 + (percentFromCenter * 0.75);
                return Transform.scale(
                  scale: itemScale,
                  child: Opacity(
                    opacity: opacity,
                    child: FilterItem(
                      color: itemColor(index),
                      onFilterSelected: () => _onFilterTapped(index),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectionRing(double itemSize) {
    return IgnorePointer(
        child: Padding(
      padding: widget.padding,
      child: SizedBox(
        width: itemSize,
        height: itemSize,
        child: const DecoratedBox(
            decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.fromBorderSide(
              BorderSide(width: 6.0, color: Colors.white)),
        )),
      ),
    ));
  }

  void _onPageChanged() {
    final page = (_pageController.page ?? 0.0).round();
    widget.onFilterSelected(widget.filters[page]);
  }

  void _onFilterTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 450),
      curve: Curves.ease,
    );
  }
}

class FilterItem extends StatelessWidget {
  const FilterItem({Key key, this.color, this.onFilterSelected})
      : super(key: key);

  final Color color;
  final VoidCallback onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFilterSelected,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Image.network(
              'https://flutter.dev/docs/cookbook/img-files/effects/instagram-buttons/millenial-texture.jpg',
              color: color.withOpacity(0.5),
              colorBlendMode: BlendMode.hardLight,
            ),
          ),
        ),
      ),
    );
  }
}
