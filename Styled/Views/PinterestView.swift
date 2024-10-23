//
//  PinterestView.swift
//  Styled
//
//  Created by Dominic Teh on 24/9/24.
//

import SwiftUI

struct PinterestView: View {
  @State private var authorizationCode: String?
  
  var body: some View {
    VStack {
      Text("Welcome to Pinterest Authorization")
        .font(.headline)
        .padding()
      
      Button(action: {
        openPinterestOAuth()
      }) {
        Text("Authorize with Pinterest")
          .foregroundColor(.white)
          .padding()
          .background(Color.blue)
          .cornerRadius(8)
      }
    }
    .onOpenURL { url in
      // Handle the redirect URL and extract the authorization code
      if let code = extractAuthorizationCode(from: url) {
        self.authorizationCode = code
        exchangeCodeForToken(authCode: code)
      }
    }
  }
  
  func openPinterestOAuth() {
    let clientID = "ENTER_PINTEREST_APP_ID_HERE"
    let redirectURI = "styleapp://callback"
    let responseType = "code"
    let scope = "boards:read,pins:read"
    let state = "YOUR_OPTIONAL_STATE"
    
    if let url = URL(string: """
                    https://www.pinterest.com/oauth/?\
                    client_id=\(clientID)&\
                    redirect_uri=\(redirectURI)&\
                    response_type=\(responseType)&\
                    scope=\(scope)&\
                    state=\(state)
                    """) {
      UIApplication.shared.open(url)
    }
  }
  
  func extractAuthorizationCode(from url: URL) -> String? {
    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
          let queryItems = components.queryItems else { return nil }
    
    return queryItems.first(where: { $0.name == "code" })?.value
  }
}

func exchangeCodeForToken(authCode: String) {
  // Define your endpoint URL
  guard let url = URL(string: "https://api.pinterest.com/v5/oauth/token") else {
    print("Invalid URL")
    return
  }
  
  // Prepare client credentials
  let clientID = "ENTER_PINTEREST_APP_ID_HERE"
  let clientSecret = "ENTER_PINTEREST_APP_SECRET_HERE"
  let credentials = "\(clientID):\(clientSecret)"
  guard let credentialsData = credentials.data(using: .utf8) else { return }
  let base64Credentials = credentialsData.base64EncodedString()
  
  // Create URLRequest
  var request = URLRequest(url: url)
  request.httpMethod = "POST"
  request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
  request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
  
  // Set up request body
  let redirectURI = "styleapp://callback"
  let bodyParameters = [
    "grant_type": "authorization_code",
    "code": authCode,
    "redirect_uri": redirectURI
  ]
  
  // Convert parameters to data
  let bodyString = bodyParameters.map { "\($0)=\($1)" }.joined(separator: "&")
  request.httpBody = bodyString.data(using: .utf8)
  
  // Send the request
  let task = URLSession.shared.dataTask(with: request) { data, response, error in
    if let error = error {
      print("Error: \(error.localizedDescription)")
      return
    }
    
    guard let data = data,
          let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
      print("Invalid response data")
      return
    }
    
    // Handle response JSON (access token, etc.)
    print("Response JSON: \(responseJSON)")
    
    if let accessToken = responseJSON["access_token"] as? String {
      print("Access Token: \(accessToken)")
      // Use the access token for further API requests
    } else if let message = responseJSON["message"] as? String {
      print("Error Message: \(message)")
    }
  }
  
  task.resume()
}

#Preview {
  PinterestView()
}
