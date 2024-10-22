//
//  LoginView.swift
//  Style
//
//  Created by Dominic Teh on 22/10/24.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
  @State private var email: String = ""
  @State private var password: String = ""
  @State private var errorMessage: String?
  @State private var isLoggedIn = false
  @State private var navigateToRegister = false // State to manage navigation to registration
  
  var body: some View {
    NavigationStack {
      VStack {
        Text("Welcome Back!")
          .font(.title)
          .fontWeight(.bold)
          .padding()
        
        TextField("Email", text: $email)
          .autocapitalization(.none)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding()
        
        SecureField("Password", text: $password)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding()
        
        if let errorMessage = errorMessage {
          Text(errorMessage)
            .foregroundColor(.red)
            .padding()
        }
        
        Button(action: loginUser) {
          Text("Log In")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color.green)
            .cornerRadius(8)
        }
        
        // Button to navigate to RegistrationView
        Button(action: {
          navigateToRegister = true
        }) {
          Text("Don't have an account? Register")
            .font(.headline)
            .foregroundColor(.blue)
            .padding()
        }
        
        // Navigation link to the main app view
        NavigationLink(destination: AppView(), isActive: $isLoggedIn) {
          EmptyView() // Hidden navigation link
        }
        
        // Navigation link to the registration view
        NavigationLink(destination: RegistrationView(), isActive: $navigateToRegister) {
          EmptyView() // Hidden navigation link
        }
      }
      .padding()
    }
  }
  
  func loginUser() {
    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
      if let error = error {
        self.errorMessage = "Failed to log in: \(error.localizedDescription)"
      } else {
        self.errorMessage = "Successfully logged in!"
        self.isLoggedIn = true
      }
    }
  }
}

#Preview {
  LoginView()
}
