#=========================================Basic invariant obfuscation configuration=========================================##
#Specify the code compression level
-optimizationpasses 5
#Do not mix case in package names
-dontusemixedcaseclassnames
#Do not skip non-public library classes
#-dontskipnonpubliclibraryclasses
# Do not skip members of non-public library classes
#-dontskipnonpubliclibraryclassmembers
#Optimization: do not optimize input classes
-dontoptimize
#Preverification
#-dontpreverify
#Whether to log during obfuscation
-verbose
# Algorithm used during obfuscation
-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*
#Keep annotations
-keepattributes *Annotation*
#Suppress warnings
-ignorewarnings

##Write generated reports to the project root during Gradle builds##
#Internal structure of all classes in the APK
#-dump class_files.txt
#Unobfuscated classes and members
-printseeds seeds.txt
#List code removed from the APK
-printusage unused.txt
#Obfuscation mapping
-printmapping mapping.txt
# Keep the source filename as "Proguard" instead of the original class name, and retain line numbers
-keepattributes SourceFile,LineNumberTable
########End of reports written to the project root during Gradle builds#####

#Items to keep
# Classes to keep from obfuscation
-keep public class * extends android.app.Fragment
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.app.backup.BackupAgentHelper
-keep public class * extends android.preference.Preference
-keep public class * extends android.support.v4.**
#-keep public class com.android.vending.licensing.ILicensingService

#Add the following line if the v4 library is used
#-keep public class * extends android.support.v4.app.Fragment

##########Keep JavaScript interface classes to ensure they can execute
-dontwarn com.android.JsInterface.**
-keep class com.android.JsInterface.** {*; }

#ProGuard issue with JPush and Baidu LBS SDK: keep Apache HTTP classes to avoid breaking positioning
-dontwarn org.apache.**
-keep class org.apache.**{ *; }

-keep public class * extends android.view.View {
  public <init>(android.content.Context);
  public <init>(android.content.Context, android.util.AttributeSet);
  public <init>(android.content.Context, android.util.AttributeSet, int);
  public void set*(...);
 }

#Keep native methods
-keepclasseswithmembernames class * {
  native <methods>;
}

#Keep custom widget classes
-keepclasseswithmembers class * {
  public <init>(android.content.Context, android.util.AttributeSet);
}

#Keep custom widget classes
-keepclassmembers class * extends android.app.Activity {
  public void *(android.view.View);
}

#Keep Parcelable classes
-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}

#Keep Serializable classes
-keepnames class * implements java.io.Serializable

#Keep Serializable and enum classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    !static !transient <fields>;
    !private <fields>;
    !private <methods>;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

#Keep enum classes; if obfuscation fails, use the preceding -keepclassmembers class * implements java.io.Serializable rule
-keepclassmembers enum * {
      public static **[] values();
      public static ** valueOf(java.lang.String);
}

-keepclassmembers class * {
      public void *ButtonClicked(android.view.View);
}

#Keep resource classes
-keep class **.R$* {*;}

#===================================Keep selected project code and third-party JAR libraries=============================#######
#If v4 or v7 libraries are used
-dontwarn android.support.**


# Keep AndroidX classes
-dontwarn com.google.android.material.**
-dontnote com.google.android.material.**
-dontwarn androidx.**
-keep class com.google.android.material.** {*;}
-keep class androidx.** {*;}
-keep public class * extends androidx.**
-keep interface androidx.** {*;}
-keepclassmembers class * {
    @androidx.annotation.Keep *;
}

# zxing
-dontwarn com.google.zxing.**
-keep class com.google.zxing.**{*;}

#SignalR push
-keep class microsoft.aspnet.signalr.** { *; }

# JPush obfuscation rules
#-dontoptimize
#-dontpreverify
#-dontwarn cn.jpush.**
#-keep class cn.jpush.** { *; }
#-dontwarn cn.jiguang.**
#-keep class cn.jiguang.** { *; }

# OrmLite database framework
-keepattributes *DatabaseField*
-keepattributes *DatabaseTable*
-keepattributes *SerializedName*
-keep class com.j256.**
-keepclassmembers class com.j256.** { *; }
-keep enum com.j256.**
-keepclassmembers enum com.j256.** { *; }
-keep interface com.j256.**
-keepclassmembers interface com.j256.** { *; }

#XHttp2
-keep class com.xuexiang.xhttp2.model.** { *; }
-keep class com.xuexiang.xhttp2.cache.model.** { *; }
-keep class com.xuexiang.xhttp2.cache.stategy.**{*;}
-keep class com.xuexiang.xhttp2.annotation.** { *; }

#okhttp
-dontwarn com.squareup.okhttp3.**
-keep class com.squareup.okhttp3.** { *;}
-dontwarn okio.**
-dontwarn javax.annotation.**

#Add the following rules for Gson parsing to avoid obfuscation errors
-keepattributes Signature
-keep class com.google.gson.stream.** { *; }
-keepattributes EnclosingMethod
-keep class org.xz_sale.entity.**{*;}
-keep class com.google.gson.** {*;}
-keep class com.google.**{*;}
#-keep class sun.misc.Unsafe { *; }
-keep class com.google.gson.stream.** { *; }
-keep class com.google.gson.examples.android.model.** { *; }

