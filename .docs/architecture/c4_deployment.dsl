workspace "Solid Color Fills Deployment" "Deployment Architecture Diagram" {

    model {
        androidDevice = deploymentNode "Target Android Device" "Physical phone, foldable, tablet, or Chromebook" "Android 7.0+ (API 24 to 36)" {
            appInstance = containerInstance "Solid Color Fills APK / AAB"
            androidFramework = infrastructureNode "Android 16 Framework" "WindowCompat, DisplayCutout, WallpaperManager"
        }

        playStore = deploymentNode "Google Play Infrastructure" "Production Release Channel" {
            bundleArtifact = infrastructureNode "Signed AAB + Debug Symbols" "Retrace Mapping & Obfuscation Symbols"
        }

        playStore -> androidDevice "Distributes signed APK to devices"
    }

    views {
        deployment * "ProductionDeployment" {
            include *
            autoLayout lr
        }
    }
}
