//
//  AppView.swift
//  Styled
//
//  Created by Dominic Teh on 24/9/24.
//

import SwiftUI

struct AppView: View {
  var body: some View {
    TabView {
      ClosetView()
        .tabItem {
          Image(systemName: "tshirt.fill")
          Text("Closet")
        }
      SearchView()
        .tabItem {
          Image(systemName: "magnifyingglass")
          Text("Search")
        }
      UploadPhotoView()
        .tabItem {
          Image(systemName: "square.and.arrow.up.fill")
          Text("Upload")
        }
      FriendsView()
        .tabItem {
          Image(systemName: "person.2")
          Text("Friends")
        }
      MyAccountView()
        .tabItem {
          Image(systemName: "person.circle.fill")
          Text("Account")
        }
    }
  }
}

struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView()
  }
}
