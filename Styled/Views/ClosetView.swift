//
//  ClosetView.swift
//  Styled
//
//  Created by Dominic Teh on 24/9/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import SDWebImageSwiftUI // Use this library for easy image loading from URLs
import FirebaseAuth

struct ClosetView: View {
  @State private var imageUrls: [String] = []
  @State private var errorMessage: String?
  
  var body: some View {
    NavigationView {
      VStack {
        if let errorMessage = errorMessage {
          Text("Error: \(errorMessage)")
            .foregroundColor(.red)
            .padding()
        } else if imageUrls.isEmpty {
          Text("No photos found.")
            .padding()
        } else {
          ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
              ForEach(imageUrls, id: \.self) { url in
                WebImage(url: URL(string: url))
                  .resizable()
                  .scaledToFit()
                  .frame(width: 100, height: 100)
                  .cornerRadius(8)
              }
            }
            .padding()
          }
        }
      }
      .navigationTitle("My Closet")
      .onAppear(perform: fetchPhotos)
    }
  }
  
  func fetchPhotos() {
    guard let userId = Auth.auth().currentUser?.uid else {
      self.errorMessage = "User not authenticated."
      return
    }
    
    let db = Firestore.firestore()
    db.collection("users").document(userId).collection("photos").getDocuments { snapshot, error in
      if let error = error {
        self.errorMessage = "Error fetching photos: \(error.localizedDescription)"
        return
      }
      
      guard let documents = snapshot?.documents else {
        self.errorMessage = "No documents found."
        return
      }
      
      self.imageUrls = documents.compactMap { $0.data()["imageUrl"] as? String }
    }
  }
}

#Preview {
  ClosetView()
}