# Glide
-keep public class * implements com.bumptech.glide.module.GlideModule
-keep public class * extends com.bumptech.glide.module.AppGlideModule
-keep public enum com.bumptech.glide.load.ImageHeaderParser$** {
  **[] $VALUES;
  public *;
}

# Retrofit
-dontwarn retrofit2.**
-keep class retrofit2.** { *; }
-keepattributes Exceptions

# RxJava RxAndroid
-dontwarn sun.misc.**
-keepclassmembers class rx.internal.util.unsafe.*ArrayQueue*Field* {
    long producerIndex;
    long consumerIndex;
}
#-keepclassmembers class rx.internal.util.unsafe.BaseLinkedQueueProducerNodeRef {
#    rx.internal.util.atomic.LinkedQueueNode producerNode;
#}
#-keepclassmembers class rx.internal.util.unsafe.BaseLinkedQueueConsumerNodeRef {
#    rx.internal.util.atomic.LinkedQueueNode consumerNode;
#}

-dontwarn okio.**
-dontwarn javax.annotation.**

# fastjson
-dontwarn com.alibaba.fastjson.**
-keep class com.alibaba.fastjson.** { *; }
-keepattributes Signature

# xpage
-keep class com.xuexiang.xpage.annotation.** { *; }
-keep class com.xuexiang.xpage.config.** { *; }

# xaop
-keep @com.xuexiang.xaop.annotation.* class * {*;}
-keep @org.aspectj.lang.annotation.* class * {*;}
-keep class * {
    @com.xuexiang.xaop.annotation.* <fields>;
    @org.aspectj.lang.annotation.* <fields>;
}
-keepclassmembers class * {
    @com.xuexiang.xaop.annotation.* <methods>;
    @org.aspectj.lang.annotation.* <methods>;
}

# xrouter
-keep public class com.xuexiang.xrouter.routes.**{*;}
-keep class * implements com.xuexiang.xrouter.facade.template.ISyringe{*;}
# If retrieving a Service byType, add the following rules to keep interfaces
-keep interface * implements com.xuexiang.xrouter.facade.template.IProvider
# For single-class injection implementing IProvider without an interface, keep the implementation using these rules
-keep class * implements com.xuexiang.xrouter.facade.template.IProvider

# xupdate
-keep class com.xuexiang.xupdate.entity.** { *; }

# xvideo
-keep class com.xuexiang.xvideo.jniinterface.** { *; }

# xipc
-keep @com.xuexiang.xipc.annotation.* class * {*;}
-keep class * {
    @com.xuexiang.xipc.annotation.* <fields>;
}
-keepclassmembers class * {
    @com.xuexiang.xipc.annotation.* <methods>;
}

# Umeng Analytics
-keep class com.umeng.** {*;}
-keepclassmembers class * {
   public <init> (org.json.JSONObject);
}
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

-keep class com.xuexiang.xui.widget.edittext.materialedittext.** { *; }

# Android keep-alive: Cactus integrates dual-process foreground services, JobScheduler, onePix (one pixel), WorkManager and silent audio
-keep class com.gyf.cactus.entity.* {*;}

# Exclude entity classes
-keep class cn.ppps.forwarder.core.http.entity.** {*;}
-keep class cn.ppps.forwarder.database.entity.** {*;}
-keep class cn.ppps.forwarder.entity.** {*;}
-keep class cn.ppps.forwarder.server.model.** {*;}

# javax.mail
-dontwarn com.sun.**
-dontwarn javax.mail.**
-dontwarn javax.activation.**
-keep class com.sun.** { *;}
-keep class javax.mail.** { *;}
-keep class javax.activation.** { *;}
-keep class com.smailnet.emailkit.** { *;}
-keep class cn.ppps.forwarder.utils.mail.** {*;}
-keep class com.gitee.xuankaicat.kmnkt.** {*;}
-keep class org.eclipse.paho.client.** {*;}

-keep public class com.xuexiang.xrouter.routes.**{*;}
-keep class * implements com.xuexiang.xrouter.facade.template.ISyringe{*;}
# If retrieving a Service byType, add the following rules to keep interfaces
-keep interface * implements com.xuexiang.xrouter.facade.template.IProvider
# For single-class injection implementing IProvider without an interface, keep the implementation using these rules
-keep class * implements com.xuexiang.xrouter.facade.template.IProvider
# Suppress XRouter warnings
-dontwarn com.xuexiang.xrouter.**

-dontwarn com.alipay.sdk.**
-dontwarn com.android.org.conscrypt.**
-dontwarn java.awt.image.**
-dontwarn javax.lang.model.**
-dontwarn javax.naming.**
-dontwarn javax.naming.directory.**

# This is generated automatically by the Android Gradle plugin.
-dontwarn org.joda.convert.**
-dontwarn org.slf4j.impl.**

# MultiLanguages
-keep class com.hjq.language.** {*;}

# crontab parsing
-keep class gatewayapps.crondroid.** { *; }
-keep class net.redhogs.cronparser.** { *; }

# Suppress all R8 stack map warnings
-ignorewarnings
-dontwarn **
