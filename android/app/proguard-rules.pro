# WorkManager (pulled in transitively, e.g. by Firebase/Google Mobile Ads) fails
# to build its Room-backed WorkDatabase under R8 full-mode shrinking: Room's
# RoomDatabase.Builder.build() throws a bare "Failed to create an instance of
# androidx.work.impl.WorkDatabase" (an InstantiationException with no cause
# attached) because R8 mangles the generated *_Impl class beyond what Room's
# reflective instantiation can find. Keep Room/WorkManager generated code and
# its no-arg constructors intact so the DB can actually be instantiated.
-keep class * extends androidx.room.RoomDatabase
-keep,allowobfuscation class * extends androidx.room.RoomDatabase
-keepclassmembers class * extends androidx.room.RoomDatabase {
    <init>();
}
-keep class androidx.work.impl.WorkDatabase
-keep class androidx.work.impl.WorkDatabase_Impl
-keep class androidx.work.impl.model.** { *; }
-keep class androidx.room.** { *; }
-dontwarn androidx.room.paging.**
