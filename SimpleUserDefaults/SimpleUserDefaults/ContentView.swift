//
//  ContentView.swift
//  SimpleUserDefaults
//
//  Created by 藤　治仁 on 2019/12/24.
//  Copyright © 2019 FromF.github.com. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var inputText:String = ""
    @State var displayText:String = ""

    var body: some View {
        VStack {
            Text("Hello, \(self.displayText)!")
            TextField("Your name", text: $inputText , onCommit: {
                UserDefaults.standard.set(self.inputText, forKey: "name")
                self.displayText = self.inputText
                self.inputText = ""
                })
                .padding()
        }
        .onAppear {
            self.displayText = "World"
            guard let userdefaultText = UserDefaults.standard.value(forKey: "name") as? String else { return }
            self.displayText = userdefaultText
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
