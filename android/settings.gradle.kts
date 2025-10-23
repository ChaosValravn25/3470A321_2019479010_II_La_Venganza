pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
    plugins {
        id("dev.flutter.flutter-plugin-loader") version "1.0.0" apply false
        id("com.android.application") version "8.1.0" apply false
        id("org.jetbrains.kotlin.android") version "1.9.22" apply false
    }
}

include(":app")

// Configuración de Flutter SDK (opcional, si es necesario)
val localProperties = java.util.Properties().apply {
    load(java.io.FileInputStream(rootProject.file("local.properties")))
}
val flutterSdk = localProperties.getProperty("flutter.sdk")
if (flutterSdk == null) {
    throw GradleException("flutter.sdk not set in local.properties")
}
rootProject.ext["flutterSdkPath"] = flutterSdk

// Incluir el build de Flutter (opcional, dependiendo de tu setup)
includeBuild("${flutterSdk}/packages/flutter_tools/gradle")