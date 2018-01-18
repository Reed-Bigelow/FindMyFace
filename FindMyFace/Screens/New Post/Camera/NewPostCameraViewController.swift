//  NewPostCameraViewController.swift
//  FindMyFace
//
//  Created by Developer on 10/25/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import AVFoundation
import UIKit

protocol NewPostCameraViewControllerDelegate: class {
    
    func didTakePhoto(_ photo: UIImage)
}

class NewPostCameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var cameraPreviewView: UIView!
    
    // MARK: - Properties
    private var captureSession: AVCaptureSession?
    private var capturePhotoOutput: AVCapturePhotoOutput?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    weak var delegate: NewPostCameraViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
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
        videoPreviewLayer?.frame = cameraPreviewView.layer.frame
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.connection?.videoOrientation = .portrait
        cameraPreviewView.layer.addSublayer(videoPreviewLayer!)
        
        // Start the session
        captureSession?.startRunning()
    }
    
    // MARK: - Actions
    @IBAction func captureImage(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        
        capturePhotoOutput?.capturePhoto(with: settings, delegate: self)
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
        view.frame = cameraPreviewView.frame
        
        // Add the image
        cameraPreviewView.addSubview(view)
    }
    
    deinit {
        captureSession?.stopRunning()
    }
}
