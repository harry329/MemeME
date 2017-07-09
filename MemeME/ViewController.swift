//
//  ViewController.swift
//  MemeME
//
//  Created by Harsimran Singh on 7/6/17.
//  Copyright © 2017 HarsimranSingh. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func cameraImagePicker(_ sender: Any) {
        if UIImagePickerController.isCameraDeviceAvailable(.rear) {
        let cameraPicker = UIImagePickerController()
        cameraPicker.sourceType = .camera
        cameraPicker.delegate = self
        self.present(cameraPicker, animated: true, completion: nil)
        } else {
            print("camera Not available")
        }
    }
    
    
    @IBAction func albumImagePicker(_ sender: Any) {
        let albumPicker = UIImagePickerController()
        albumPicker.sourceType = .photoLibrary
        albumPicker.delegate = self
        self.present(albumPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imageO = info[UIImagePickerControllerOriginalImage] {
            imageView.image = imageO as! UIImage
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel")
        dismiss(animated: true, completion: nil)
        
    }
}


