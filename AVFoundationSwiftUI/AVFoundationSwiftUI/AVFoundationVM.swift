//
//  AVFoundationVM.swift
//  AVFoundationSwiftUI
//
//  Created by 藤　治仁 on 2020/01/02.
//  Copyright © 2020 FromF.github.com. All rights reserved.
//

import UIKit
import Combine
import AVFoundation

class AVFoundationVM: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, ObservableObject {
    ///撮影した画像
    @Published var image: UIImage?
    ///プレビュー用レイヤー
    var previewLayer:CALayer!
    ///顔の位置
    @Published var faceRect: CGRect = CGRect.zero
    ///顔認識した元画像のサイズ
    @Published var imageSize: CGSize = CGSize.zero
    
    ///撮影開始フラグ
    private var _takePhoto:Bool = false
    ///セッション
    private let captureSession = AVCaptureSession()
    ///撮影デバイス
    private var capturepDevice:AVCaptureDevice!
    ///顔認識
    ///CIDetectorAccuracyHighだと高精度（使った感じは遠距離による判定の精度）だが処理が遅くなる
    private let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options:[CIDetectorAccuracy: CIDetectorAccuracyLow] )!
    
    override init() {
        super.init()
        
        prepareCamera()
        beginSession()
    }
    
    func takePhoto() {
        _takePhoto = true
    }
    
    private func prepareCamera() {
        captureSession.sessionPreset = .photo
        
        if let availableDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices.first {
            capturepDevice = availableDevice
        }
    }
    
    private func beginSession() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: capturepDevice)
            
            captureSession.addInput(captureDeviceInput)
        } catch {
            print(error.localizedDescription)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer = previewLayer
//        captureSession.startRunning()
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32BGRA]
        
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }
        
        captureSession.commitConfiguration()
        
        let queue = DispatchQueue(label: "FromF.github.com.AVFoundationSwiftUI.AVFoundation")
        dataOutput.setSampleBufferDelegate(self, queue: queue)
    }
    
    func startSession() {
        if captureSession.isRunning { return }
        captureSession.startRunning()
    }
    
    func endSession() {
        if !captureSession.isRunning { return }
        captureSession.stopRunning()
    }
    
    // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if _takePhoto {
            _takePhoto = false
            if let image = getImageFromSampleBuffer(buffer: sampleBuffer) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        } else {
            if let image = getImageFromSampleBuffer(buffer: sampleBuffer) ,
                let ciImage = CIImage(image: image) {
                let faces = self.detector.features(in: ciImage)
                if let face = faces.first {
                    DispatchQueue.main.async {
                        // 座標変換
                        self.faceRect = face.bounds
                        // UIKitは左上に原点があるが、CoreImageは左下に原点があるので揃える
                        self.faceRect.origin.y = ciImage.extent.size.height - self.faceRect.origin.y - self.faceRect.size.height
                        // 顔認識に使った画像サイズを保持する
                        self.imageSize = ciImage.extent.size
                    }
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
