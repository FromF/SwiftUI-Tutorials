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

class AVFoundationVM: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, AVCapturePhotoCaptureDelegate, ObservableObject {
    ///撮影した画像
    @Published var image: UIImage?
    ///プレビュー用レイヤー
    var previewLayer:CALayer!
    
    ///セッション
    private let captureSession = AVCaptureSession()
    ///撮影デバイス
    private var capturepDevice:AVCaptureDevice!
    ///静止画撮影
    private var stillOutout: AVCapturePhotoOutput?

    override init() {
        super.init()
        
        prepareCamera()
        beginSession()
    }
    
    func takePhoto() {
        // 撮影設定
        let settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.flashMode = .off  // フラッシュのモード
        settingsForMonitoring.isHighResolutionPhotoEnabled = false  // 最高解像度で撮影するか否か

        // シャッターを切る
        stillOutout?.capturePhoto(with: settingsForMonitoring, delegate: self)
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
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32BGRA]
        
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }
        
        stillOutout = AVCapturePhotoOutput()
        
        if captureSession.canAddOutput(stillOutout!) {
            captureSession.addOutput(stillOutout!)
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
//        if let image = getImageFromSampleBuffer(buffer: sampleBuffer) {
//            DispatchQueue.main.async {
//                self.image = image
//            }
//        }
    }
    
    // MARK: - AVCapturePhotoCaptureDelegate
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let photoData = photo.fileDataRepresentation() {
            //UIImageに変換
            image = UIImage(data: photoData)
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
