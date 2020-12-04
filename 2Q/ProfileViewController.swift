//
//  ProfileViewController.swift
//  2Q
//
//  Created by Sterling Gamble on 12/1/20.
//

import UIKit
import Parse
import AlamofireImage

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    // Header
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var defaultPhotoView: UIView!
    @IBOutlet weak var headerView: UIView!
    
    // Bottom
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var sectionView: UIView!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    
    
    var user = PFUser.current()
    var action: ProfileAction?
    var queues = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.layer.cornerRadius = 15
        defaultPhotoView.layer.cornerRadius = defaultPhotoView.bounds.width / 2
        actionButton.layer.cornerRadius = 6
        sectionView.layer.cornerRadius = 10
        editProfileButton.layer.cornerRadius = 6
        
        let firstName = user?["firstName"] as? String
        let lastName = user?["lastName"] as? String
        let name = firstName! + " " + lastName!
        
        usernameLabel.text = user?.username
        nameLabel.text = name
        
        // check if its the current user's profile
        if user?.objectId == PFUser.current()?.objectId {
            sectionLabel.text = "Settings"
            collectionView.isHidden = true
            actionButton.setTitle("Sign Out", for: .normal)
        } else {
            sectionLabel.text = "Queues"
            action = .follow
            actionButton.setTitle("Follow", for: .normal)
            editProfileButton.isHidden = true
            
            collectionView.delegate = self
            collectionView.dataSource = self
            
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            
            layout.minimumLineSpacing = 27
            layout.itemSize = CGSize(width: 209, height: 221)
            
            loadQueues()
        }
        
    }
    
    @IBAction func onAction(_ sender: Any) {
        if action == .logout {
            PFUser.logOut()
            
            let main = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = main.instantiateViewController(identifier: "SignInViewController")
            
            let scene = UIApplication.shared.connectedScenes.first
                    
            if let delegate : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                delegate.window?.rootViewController = loginViewController
            }
        
        } else if action == .follow {
            let follow = PFObject(className: "Follow")
            follow["user"] = user
            follow["follower"] = PFUser.current()
            follow.saveInBackground { (succeeded, error) in
                if succeeded {
                    self.actionButton.setTitle("Unfollow", for: .normal)
                    self.action = .unfollow
                    print("Followed")
                } else {
                    print(error?.localizedDescription)
                }
            }
            
        } else { // unfollow
            
        }
    }
    
//    @IBAction func editProfile(_ sender: Any) {
//        self.performSegue(withIdentifier: "EditProfileSegue", sender: nil)
//    }
    
    func loadQueues() {
        let query = PFQuery(className: "Queue")
        query.whereKey("host", equalTo: user!)
        query.includeKey("host")
        query.findObjectsInBackground { (objects, error) in
            if objects != nil {
                self.queues = objects!
                self.collectionView.reloadData()
            }
        }
    }
    
    func follows() {
        let query = PFQuery(className: "Follow")
        query.whereKey("follower", equalTo: PFUser.current()!)
        query.whereKey("user", equalTo: user!)
        query.findObjectsInBackground { (objects, error) in
            if objects != nil {
                self.actionButton.setTitle("Unfollow", for: .normal)
                self.action = .unfollow
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return queues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let queue = Queue(queue: queues[indexPath.row])
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QueueCollectionViewCell", for: indexPath) as! QueueCollectionViewCell
        
        cell.queue = queue
        cell.nameLabel.text = queue.name
        cell.locationLabel.text = queue.location
        cell.photoVIew.layer.cornerRadius = 13
        cell.photoVIew.af.setImage(withURL: queue.imageURL!)
        
        cell.actionButton.layer.cornerRadius = 5
        cell.countView.layer.cornerRadius = 10
        cell.noImageView.layer.cornerRadius = 13
        
        // host view
        cell.hostView.layer.cornerRadius = 6
        cell.defaultProfileImage.layer.cornerRadius = cell.defaultProfileImage.bounds.width / 2
        cell.hostView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cell.hostView.layer.shadowOpacity = 0.16
        cell.hostView.layer.shadowRadius = 6
        cell.usernameLabel.text = queue.host?.username
        
        let role = queue.role
        
        if role == .host {
            cell.action = .end
            cell.actionButton.setTitle("End", for: .normal)
            cell.statusLabel.text = "Open"
            cell.countLabel.text = String(queue.queuers!.count)
            cell.actionButton.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
            cell.actionButton.setTitleColor(#colorLiteral(red: 0.7921568627, green: 0.1215686275, blue: 0.1215686275, alpha: 1), for: .normal)
        } else if role == .queuer {
            cell.action = .leave
            cell.actionButton.setTitle("Leave", for: .normal)
            cell.statusLabel.text = "Open"
            let count = queue.queuers?.count
            let position = queue.getPosition()
            cell.countLabel.text = "\(position) of \(count)"
        } else if role == .guest {
            cell.action = .join
            cell.actionButton.setTitle("Join", for: .normal)
            cell.statusLabel.text = "Open"
            cell.countLabel.text = String(queue.queuers!.count)
            cell.actionButton.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.7921568627, blue: 0.6980392157, alpha: 1)
            cell.actionButton.setTitleColor(UIColor.white, for: .normal)
        }
        
        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "QueueSegue" {
            let cell = sender as! UICollectionViewCell
            let indexpath = collectionView.indexPath(for: cell)!
            let queue = queues[indexpath.row]
            
            let queueViewController = segue.destination as! QueueViewController
            queueViewController.queue = Queue(queue: queue)
            collectionView.deselectItem(at: indexpath, animated: true)
        }
        
    }


}

enum ProfileAction {
    case logout
    case follow
    case unfollow
}
