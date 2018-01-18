//
//  CameraController.swift
//  FindMyFace
//
//  Created by Developer on 10/31/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraControllerDelegate: class {
    
    func didTakePhoto(_ photo: UIImage)
}

class CameraController: NSObject, AVCapturePhotoCaptureDelegate {
    
    // MARK: - Properties
    private var cameraPreviewView: UIView
    private var captureSession: AVCaptureSession?
    private var capturePhotoOutput: AVCapturePhotoOutput?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    weak var delegate: CameraControllerDelegate?
    
    // MARK: - Lifecycle
    init(with view: UIView) {
        cameraPreviewView = view
        
        super.init()
        
        setup()
    }
    
    // MARK: - Public
    func capture() {
        let settings = AVCapturePhotoSettings()
        
        capturePhotoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    // MARK: - Private
    private func setup() {
        
        // Setup camera
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .photo
        
        // Get the back camera
        let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        
        // Input device
        var inputDevice: AVCaptureDeviceInput!
        inputDevice = try? AVCaptureDeviceInput(device: backCamera!)
        captureSession?.addInput(inputDevice!)
        
        // Output device
        capturePhotoOutput = AVCapturePhotoOutput()
        captureSession?.addOutput(capturePhotoOutput!)
        
        // Add Preview
        guard let session = captureSession else {
            return
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        videoPreviewLayer?.frame = cameraPreviewView.layer.bounds
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.connection?.videoOrientation = .portrait
        cameraPreviewView.layer.addSublayer(videoPreviewLayer!)
        
        // Start the session
        captureSession?.startRunning()
    }
    
    // MARK: - Capture Photo Delegate
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let image = UIImage(data: photo.fileDataRepresentation()!)
        
        if let image = image?.fixedOrientation() {
            // Alert that an image was added
            delegate?.didTakePhoto(image)
        }
        
        // Create the image view
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFill
        view.frame = cameraPreviewView.bounds
        
        // Add the image
        cameraPreviewView.addSubview(view)
    }
    
    deinit {
        captureSession?.stopRunning()
    }
}
