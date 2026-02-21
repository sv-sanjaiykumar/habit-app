//plugins {
//    // Add the dependency for the Google services Gradle plugin
//    id("com.google.gms.google-services") version "4.4.3" apply false
//}
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Firebase / Google services plugin
        classpath("com.google.gms:google-services:4.4.3")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Set custom build directory for root project
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

// Apply custom build directory and evaluation order to subprojects
subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // Ensure subprojects evaluate after ":app"
    evaluationDependsOn(":app")
}

// Register clean task to delete the custom build directory
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
