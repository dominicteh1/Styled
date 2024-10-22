//
//  UploadPhotoView.swift
//  Styled
//
//  Created by Dominic Teh on 24/9/24.
//

import SwiftUI

struct UploadPhotoView: View {
  var body: some View {
    NavigationView {
      VStack {
        Text("Upload Photo")
          .font(.title)
          .fontWeight(.bold)
        
        NavigationLink(destination: BackgroundRemovalView()) {
          Text("Go to Upload Photo")
            .font(.title2)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
      }
    }
  }
}


#Preview {
  UploadPhotoView()
}
