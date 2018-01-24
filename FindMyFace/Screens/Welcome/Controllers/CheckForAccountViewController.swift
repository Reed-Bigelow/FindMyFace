//
//  CheckForAccountViewController.swift
//  FindMyFace
//
//  Created by Developer on 10/31/17.
//  Copyright © 2017 Reed Bigelow. All rights reserved.
//

import UIKit
import SVProgressHUD

class CheckForAccountViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var cameraPreviewView: UIView!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var welcomeMessageLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - Properties
    private var cameraConroller: CameraController?
    private var capturedImage: UIImage?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    // MARK: - Private
    func setup() {
        cameraConroller = CameraController(with: cameraPreviewView)
        cameraConroller?.delegate = self
    }
    
    // MARK: - Actions
    @IBAction func captureButton(_ sender: Any) {
        cameraConroller?.capture()
    }
    
    @IBAction func submitButton(_ sender: Any) {
        SVProgressHUD.show()
        
        guard let image = capturedImage else {
            return
        }
        
        RestClientService.uploadData(with: image, .searchUsername) { _, rawJson in
            if let json = rawJson,
                (json["success"] as? Bool) == true,
                let id = (json["user"] as? String),
                let vC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() {
                UserDefaults.setValue(id, forKey: .id)
                
                SVProgressHUD.showSuccess(withStatus: "Welcome back")
                
                self.present(vC, animated: true)
            } else {
                print(rawJson)
            }
        }
    }
}
extension CheckForAccountViewController: CameraControllerDelegate {
    
    func didTakePhoto(_ photo: UIImage) {
        capturedImage = photo
    }
}
