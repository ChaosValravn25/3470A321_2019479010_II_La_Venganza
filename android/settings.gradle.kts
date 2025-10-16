pluginManagement {
    def flutterSdkPath = {
        def properties = new Properties()
        file("local.properties").withInputStream { properties.load(it) }
        def flutterSdk = properties.getProperty("flutter.sdk")
        assert flutterSdk != null, "flutter.sdk not set in local.properties"
        return flutterSdk
    }()
    settings.ext.flutterSdkPath = flutterSdkPath

    includeBuild("${flutterSdkPath}/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id "dev.flutter.flutter-plugin-loader" version "1.0.2"
    id "com.android.application" version "8.1.0" apply false
    id "org.jetbrains.kotlin.android" version "1.9.22" apply false
}

include ':app'