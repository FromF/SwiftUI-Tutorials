//
//  URLImage.swift
//  ImageDownloadSwftUI
//
//  Created by 藤治仁 on 2019/12/23.
//  Copyright © 2019 F-Works. All rights reserved.
//

import SwiftUI

struct URLImage: View {
    
    let url: String
    @ObservedObject private var imageDownloader = ImageDownloader()
    
    init(url: String) {
        self.url = url
        self.imageDownloader.downloadImage(url: self.url)
    }
    
    var body: some View {
        if let imageData = self.imageDownloader.downloadData {
            let img = UIImage(data: imageData)
            return VStack {
                Image(uiImage: img!).resizable()
            }
        } else {
            return VStack {
                Image(uiImage: UIImage(systemName: "icloud.and.arrow.down")!).resizable()
            }
        }
    }
}
