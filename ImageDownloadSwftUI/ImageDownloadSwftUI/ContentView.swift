//
//  ContentView.swift
//  ImageDownloadSwftUI
//
//  Created by 藤治仁 on 2019/12/23.
//  Copyright © 2019 F-Works. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            URLImage(url: "https://1.bp.blogspot.com/-_CVATibRMZQ/XQjt4fzUmjI/AAAAAAABTNY/nprVPKTfsHcihF4py1KrLfIqioNc_c41gCLcBGAs/s400/animal_chara_smartphone_penguin.png")
                .aspectRatio(contentMode: .fit)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
