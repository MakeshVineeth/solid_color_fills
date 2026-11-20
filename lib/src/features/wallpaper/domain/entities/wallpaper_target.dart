/// Represents the destination target for applying the solid color wallpaper.
enum WallpaperTarget {
  homeScreen(1, 'Home Screen'),
  lockScreen(2, 'Lock Screen'),
  bothScreens(3, 'Both Screens'),
  gallery(4, 'Gallery');

  final int id;
  final String label;

  const WallpaperTarget(this.id, this.label);

  static WallpaperTarget fromId(int id) {
    return WallpaperTarget.values.firstWhere(
      (e) => e.id == id,
      orElse: () => WallpaperTarget.homeScreen,
    );
  }
}
