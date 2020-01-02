//
//  AVFoundationView.swift
//  AVFoundationSwiftUI
//
//  Created by 藤　治仁 on 2020/01/02.
//  Copyright © 2020 FromF.github.com. All rights reserved.
//

import SwiftUI
import UIKit
import AVFoundation

struct AVFoundationView: UIViewControllerRepresentable {
    ///撮影した画像
    @Binding var image: UIImage?
    ///撮影開始フラグ
    @Binding var takePhoto:Bool
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<AVFoundationView>) -> UIViewController {
        let viewController = UIViewController()
        let captureSession = AVCaptureSession()
        
        captureSession.sessionPreset = .photo
        if let availableDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices.first {
            let capturepDevice = availableDevice
            
            do {
                let captureDeviceInput = try AVCaptureDeviceInput(device: capturepDevice)
                
                captureSession.addInput(captureDeviceInput)
            } catch {
                print(error.localizedDescription)
            }
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            viewController.view.layer.addSublayer(previewLayer)
            previewLayer.frame = viewController.view.layer.frame
            captureSession.startRunning()
            
            let dataOutput = AVCaptureVideoDataOutput()
            dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32BGRA]
            
            if captureSession.canAddOutput(dataOutput) {
                captureSession.addOutput(dataOutput)
            }
            
            captureSession.commitConfiguration()
            
            let queue = DispatchQueue(label: "FromF.github.com.AVFoundationSwiftUI.AVFoundation")
            dataOutput.setSampleBufferDelegate(context.coordinator, queue: queue)
        }

        return viewController
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(image: $image, takePhoto: $takePhoto)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<AVFoundationView>) {
        if let previewLayer = uiViewController.view.layer.sublayers?.last {
            previewLayer.frame = uiViewController.view.layer.frame
        }
    }
    
    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        ///撮影した画像
        @Binding var image: UIImage?
        ///撮影開始フラグ
        @Binding var takePhoto:Bool
        
        init(image: Binding<UIImage?>, takePhoto: Binding<Bool>) {
            _image = image
            _takePhoto = takePhoto
        }
        
        // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            if takePhoto {
                takePhoto = false
                
                if let image = getImageFromSampleBuffer(buffer: sampleBuffer) {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
            
            
        }
        
        private func getImageFromSampleBuffer (buffer: CMSampleBuffer) -> UIImage? {
            if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
                let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
                let context = CIContext()
                
                let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
                
                if let image = context.createCGImage(ciImage, from: imageRect) {
                    return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
                }
            }
            
            return nil
        }
    }
}
