//
//  ContentView.swift
//  AVFoundationSwiftUI
//
//  Created by 藤　治仁 on 2020/01/02.
//  Copyright © 2020 FromF.github.com. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var image: UIImage?
    @State var takePhoto: Bool = false
    
    var body: some View {
        VStack {
            if image == nil {
                Spacer()
                
                ZStack(alignment: .bottom) {
                    AVFoundationView(image: $image, takePhoto: $takePhoto)
                    
                    Button(action: {
                        self.takePhoto.toggle()
                    }) {
                        Image(systemName: "camera.circle.fill")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 80, height: 80, alignment: .center)
                    }
                    .padding(.bottom, 100.0)
                }
                
                Spacer()
            } else {
                ZStack(alignment: .topLeading) {
                    VStack {
                        Spacer()
                        
                        Image(uiImage: image!)
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(contentMode: .fit)
                        
                        Spacer()
                    }
                    Button(action: {
                        self.image = nil
                    }) {
                            Image(systemName: "xmark.circle.fill")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                            .foregroundColor(.white)
                            .background(Color.gray)
                    }
                    .frame(width: 80, height: 80, alignment: .center)
                }
                
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView(image: UIImage(systemName: "rectangle.stack.person.crop"), takePhoto: false)
        }
    }
}
