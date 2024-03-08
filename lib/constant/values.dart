
const double appBarHeight = 44;
const double bottomToolbarHeight = 64;

enum CustomRadius {
  tiny(4),
  small(8),
  medium(16),
  corner(20),
  circle(100);

  final double radius;
  const CustomRadius(this.radius);
}

enum IconSize {
  tiny(12),
  small(18),
  medium(24),
  large(32);

  final double size;
  const IconSize(this.size);
}

enum CustomFont {
  small(14),
  caption(16),
  body(20),
  title(32);

  final double size;
  const CustomFont(this.size);
}

enum Spacing {
  tiny(8),
  small(12),
  medium(20),
  large(24),
  huge(32);

  final double size;
  const Spacing(this.size);
}