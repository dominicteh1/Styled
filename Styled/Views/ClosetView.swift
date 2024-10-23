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
import FirebaseStorage

struct ClosetView: View {
  @State private var imageUrls: [String] = []
  @State private var errorMessage: String?
  @State private var showDeleteConfirmation = false
  @State private var selectedImageUrl: String? = nil
  
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
                  .onTapGesture {
                    selectedImageUrl = url
                    showDeleteConfirmation = true
                  }
              }
            }
            .padding()
          }
        }
      }
      .navigationTitle("My Closet")
      .actionSheet(isPresented: $showDeleteConfirmation) {
        ActionSheet(
          title: Text("Delete Photo"),
          message: Text("Are you sure you want to delete this photo?"),
          buttons: [
            .destructive(Text("Delete"), action: {
              if let url = selectedImageUrl {
                deletePhoto(imageUrl: url)
              }
            }),
            .cancel()
          ]
        )
      }
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
  
  func deletePhoto(imageUrl: String) {
    guard let userId = Auth.auth().currentUser?.uid else {
      self.errorMessage = "User not authenticated."
      return
    }
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    // First, delete from Firestore
    db.collection("users").document(userId).collection("photos").whereField("imageUrl", isEqualTo: imageUrl).getDocuments { snapshot, error in
      if let error = error {
        self.errorMessage = "Error fetching photo document: \(error.localizedDescription)"
        return
      }
      
      guard let document = snapshot?.documents.first else {
        self.errorMessage = "No matching photo document found."
        return
      }
      
      db.collection("users").document(userId).collection("photos").document(document.documentID).delete { error in
        if let error = error {
          self.errorMessage = "Error deleting document: \(error.localizedDescription)"
          return
        }
        
        // Then, delete from Firebase Storage
        let storageRef = storage.reference(forURL: imageUrl)
        storageRef.delete { error in
          if let error = error {
            self.errorMessage = "Error deleting photo from storage: \(error.localizedDescription)"
          } else {
            // Remove the deleted image from the UI
            if let index = imageUrls.firstIndex(of: imageUrl) {
              imageUrls.remove(at: index)
            }
          }
        }
      }
    }
  }
}
#Preview {
  ClosetView()
}
