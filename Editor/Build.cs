using System;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using UnityEditor;
using UnityEngine;
using Application = UnityEngine.Application;
using BuildResult = UnityEditor.Build.Reporting.BuildResult;

public class Build : MonoBehaviour
{
    static readonly string ProjectPath = Path.GetFullPath(Path.Combine(Application.dataPath, ".."));

    static readonly string localPath = Path.Combine(ProjectPath, "Builds/" + Application.productName + "_UPW");

    static readonly string androidExportPath = Path.GetFullPath(Path.Combine(ProjectPath, "../../android/unityLibrary"));
    static readonly string iosExportPath = Path.GetFullPath(Path.Combine(ProjectPath, "../../ios/unityLibrary"));

    static string[] EnabledScenes
    {
        get
        {
            return EditorBuildSettings.scenes
            .Where(s => s.enabled).Select(s => s.path)
            .ToArray();
        }
    }

    [MenuItem("UnityPlayerWidget/Export Android", false, 1)]
    public static void ExportAndroid()
    {
        if(Directory.Exists(localPath))
        {
            CopyFile(Path.Combine(androidExportPath, "build.gradle"), Path.Combine(localPath, "unityLibrary/build.gradle"));
            CopyFile(Path.Combine(androidExportPath, "src/main/AndroidManifest.xml"), Path.Combine(localPath, "unityLibrary/src/main/AndroidManifest.xml"));
            if(Directory.Exists(Path.Combine(localPath, "unityLibrary/libs")))
                Directory.Delete(Path.Combine(localPath, "unityLibrary/libs"), true);
        }

        EditorUserBuildSettings.androidBuildSystem = AndroidBuildSystem.Gradle;

        var options = BuildOptions.AcceptExternalModificationsToPlayer;

        var report = BuildPipeline.BuildPlayer(
            EnabledScenes,
            localPath,
            BuildTarget.Android,
            options
        );

        if (report.summary.result != BuildResult.Succeeded)
            throw new Exception("Android build failed");

        CopyDirectory(Path.Combine(localPath, "unityLibrary"), androidExportPath);

        var manifest_file = Path.Combine(androidExportPath, "src/main/AndroidManifest.xml");
        var manifest_text = File.ReadAllText(manifest_file);
        manifest_text = Regex.Replace(manifest_text, @"<application .*>", "<application>");
        Regex regex = new Regex(@"<activity.*>(\s|\S)+?</activity>", RegexOptions.Multiline);
        manifest_text = regex.Replace(manifest_text, "");
        File.WriteAllText(manifest_file, manifest_text);

        CopyDirectory(Path.Combine(localPath + "/launcher/src/main/res"), Path.Combine(androidExportPath, "src/main/res"));
    }

    [MenuItem("UnityPlayerWidget/Export iOS", false, 2)]
    public static void ExportIOS()
    {
        EditorUserBuildSettings.iOSBuildConfigType = iOSBuildType.Release;

        var options = BuildOptions.AcceptExternalModificationsToPlayer;
        var report = BuildPipeline.BuildPlayer(
            EnabledScenes,
            iosExportPath,
            BuildTarget.iOS,
            options
        );

        if (report.summary.result != BuildResult.Succeeded)
            throw new Exception("iOS build failed");
    }

    static void CopyDirectory(string source, string destinationPath)
    {
        if (Directory.Exists(destinationPath))
            Directory.Delete(destinationPath, true);

        Directory.CreateDirectory(destinationPath);

        foreach (string dirPath in Directory.GetDirectories(source, "*",
            SearchOption.AllDirectories))
            Directory.CreateDirectory(dirPath.Replace(source, destinationPath));

        foreach (string newPath in Directory.GetFiles(source, "*.*",
            SearchOption.AllDirectories))
            File.Copy(newPath, newPath.Replace(source, destinationPath), true);
    }

    static void CopyFile(string source, string dest)
    {
        if (File.Exists(source))
            File.Copy(source, dest, true);
        
    }
}
