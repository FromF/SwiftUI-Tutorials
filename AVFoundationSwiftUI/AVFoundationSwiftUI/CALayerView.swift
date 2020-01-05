//
//  CALayerView.swift
//  AVFoundationSwiftUI
//
//  Created by 藤　治仁 on 2020/01/02.
//  Copyright © 2020 FromF.github.com. All rights reserved.
//

import SwiftUI

struct CALayerView: UIViewControllerRepresentable {
    var caLayer:CALayer
    @Binding var faceRect:CGRect
    @Binding var imageSize: CGSize
    private let rectView = UIView()
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CALayerView>) -> UIViewController {
        let viewController = UIViewController()
        
        viewController.view.layer.addSublayer(caLayer)
        caLayer.frame = viewController.view.layer.frame
        
        //顔枠用
        rectView.layer.borderWidth = 3//四角い枠を用意しておく
        rectView.layer.borderColor = UIColor.red.cgColor
        viewController.view.addSubview(self.rectView)
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<CALayerView>) {
        caLayer.frame = uiViewController.view.layer.frame
        
        if faceRect != CGRect.zero &&
            imageSize != CGSize.zero {
            if let rectView = uiViewController.view.subviews.first {
                //顔認識結果を顔枠として表示する
                // 座標変換
                let widthPer = uiViewController.view.bounds.width/imageSize.width
                let heightPer = uiViewController.view.bounds.height/imageSize.height
                
                rectView.frame = CGRect(x: faceRect.origin.x * widthPer,
                                        y: faceRect.origin.y * heightPer,
                                        width: faceRect.size.width * widthPer,
                                        height: faceRect.size.height * heightPer)
            }
        }
    }
}
