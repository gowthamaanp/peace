import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
val hasKeystoreProperties = keystorePropertiesFile.exists()
if (hasKeystoreProperties) {
    keystorePropertiesFile.inputStream().use {
        keystoreProperties.load(it)
    }
}

android {
    namespace = "com.gowthamaan.peace"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.gowthamaan.peace"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    signingConfigs {
       create("release")  {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            val storeFilePath = keystoreProperties.getProperty("storeFile")
            storeFile = if (storeFilePath != null) file(storeFilePath) else null
            storePassword = keystoreProperties.getProperty("storePassword")
       }
   }

    buildTypes {
        release {
            // Falls back to debug signing when key.properties is absent so local `flutter run
            // --release` still works; assembleRelease/bundleRelease are hard-gated below.
            signingConfig = if (hasKeystoreProperties) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

tasks.matching { it.name == "assembleRelease" || it.name == "bundleRelease" }.configureEach {
    doFirst {
        if (!hasKeystoreProperties) {
            throw GradleException(
                "key.properties not found at project root. A real release build must not be " +
                "signed with the debug key; create android/key.properties before running " +
                "assembleRelease/bundleRelease."
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
  implementation(platform("com.google.firebase:firebase-bom:34.3.0"))
  implementation("com.google.firebase:firebase-analytics")
}
