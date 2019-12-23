//
//  ContentView.swift
//  TabBar
//
//  Created by 藤　治仁 on 2019/12/24.
//  Copyright © 2019 FromF.github.com. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TabAView()
                .tabItem {
                    VStack {
                        Image(systemName: "a")
                        Text("TabA")
                    }
            }.tag(1)
            TabBView()
                .tabItem {
                    VStack {
                        Image(systemName: "bold")
                        Text("TabB")
                    }
            }.tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
