//
//  EditProfileViewController.swift
//  2Q
//
//  Created by Sterling Gamble on 12/3/20.
//

import UIKit
import Parse

class EditProfileViewController: UIViewController {
    @IBOutlet weak var defaultPhotoView: UIView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var firstnameField: UITextField!
    @IBOutlet weak var lastnameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = PFUser.current()!
        usernameField.text = user.username
        firstnameField.text = user["firstName"] as? String
        lastnameField.text = user["lastName"] as? String
        emailField.text = user.email
        passwordField.text = user.password
        
        saveButton.layer.cornerRadius = 8
        defaultPhotoView.layer.cornerRadius = defaultPhotoView.bounds.width / 2
    }
    
    @IBAction func onSaveChanges(_ sender: Any) {
        
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
