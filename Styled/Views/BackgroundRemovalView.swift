//
//  BackgroundRemovalView.swift
//  Styled
//
//  Created by Dominic Teh on 25/9/24.
//

import Foundation
import SwiftUI
import UIKit

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
            print("dom1")
            if let image = selectedImage {
              print("dom2")
              removeBackgroundFromImage(image: image) { result in
                switch result {
                case .success(let data):
                  print("dom success")
                  if let removedImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                      self.backgroundRemovedImage = removedImage
                    }
                  }
                case .failure(let error):
                  print("dom5")
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
        }
      }
      .alert(isPresented: $showAlert) {
        Alert(title: Text("Error oh no"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
      }
    }
  }
}

#Preview {
  BackgroundRemovalView()
}
