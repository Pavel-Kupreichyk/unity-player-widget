import Flutter

public class SwiftUnityPlayerWidgetPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        registrar.register(UnityPlayerWidgetFactory(), withId: "unity_player")

        let channel = FlutterMethodChannel(name: "unity_player_main", binaryMessenger: registrar.messenger())
        let instance = SwiftUnityPlayerWidgetPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "init_unity":
            guard let args = call.arguments as? Dictionary<String, Any>,
            let pauseDelay = args["pauseDelay"] as? Int32,
            let autoPause = args["autoPause"] as? Bool else {
                result(false)
                return
            }
            
            UnityPlayer.initUnityPlayer(CommandLine.argc, argv: CommandLine.unsafeArgv, pauseDelay: pauseDelay, isAutoPauseEnabled: autoPause)
            result(true)
        case "start_unity":
            
            UnityPlayer.startUnity()
            result(true)
        case "stop_unity":
            
            UnityPlayer.stopUnity()
            result(true)
        case "unity_send_msg":
            guard let args = call.arguments as? Dictionary<String, String> else {
                result(false)
                return
            }
            
            UnityPlayer.sendMessage(toUnityObject: args["object"],
                                    function: args["method"],
                                    message: args["message"])
            result(true)
        default:
            result(false)
        }
    }
}

public class UnityPlayerWidgetFactory: NSObject, FlutterPlatformViewFactory {
    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return UnityPlayerView(withFrame: frame, viewIdentifier: viewId)
    }
}

public class UnityPlayerView: NSObject, FlutterPlatformView {
    final var viewId: Int64
    var disposeWorker: DispatchWorkItem?
    
    
    init(withFrame frame: CGRect, viewIdentifier viewId: Int64) {
        self.viewId = viewId
        if(UnityPlayer.isAutoPauseEnabled()) {
            disposeWorker?.cancel()
            DispatchQueue.main.async {
                UnityPlayer.addViewId(viewId)
            }
        }
    }
    
    deinit {
        if(UnityPlayer.isAutoPauseEnabled()) {
            let id = viewId
            disposeWorker = DispatchWorkItem {UnityPlayer.removeViewId(id)}
            DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(Int(UnityPlayer.getPauseDelay())),
                                          execute: disposeWorker!)
        }
    }

    public func view() -> UIView {
        if let unityView = UnityPlayer.getUnityView() {
            return unityView
        }
        
        let container = UIView()
        container.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        let label = UILabel(frame: CGRect.zero)
        label.text = "Unity player is disabled"
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)

        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: container, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: container, attribute: .centerY, multiplier: 1, constant: 0)
        ])
        
        return container
    }
}
