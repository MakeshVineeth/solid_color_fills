workspace "Solid Color Fills" "Context Architecture Diagram" {

    model {
        user = person "Mobile User" "Uses Solid Color Fills to create and apply solid wallpapers."

        solidColorFills = softwareSystem "Solid Color Fills" "Provides solid color wallpaper creation, curation, custom RGB picking, and instant application." {
            tags "App"
        }

        androidOS = softwareSystem "Android OS Services" "Android WallpaperManager, System UI, and MediaStore." {
            tags "External"
        }

        playStore = softwareSystem "Google Play Services" "In-App Review and application distribution." {
            tags "External"
        }

        user -> solidColorFills "Selects, generates, and customizes solid color wallpapers"
        solidColorFills -> androidOS "Sets Home/Lock wallpaper & opens images via Platform Channels"
        solidColorFills -> playStore "Requests ratings and updates via Play In-App Review"
    }

    views {
        systemContext solidColorFills "SystemContext" {
            include *
            autoLayout lr
        }

        styles {
            element "App" {
                background #0288D1
                color #ffffff
            }
            element "External" {
                background #78909C
                color #ffffff
            }
        }
    }
}
