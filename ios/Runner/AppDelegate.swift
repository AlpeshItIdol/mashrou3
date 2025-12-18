import UIKit
import Flutter
import GoogleMaps
import Firebase
import FirebaseMessaging
import flutter_local_notifications
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  lazy var flutterEngine = FlutterEngine(name: "custom_engine") // 👈 Define this at class level

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Start the Flutter engine
    flutterEngine.run()
    GeneratedPluginRegistrant.register(with: flutterEngine) // register plugins with custom engine

    // Initialize Google Maps
    GMSServices.provideAPIKey("AIzaSyBNW0n1IejggiH3FhVRR37WpOMSGKCeruY")

    // Register plugins for default engine
    GeneratedPluginRegistrant.register(with: self)

    registerNotificationCategories()

    UNUserNotificationCenter.current().delegate = self

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
    application.applicationIconBadgeNumber = 0;
  }

  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {

    let actionId = response.actionIdentifier
   
    let payload = response.notification.request.content.userInfo
      
      var backgroundTaskId: UIBackgroundTaskIdentifier = .invalid
      backgroundTaskId = UIApplication.shared.beginBackgroundTask(withName: "NotificationAction") {
          UIApplication.shared.endBackgroundTask(backgroundTaskId)
          backgroundTaskId = .invalid
      }
      
    let channel = FlutterMethodChannel(name: "custom_notification_channel", binaryMessenger: flutterEngine.binaryMessenger)
      
    if actionId == "ACCEPT_ACTION" {
        callNativeAPI(with: [
          "action": "approved",
          "requestId": payload["dataReference"] ?? "unknown"
        ], completion: {
            UIApplication.shared.endBackgroundTask(backgroundTaskId)

        })
      channel.invokeMethod("handleAcceptAction", arguments: payload)
    }

    if actionId == "REPLY_ACTION" {
      if let textResponse = response as? UNTextInputNotificationResponse {
        let userInput = textResponse.userText
        let arguments: [String: Any?] = [
          "payload": payload,
          "userInput": userInput
        ]
          
          callNativeAPI(with: [
            "message": userInput,
            "action": "rejected",
            "requestId": payload["dataReference"] ?? "unknown",
          ],completion: {
              UIApplication.shared.endBackgroundTask(backgroundTaskId)

          })
        channel.invokeMethod("handleRejectAction", arguments: arguments)
      }
    }

    super.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
  }

  func registerNotificationCategories() {
    let acceptAction = UNNotificationAction(
      identifier: "ACCEPT_ACTION",
      title: "Accept",
      options: [.destructive]
    )

    let replyAction = UNTextInputNotificationAction(
      identifier: "REPLY_ACTION",
      title: "Reply",
      options: [.destructive],
      textInputButtonTitle: "Send",
      textInputPlaceholder: "Type your response"
    )

    let category = UNNotificationCategory(
      identifier: "VISIT_REQUEST_CREATED",
      actions: [acceptAction, replyAction],
      intentIdentifiers: [],
      options: []
    )

    UNUserNotificationCenter.current().setNotificationCategories([category])
  }
    
    func callNativeAPI(with data: [String: Any], completion: (() -> Void)? = nil) {

        let apiURL = "https://api.mashrou3.com/api/v1/request-management/request"

        guard let url = URL(string: apiURL) else {
            print("Invalid API URL")
            completion?()
            return
        }

        print(data)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let channel = FlutterMethodChannel(name: "custom_notification_channel", binaryMessenger: flutterEngine.binaryMessenger)

        DispatchQueue.main.async {
            channel.invokeMethod("getAuthToken", arguments: nil) { result in
                guard let token = result as? String else {
                    print("Failed to receive token from Flutter")
                    return
                }
                print("Token Fetched")

                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                    request.httpBody = jsonData

                    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                        if let error = error {
                            print("API request failed: \(error)")
                            return
                        }

                        if let httpResponse = response as? HTTPURLResponse {
                            print("Status Code: \(httpResponse.statusCode)")
                        }

                        if let data = data,
                           let responseString = String(data: data, encoding: .utf8) {
                            print("API Response Body: \(responseString)")
                        }
                    }
                    completion?()
                    task.resume()
                } catch {
                    print("Failed to serialize JSON: \(error)")
                    completion?()
                }
            }
        }
    }
}
