//
//  ContentView.swift
//  NavigationLink
//
//  Created by 藤　治仁 on 2019/12/22.
//  Copyright © 2019 Swift-Beginners. All rights reserved.
//

import SwiftUI

struct ContentView: View {
   var body: some View {
      NavigationView {
        VStack {
            NavigationLink(destination: SecondContentView()) {
                Text("Press on me")
            }.buttonStyle(PlainButtonStyle())
        }
      }
   }
}

struct SecondContentView: View {
   var body: some View {
      Text("Hello, World!")
   }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
