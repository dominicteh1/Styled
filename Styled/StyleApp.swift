//
//  StyleApp.swift
//  Style
//
//  Created by Dominic Teh on 11/9/24.
//

import SwiftUI
import FirebaseCore  // Core Firebase functionality
import FirebaseAnalytics // For Google Analytics and Logging Events
import FirebaseFirestore  // For Firestore
import FirebaseAuth  // For Authentication
import FirebaseMessaging  // For Notifications
import FirebaseStorage // For uploading and sharing user generated content, such as images and video
import FirebaseInAppMessaging // For messaging in-app
import FirebaseDatabase // For cloud-hosted database. Data is stored as JSON and synchronized in realtime to every connected client

import FirebaseAuthUI

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct StyleApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  
  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
      }
    }
  }
}
