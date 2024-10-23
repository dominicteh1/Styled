//
//  StyleApp.swift
//  Style
//
//  Created by Dominic Teh on 11/9/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import FirebaseAnalytics
import FirebaseDatabase
import FirebaseMessaging
import FirebaseInAppMessaging


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    if url.scheme == "styleapp" {
      // Handle the redirect and extract any parameters
      if let code = extractAuthorizationCode(from: url) {
        // Use the authorization code
        exchangeCodeForToken(authCode: code)
      }
      return true
    }
    return false
  }
  
  func extractAuthorizationCode(from url: URL) -> String? {
    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
          let queryItems = components.queryItems else { return nil }
    
    return queryItems.first(where: { $0.name == "code" })?.value
  }
}

@main
struct StyleApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  
  var body: some Scene {
    
    WindowGroup {
      RegistrationView()
    }
  }
}
