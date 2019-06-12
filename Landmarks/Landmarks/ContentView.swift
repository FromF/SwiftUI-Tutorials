//
//  ContentView.swift
//  Landmarks
//
//  Created by 藤治仁 on 2019/06/12.
//  Copyright © 2019 FromF.github.com. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    var body: some View {
        Text("Turtle Rock")
            .font(.largeTitle)
            .color(.green)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
