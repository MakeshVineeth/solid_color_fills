workspace "Solid Color Fills Containers" "Container Architecture Diagram" {

    model {
        user = person "Mobile User"

        enterpriseApp = softwareSystem "Solid Color Fills" {
            flutterUI = container "Flutter Presentation Layer" "Material 3 Widgets, Navigation, & Theming" "Dart / Flutter"
            stateControllers = container "Reactive State Layer" "Provider / ChangeNotifier state orchestration" "Dart"
            canvasService = container "Canvas Image Engine" "PictureRecorder & Canvas PNG encoder" "Dart:ui"
            platformChannels = container "Platform Channel Adapter" "WallpaperManager & DisplayMode bridges" "Kotlin / Android"
            storageContainer = container "Preferences Storage" "Persistent tab & first launch flags" "SharedPreferences"
        }

        androidSystem = softwareSystem "Android System" "WallpaperManager & MediaStore"

        user -> flutterUI "Interacts with screens"
        flutterUI -> stateControllers "Dispatches actions & observes state"
        stateControllers -> canvasService "Requests PNG buffer generation"
        stateControllers -> storageContainer "Reads/writes flags and tab indices"
        stateControllers -> platformChannels "Invokes wallpaper application"
        platformChannels -> androidSystem "Sets lock/home wallpaper via Android API"
    }

    views {
        container enterpriseApp "Containers" {
            include *
            autoLayout tb
        }
    }
}
