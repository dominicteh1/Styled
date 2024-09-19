//
//  ContentView.swift
//  Style
//
//  Created by Dominic Teh on 11/9/24.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationStack {
      VStack {
        Image(systemName: "globe")
          .imageScale(.large)
          .foregroundStyle(.tint)
        Text("Hello, world!")
        Text("Test commit")
        
        NavigationLink(destination: RegistrationView()) {
          Text("Register")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(10)
            .padding()
        }
      }
      .padding()
    }
  }
}

#Preview {
  ContentView()
}
