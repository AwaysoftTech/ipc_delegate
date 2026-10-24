import org.jetbrains.kotlin.gradle.tasks.KotlinCompile
import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import com.android.build.gradle.BaseExtension

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.layout.buildDirectory.set(file("../build"))

subprojects {
    project.layout.buildDirectory.set(
            file("${rootProject.layout.buildDirectory.get()}/${project.name}")
    )

    afterEvaluate {
        if (project.hasProperty("android")) {
            extensions.findByType<BaseExtension>()?.apply {

                compileSdkVersion(37)

                compileOptions {
                    sourceCompatibility = JavaVersion.VERSION_17
                    targetCompatibility = JavaVersion.VERSION_17
                }

                if (namespace == null) {
                    namespace = project.group.toString()
                }
            }
        }
    }

    // Kotlin target = Java target
    tasks.withType<KotlinCompile>().configureEach {
        compilerOptions {
            jvmTarget.set(JvmTarget.JVM_17)
        }
    }

    // Java compiler target = 17
    tasks.withType<JavaCompile>().configureEach {
        sourceCompatibility = JavaVersion.VERSION_17.toString()
        targetCompatibility = JavaVersion.VERSION_17.toString()
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}