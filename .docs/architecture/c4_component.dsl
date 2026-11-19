workspace "Solid Color Fills Components" "Component Level Architecture" {

    model {
        wallpaperController = element "WallpaperController" "Presentation Controller" "Coordinates wallpaper selection and triggers application"
        collectionsController = element "CollectionsController" "Presentation Controller" "Filters curated colors palette and handles search"
        colorPickerController = element "ColorPickerController" "Presentation Controller" "Orchestrates RGB channels, hex input, and HSV wheel"
        feedController = element "FeedController" "Presentation Controller" "Manages infinite random color generation stream"

        wallpaperRepo = element "WallpaperRepository" "Domain Interface" "Abstract contract for setting wallpaper & gallery export"
        wallpaperRepoImpl = element "WallpaperRepositoryImpl" "Data Implementation" "Interacts with Android WallpaperManager & OpenFilex"
        canvasService = element "CanvasImageService" "Data Service" "Draws solid colors onto Canvas and encodes to PNG"
        randomColorGen = element "RandomColorGenerator" "Domain Service" "Pure Dart HSL algorithmic color generator"

        wallpaperController -> wallpaperRepo "Invokes wallpaper application"
        wallpaperRepoImpl -> wallpaperRepo "Implements"
        wallpaperController -> canvasService "Requests PNG buffer"
        feedController -> randomColorGen "Requests batch of colors"
    }

    views {
        component wallpaperController "Components" {
            include *
            autoLayout lr
        }
    }
}
