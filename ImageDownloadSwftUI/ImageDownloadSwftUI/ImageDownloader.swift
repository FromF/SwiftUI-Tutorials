//
//  ImageDownloader.swift
//  ImageDownloadSwftUI
//
//  Created by 藤治仁 on 2019/12/23.
//  Copyright © 2019 F-Works. All rights reserved.
//

import Foundation

class ImageDownloader : ObservableObject {
    @Published var downloadData: Data? = nil
    
    func downloadImage(url: String) {
        
        guard let imageURL = URL(string: url) else { return }
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: imageURL)
            DispatchQueue.main.async {
                self.downloadData = data
            }
        }
    }
}
