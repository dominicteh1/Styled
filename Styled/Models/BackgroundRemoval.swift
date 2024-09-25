//
//  BackgroundRemoval.swift
//  Styled
//
//  Created by Dominic Teh on 25/9/24.
//

import Foundation
import SwiftUI
import UIKit

// Define your Azure endpoint and API key
let endpoint = ""
let apiKey = ""

// Function to make the API request
func removeBackgroundFromImage(image: UIImage, completion: @escaping (Result<Data, Error>) -> Void) {
  print("dom3")
  guard let url = URL(string: endpoint) else {
    print("dom4")
    print("Invalid URL")
    return
  }
  
  var request = URLRequest(url: url)
  print("url \(url)")
  request.httpMethod = "POST"
  request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
  request.setValue(apiKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
  
  // Convert UIImage to Data
  guard let imageData = image.jpegData(compressionQuality: 1.0) else {
    print("Failed to convert image to data")
    return
  }
  
  print("image data \(imageData)")
  let task = URLSession.shared.uploadTask(with: request, from: imageData) { data, response, error in
    if let error = error {
      print("error in task")
      completion(.failure(error))
      return
    }
    
    if let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
      completion(.success(data))
      print("success in data")
    } else {
      print("error in data")
      let errorMessage = String(data: data ?? Data(), encoding: .utf8) ?? "Unknown error"
      let apiError = NSError(domain: "AzureBackgroundRemoval", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
      completion(.failure(apiError))
    }
  }
  task.resume()
}

func handleResponse(data: Data) {
  if let backgroundRemovedImage = UIImage(data: data) {
    // You now have the image with the background removed
    DispatchQueue.main.async {
      // Update your UI with the background-removed image
      // imageView.image = backgroundRemovedImage
    }
  }
}

// Example usage
//if let image = UIImage(named: "your_image.jpg") {
//  removeBackgroundFromImage(image: image) { result in
//    switch result {
//    case .success(let data):
//      handleResponse(data: data)
//    case .failure(let error):
//      print("Error removing background: \(error.localizedDescription)")
//    }
//  }
//}
