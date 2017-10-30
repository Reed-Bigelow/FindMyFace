//
//  NewPostCameraViewController.swift
//  FindMyFace
//
//  Created by Developer on 10/25/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import AVFoundation
import UIKit

class NewPostCameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var cameraPreviewView: UIView!
    
    // MARK: - Properties
    private var captureSession: AVCaptureSession?
    private var capturePhotoOutput: AVCapturePhotoOutput?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
//        setup()
    }
    
    // MARK: - Private
    private func setup() {
        
        // Setup camera
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .photo
        
        // Get the back camera
        let backCamera = AVCaptureDevice.default(for: .video)
        
        // Input device
        var inputDevice: AVCaptureDeviceInput!
        inputDevice = try? AVCaptureDeviceInput(device: backCamera!)
        captureSession?.addInput(inputDevice!)
        
        // Output device
        capturePhotoOutput = AVCapturePhotoOutput()
        captureSession?.addOutput(capturePhotoOutput!)
        
        // Add Preview
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.frame = cameraPreviewView.layer.frame
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.connection?.videoOrientation = .portrait
        cameraPreviewView.layer.addSublayer(videoPreviewLayer!)
        
        // Start the session
        captureSession?.startRunning()
    }
    
    // MARK: - Actions
    @IBAction func captureImage(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        
        capturePhotoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    // MARK: - Capture Photo Delegate
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let image = UIImage(cgImage: (photo.cgImageRepresentation()?.takeRetainedValue())!, scale: 1.0, orientation: UIImageOrientation.right)
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFill
        view.frame = cameraPreviewView.frame
        cameraPreviewView.addSubview(view)
    }
    
    deinit {
        captureSession?.stopRunning()
    }
}
