# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Supabase and dependencies
-keep class com.supabase.** { *; }
-keep class io.github.jan.supabase.** { *; }
-keep class okhttp3.** { *; }
-keep class retrofit2.** { *; }
-keep class com.google.gson.** { *; }
-keep class com.fasterxml.jackson.** { *; }

# url_launcher
-keep class io.flutter.plugins.urllauncher.** { *; }

# Prevent obfuscation of certain classes
-keepattributes Signature, Exceptions, *Annotation*
