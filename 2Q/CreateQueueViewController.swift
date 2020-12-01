//
//  CreateQueueViewController.swift
//  2Q
//
//  Created by Sterling Gamble on 11/8/20.
//

import UIKit
import AlamofireImage
import Parse

class CreateQueueViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addImageView: UIView!
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Corner Radius
        nameField.layer.cornerRadius = 8
        locationField.layer.cornerRadius = 8
        descriptionField.layer.cornerRadius = 8
        addImageView.layer.cornerRadius = 8
        imageView.layer.cornerRadius = 8
        createButton.layer.cornerRadius = 6
        
        // Field Padding
        nameField.setPadding(19)
        locationField.setPadding(19)
        descriptionField.setPadding(19)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCreate(_ sender: Any) {
        let queue = PFObject(className: "Queue")
        
        queue["name"] = nameField.text!
        queue["location"] = locationField.text!
        queue["description"] = descriptionField.text!
        queue["host"] = PFUser.current()!
        queue["live"] = false
        
        let imageData = imageView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        
        queue["image"] = file
        
        queue.saveInBackground { (success, error) in
            if success {
                print("created!")
                self.performSegue(withIdentifier: "createSegue", sender: nil)
            } else {
                print("error!")
            }
        }
        
    }
    
    @IBAction func onAddImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    // Queue Object: name, location, description
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        imageView.image = image
        
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}

extension UITextField {
    
    func setPadding(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.rightView = paddingView
        
        self.leftViewMode = .always
        self.rightViewMode = .always
    }
}
