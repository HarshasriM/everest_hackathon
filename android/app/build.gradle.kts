plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.everest_hackathon"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.everest_hackathon"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // Add support for dart-define variables with fallback to .env
        val dartDefines = project.property("dart-defines")?.toString()?.split(",") ?: emptyList()
        val dartDefineMap = dartDefines.associate { define ->
            val parts = define.split("=")
            parts[0] to (if (parts.size > 1) parts[1] else "")
        }
        
        // Try to get from dart-define first, then fallback to reading .env file
        var googleMapsApiKey = dartDefineMap["GOOGLE_MAPS_API_KEY"] ?: ""
        
        if (googleMapsApiKey.isEmpty()) {
            // Read from .env file as fallback
            val envFile = file("../../.env")
            if (envFile.exists()) {
                envFile.readLines().forEach { line ->
                    if (line.startsWith("GOOGLE_MAPS_API_KEY=")) {
                        googleMapsApiKey = line.substringAfter("=").trim()
                    }
                }
            }
        }
        
        manifestPlaceholders["googleMapsApiKey"] = googleMapsApiKey
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
