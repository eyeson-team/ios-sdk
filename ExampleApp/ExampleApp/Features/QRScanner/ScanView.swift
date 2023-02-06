//
//  ScanView.swift
//  ExampleApp
//
//  Created by Michael Maier on 16.12.21.
//

import AVFoundation
import UIKit
import SwiftUI

struct ScanView: UIViewControllerRepresentable {
        
    private let scannerViewController = ScanViewController()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func start(completion: @escaping (String)->()) {
        scannerViewController.start(completion: completion)
    }
    
    func stop() {
        scannerViewController.stop()
    }
}

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    private var completion: ((String)->())?
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var dispatchQueue: DispatchQueue = DispatchQueue.global(qos: .userInteractive)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: dispatchQueue)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }
    
    func start(completion: @escaping (String)->()) {
        self.completion = completion
        dispatchQueue.async {
            self.captureSession?.startRunning()
        }
    }
    
    func stop() {
        dispatchQueue.async {
            self.captureSession?.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            completion?(stringValue)
            return
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
