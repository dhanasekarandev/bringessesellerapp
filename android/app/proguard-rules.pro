# Flutter core
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.embedding.android.** { *; }
-keep class io.flutter.embedding.engine.** { *; }

# Keep native method names
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep enums
-keepclassmembers enum * { *; }

# Firebase Analytics & Messaging (if used)
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Gson or JSON serialization (if used)
-keep class com.google.gson.** { *; }
-keep class com.fasterxml.jackson.** { *; }

# Room / Database entities (if used)
-keep class androidx.room.** { *; }
-keepclassmembers class * extends androidx.room.RoomDatabase { *; }

# Retrofit / OkHttp (if used)
-keep class retrofit2.** { *; }
-keep interface retrofit2.** { *; }

# Google Maps (if used)
-keep class com.google.android.gms.maps.** { *; }
-keep class com.google.maps.android.** { *; }

# Suppress warnings
-dontwarn io.flutter.embedding.**
-dontwarn com.google.**
-dontwarn androidx.**
