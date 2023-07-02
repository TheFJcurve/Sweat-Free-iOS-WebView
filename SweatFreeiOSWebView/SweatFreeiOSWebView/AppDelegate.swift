//
//  AppDelegate.swift
//  SweatFreeiOSWebView
//
//  Created by Sargun Singh Bhatti on 2023-06-16.
//

import UIKit
import Firebase
import FirebaseMessaging
import FirebaseAnalytics


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    
      // 1
      FirebaseApp.configure()
      // 2
      FirebaseConfiguration.shared.setLoggerLevel(.min)
      
      // 1
      UNUserNotificationCenter.current().delegate = self
      // 2
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions) { _, _ in }
      // 3
      application.registerForRemoteNotifications()
      
      Messaging.messaging().delegate = self
    
      return true
  }
}

// MARK: - userNotificationCenter
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([[.banner, .sound]])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        completionHandler()
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
        ) {
            Messaging.messaging().apnsToken = deviceToken
    }
}

// MARK: - messagingDelegate
extension AppDelegate: MessagingDelegate {
  func messaging(
    _ messaging: Messaging,
    didReceiveRegistrationToken fcmToken: String?
  ) {
    let tokenDict = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(
      name: Notification.Name("FCMToken"),
      object: nil,
      userInfo: tokenDict)
  }
}


