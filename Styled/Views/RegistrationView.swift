//
//  RegistrationView.swift
//  Style
//
//  Created by Dominic Teh on 11/9/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct RegistrationView: View {
  @State private var email: String = ""
  @State private var password: String = ""
  @State private var errorMessage: String?
  @State private var isRegistered = false // State to manage navigation
  @State private var navigateToLogin = false // State to manage navigation to login
  
  var body: some View {
    NavigationStack{
      VStack {
        Text("Welcome to Styled!")
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
        
        Button(action: registerUser) {
          Text("Register")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(8)
        }
        
        // Button to navigate to LoginView
        Button(action: {
          navigateToLogin = true
        }) {
          Text("Already have an account? Log in")
            .font(.headline)
            .foregroundColor(.blue)
            .padding()
        }
        
        // Navigation link to the main app view
        NavigationLink(destination: AppView(), isActive: $isRegistered) {
          EmptyView() // Hidden navigation link
        }
        
        // Navigation link to the login view
        NavigationLink(destination: LoginView(), isActive: $navigateToLogin) {
          EmptyView() // Hidden navigation link
        }
      }
      .padding()
    }
  }
  
  func registerUser() {
    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
      if let error = error {
        self.errorMessage = "Failed to register: \(error.localizedDescription)"
      } else if let user = authResult?.user {
        self.errorMessage = "Successfully registered!"
        self.isRegistered = true
        
        // Initialize Firestore
        let db = Firestore.firestore()
        
        // Create a document for the user with empty collections for friends and photos
        let userRef = db.collection("users").document(user.uid)
        
        // Initialize empty subcollections
        userRef.collection("friends").document("init").setData([:]) { error in
          if let error = error {
            print("Error creating friends collection: \(error)")
          } else {
            print("Friends collection initialized.")
          }
        }
        
        userRef.collection("photos").document("init").setData([:]) { error in
          if let error = error {
            print("Error creating photos collection: \(error)")
          } else {
            print("Photos collection initialized.")
          }
        }
      }
    }
  }
}

#Preview {
  RegistrationView()
}
