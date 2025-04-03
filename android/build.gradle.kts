buildscript {
    val kotlinVersion = "1.9.0" // Use the latest stable Kotlin version

    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:8.1.0") // Updated Gradle plugin
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Ensure Gradle 8.10.2 is used
tasks.withType<Wrapper> {
    gradleVersion = "8.10.2"
    distributionType = Wrapper.DistributionType.ALL
}

// Define a new build directory
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
}

// Ensure app module is evaluated first
subprojects {
    evaluationDependsOn(":app")
}

// Clean task to delete the build directory
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
