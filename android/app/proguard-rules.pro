# =========================
# Flutter Core
# =========================
-keep class io.flutter.app.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.plugins.** { *; }

# Prevent stripping of enums used in Flutter
-keepclassmembers enum * { *; }

# =========================
# Firebase
# =========================
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-keep class com.google.firebase.messaging.** { *; }

# =========================
# Google Maps
# =========================
-keep class com.google.android.gms.maps.** { *; }
-keep interface com.google.android.gms.maps.** { *; }
-keep class com.google.maps.android.** { *; }   # If using maps utils library

# =========================
# Razorpay
# =========================
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# =========================
# Fix for Flutter Play Core (Split Install)
# =========================
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

-keep class com.google.android.play.core.splitcompat.** { *; }
-dontwarn com.google.android.play.core.splitcompat.**

-keep class com.google.android.play.core.splitinstall.** { *; }
-dontwarn com.google.android.play.core.splitinstall.**

-keep class com.google.android.play.core.splitinstall.SplitInstallSessionState { *; }

-keep class com.google.android.play.core.tasks.** { *; }
-dontwarn com.google.android.play.core.tasks.**

# =========================
# Gson / JSON Models
# =========================
-keep class com.bringsesellerapp.model.** { *; }  
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# =========================
# Logging (optional)
# =========================
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}

# =========================
# Keep Main Activity
# =========================
-keep class com.bringsesellerapp.MainActivity { *; }  

# =========================
# Misc
# =========================
-keep class * implements java.io.Serializable { *; }

# =========================
# Additional Flutter Safe Keep Rules
# =========================
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-dontwarn io.flutter.**
