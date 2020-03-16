# unity_player_widget

A plugin that allows you to embed a Unity project in Flutter.

# How to install
## Preparation
0. Add unity_player_widget plugin to your Flutter project.
1. Create a Unity project (or use existed).
2. Download [Editor folder](https://github.com/Pavel-Kupreichyk/unity-player-widget/tree/master/Editor) and add it to your unity project.
2. Create a folder named "unity" in the Flutter project.
3. Move created Unity project to "unity" folder.<br/>

Your flutter project folder should look like this:<br/>
**-android<br/>
-ios<br/>
-lib<br/>
-test<br/>
-unity<br/>
   └{Your Unity Project}<br/>
-pubspec.yml<br/>
-README.md<br/>**

## Android
1. In Unity project go to File->Build settings
2. Add at least 1 scene to the project
3. Go to android Player Settings<br/>
  **(!!!settings may vary depending on which Unity packages you use!!!)**<br/>
  
  **Universal player settings:<br/>
    Scripting Backend -> IL2CPP<br/>
    ARMv7 -> TRUE<br/>
    ARM64 -> TRUE<br/>**
    
  **AR Foundation player settings:<br/>
    Minimum API Level -> 24<br/>
    Scripting Backend -> IL2CPP<br/>
    ARMv7 -> TRUE<br/>
    ARM64 -> TRUE<br/>**
    
  **Vuforia player settings:<br/>
    Scripting Backend -> IL2CPP<br/>
    ARMv7 -> TRUE<br/>
    ARM64 -> TRUE<br/>**
    
  **EasyAR player settings:<br/>
    Auto Graphics API -> False<br/>
    Graphics APIs -> OpenGLES2<br/>
    Multithread Rendering -> False<br/>
    Scripting Backend -> IL2CPP<br/>
    ARMv7 -> TRUE<br/>
    ARM64 -> TRUE<br/>**
    
4. Select UnityPlayerWidget->Export Android
5. In Flutter project go to android/unityLibrary/libs and create package for every aar or jar file in the folder.
(If you use AndroidStudio, just right-click to your project, select New->Module->{Import .JAR/.AAR Package} and find aar or jar file in the libs folder).<br/>
![](images/photo7.png)<br/>
6. Move all created packages into android folder. 
7. Go to android/unityLibrary/build.gradle<br/>
- Remove this line:<br/>
<pre>// GENERATED BY UNITY. REMOVE THIS COMMENT TO PREVENT OVERWRITING WHEN EXPORTING AGAIN</pre>

- Replace all dependencies by **implementation project(':[Name of created package]')**<br/>
Your dependencies should look like this:<br/>
<pre>
dependencies {
    implementation project(':package1')
    implementation project(':package2')
    implementation project(':package3')
    implementation project(':package4')
}
</pre>
- Add buildTypes to android section:<br/>
<pre>android {
	//**//
	buildTypes {
		profile { matchingFallbacks = ['debug', 'release'] }
	}
}
</pre>
8. Go to android/settings.gradle<br/>
- Include all created packages (first line of the file)<br/>
Your include section should look like this:<br/>
<pre>
include ':app', ':package1', ':package2', ':package3', ':package4'
</pre>
- Add this to the end of the file:
<pre>
include ":unityLibrary"
project(":unityLibrary").projectDir = file("./unityLibrary")
</pre>
9. minSdkVersion in android/app/build.gradle and android/unityLibrary/build.gradle must be equal (change minSdkVersion in android/app/build.gradle if they are not).
10. **VUFORIA ONLY**<br/> 
Add **android:screenOrientation="fullSensor"** as an activity attribute in android/app/src/main/AndroidManifest.xml file.
## iOS
1. In Unity project go to File->Build settings
2. Add at least 1 scene to the project
3. Go to iOS Player Settings<br/>
  **Universal player settings:<br/>
    Metal API Validation -> False<br/>**
    
  **AR Foundation player settings:<br/>
    Metal API Validation -> False<br/>
    Target Minimum iOS version -> 11.0<br/>
    Architecture -> ARM64<br/>**
    
  **Vuforia player settings:<br/>
  (not tested yet)**
    
  **EasyAR player settings:<br/>
    Auto Graphics API -> False<br/>
    Graphics APIs -> Metal, OpenGLES2<br/>
    Metal API Validation -> False<br/>
    Architecture -> Universal<br/>**
    
4. Select UnityPlayerWidget->Export iOS.
5. Open Runner.xcworkspace with Xcode and add ios/unityLibrary/Unity-iPhone.xcodeproj to "Runner".
![](images/photo6.png)<br/>
6. Add Data folder to the UnityFramework in the Target Membership section.<br/>
![](images/photo1.png)
![](images/photo2.png)<br/>
7. Add UnityFramework to "Runner".<br/>
![](images/photo3.png)
![](images/photo4.png)
![](images/photo5.png)<br/>
8. Go to Runner/Info.plist and add **io.flutter.embedded_views_preview -> YES**
9. **AR ONLY**<br/>
Go to Runner/Info.plist and add **Privacy - Camera Usage Description -> [Some description]**
10. **EasyAR ONLY**<br/>
Go to Unity-iPhone -> UnityFramework and set **Enable Bitcode -> NO**
