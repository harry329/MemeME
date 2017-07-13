//
//  ViewController.swift
//  MemeME
//
//  Created by Harsimran Singh on 7/6/17.
//  Copyright © 2017 HarsimranSingh. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    let memetypeAttri :[String:Any] = [
        NSStrokeColorAttributeName: UIColor.white,
        NSForegroundColorAttributeName: UIColor.black,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyBoardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyBoardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    func keyboardWillShow(_ notification: NSNotification) {
       
        self.view.frame.origin.y -= getKeyboardHeight(notification: notification as Notification)
    }
    
    func getKeyboardHeight(notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as!NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self,name: NSNotification.Name.UIKeyboardWillShow,object:nil)
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
        shareButton.isEnabled = true
        topText.defaultTextAttributes = memetypeAttri
        
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let activityPresenter = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        self.present(activityPresenter, animated: true, completion: nil)
    }
    
    func save() {
        // Create the meme
        
        _ = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
    }

    func generateMemedImage() -> UIImage {
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    struct Meme {
        var topText : String
        var bottomText : String
        var originalImage : UIImage
        var memedImage : UIImage
    }
}


