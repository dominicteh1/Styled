//
//  BackgroundRemovalView.swift
//  Styled
//
//  Created by Dominic Teh on 25/9/24.
//

import Foundation
import SwiftUI
import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

struct BackgroundRemovalView: View {
  @State private var backgroundRemovedImage: UIImage? = nil
  @State private var selectedImage: UIImage? = nil
  @State private var showImagePicker = false
  @State private var showAlert = false
  @State private var errorMessage = ""
  @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
  @State private var showSourceSelection = false
  
  var body: some View {
    VStack {
      if let backgroundRemovedImage = backgroundRemovedImage {
        // Display the background-removed image
        Image(uiImage: backgroundRemovedImage)
          .resizable()
          .scaledToFit()
          .frame(width: 300, height: 300)
      } else if let selectedImage = selectedImage {
        // Display the selected image before background removal
        Image(uiImage: selectedImage)
          .resizable()
          .scaledToFit()
          .frame(width: 300, height: 300)
      } else {
        Text("Upload an image to remove the background")
      }
      
      HStack {
        // Button to open the source selection
        Button(action: {
          showSourceSelection = true
        }) {
          Text("Select Image")
            .padding()
            .background(Color.gray)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .actionSheet(isPresented: $showSourceSelection) {
          ActionSheet(
            title: Text("Choose Image Source"),
            message: nil,
            buttons: [
              .default(Text("Camera")) {
                sourceType = .camera
                showImagePicker = true
              },
              .default(Text("Photo Library")) {
                sourceType = .photoLibrary
                showImagePicker = true
              },
              .cancel()
            ]
          )
        }
        .sheet(isPresented: $showImagePicker) {
          ImagePicker(selectedImage: $selectedImage, sourceType: sourceType)
        }
        
        // Button to open image picker
        //        Button(action: {
        //          showImagePicker = true
        //        }) {
        //          Text("Select Image")
        //            .padding()
        //            .background(Color.gray)
        //            .foregroundColor(.white)
        //            .cornerRadius(8)
        //        }
        //        .sheet(isPresented: $showImagePicker) {
        //          ImagePicker(selectedImage: $selectedImage)
        //        }
        
        // Button to remove the background
        if selectedImage != nil {
          Button(action: {
            if let image = selectedImage {
              removeBackgroundFromImage(image: image) { result in
                switch result {
                case .success(let data):
                  if let removedImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                      self.backgroundRemovedImage = removedImage
                    }
                  }
                case .failure(let error):
                  DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                  }
                }
              }
            }
          }) {
            Text("Remove Background")
              .padding()
              .background(Color.blue)
              .foregroundColor(.white)
              .cornerRadius(8)
          }
        }
        
        // Button to remove the selected image
        if selectedImage != nil || backgroundRemovedImage != nil {
          Button(action: {
            // Clear the selected and processed images
            selectedImage = nil
            backgroundRemovedImage = nil
          }) {
            Text("Remove Image")
              .padding()
              .background(Color.red)
              .foregroundColor(.white)
              .cornerRadius(8)
          }
          
          // Button to save the image with removed background to Firestore
          Button(action: {
            if let imageToSave = backgroundRemovedImage ?? selectedImage {
              saveImageToFirebase(imageToSave)
            }
          }) {
            Text("Save Image")
              .padding()
              .background(Color.green)
              .foregroundColor(.white)
              .cornerRadius(8)
          }
        }
      }
    }
    .alert(isPresented: $showAlert) {
      Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
    }
  }
  
  
  func saveImageToFirebase(_ image: UIImage) {
    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
      print("Failed to convert image to JPEG data.")
      return
    }
    
    // Get the current user's UID
    guard let userId = Auth.auth().currentUser?.uid else {
      print("User is not authenticated.")
      return
    }
    
    // Create a unique file path in Firebase Storage
    let storageRef = Storage.storage().reference().child("images/\(userId)/\(UUID().uuidString).jpg")
    
    // Upload the image data to Firebase Storage
    storageRef.putData(imageData, metadata: nil) { metadata, error in
      if let error = error {
        print("Error uploading image: \(error.localizedDescription)")
        return
      }
      
      // Get the download URL for the uploaded image
      storageRef.downloadURL { url, error in
        if let error = error {
          print("Error getting download URL: \(error.localizedDescription)")
          return
        }
        
        guard let url = url else {
          print("Download URL is nil.")
          return
        }
        
        // Reference to Firestore database
        let db = Firestore.firestore()
        
        // Add the image URL to the user's "photos" collection in Firestore
        db.collection("users").document(userId).collection("photos").addDocument(data: [
          "imageUrl": url.absoluteString,
          "uploadedAt": Timestamp(date: Date())
        ]) { error in
          if let error = error {
            print("Error saving photo metadata: \(error.localizedDescription)")
          } else {
            print("Photo metadata successfully saved!")
          }
        }
      }
    }
  }
}
#Preview {
  BackgroundRemovalView()
}
