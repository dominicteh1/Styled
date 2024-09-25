//
//  ContentView.swift
//  Style
//
//  Created by Dominic Teh on 11/9/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct RegistrationView: View {
  @State private var email: String = ""
  @State private var password: String = ""
  @State private var errorMessage: String?
  
  var body: some View {
    VStack {
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
    }
    .padding()
  }
  
  func registerUser() {
    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
      if let error = error {
        self.errorMessage = "Failed to register: \(error.localizedDescription)"
      } else {
        self.errorMessage = "Successfully registered!"
        // Proceed to next steps (e.g., navigate to a different view)
      }
    }
  }
  
}

#Preview {
  RegistrationView()
}
