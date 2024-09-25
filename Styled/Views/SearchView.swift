//
//  SearchView.swift
//  Styled
//
//  Created by Dominic Teh on 24/9/24.
//

import SwiftUI

struct SearchView: View {
  @State private var searchText: String = ""
  var body: some View {
    VStack {
      Text("Search")
        .font(.title)
        .fontWeight(.bold)
      
      // Search bar using the search field modifier
      TextField("Search...", text: $searchText)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
      
      // You can use the search text below or perform a search based on input
      if !searchText.isEmpty {
        Text("Searching for \(searchText)")
          .padding()
      }
      Spacer()
    }
    .padding()
  }
}


#Preview {
  SearchView()
}
