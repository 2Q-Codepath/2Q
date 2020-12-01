//
//  QueueViewController.swift
//  2Q
//
//  Created by Jonathan Naraja on 11/16/20.
//

import UIKit
import Parse
import AlamofireImage

class QueueViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var exitButtonVIew: UIView!
    @IBOutlet weak var hostView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var defaultProfileImgView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var queue: Queue?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Exit Button
        exitButtonVIew.layer.cornerRadius = exitButtonVIew.bounds.width / 2
        
        // Host View
        hostView.layer.cornerRadius = 6
        hostView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        hostView.layer.shadowOpacity = 0.16
        hostView.layer.shadowRadius = 6
        defaultProfileImgView.layer.cornerRadius = defaultProfileImgView.bounds.width / 2
        
        // Queue Data
        photoView.af.setImage(withURL: (queue?.imageURL)!)
        
        let host = queue?.host
        usernameLabel.text = host?.username
        
    }
    
    @IBAction func exit(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if queue?.role == .host {
            return 4
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Queue Page Sections
        if indexPath.row == 0 { // Queue Name Header
            let cell = tableView.dequeueReusableCell(withIdentifier: "QueueNameCell") as! QueueNameCell
            cell.nameLabel.text = queue?.name
            cell.queue = queue
            
            if queue?.saved == true {
                cell.saveButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            }
            
            if queue?.role == .host && queue?.live == true {
                cell.actionButton.setTitle("End Queue", for: .normal)
                cell.actionButton.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
                cell.actionButton.setTitleColor(#colorLiteral(red: 0.7921568627, green: 0.1215686275, blue: 0.1215686275, alpha: 1), for: .normal)
                cell.descriptionTextView.isHidden = true
                cell.action = .end
            } else if queue?.role == .host && queue?.live == false {
                cell.actionButton.setTitle("Start Queue", for: .normal)
                cell.actionButton.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.7921568627, blue: 0.6980392157, alpha: 1)
                cell.actionButton.setTitleColor(UIColor.white, for: .normal)
                cell.descriptionTextView.isHidden = true
                cell.action = .start
            } else {
                cell.actionButton.isHidden = true
                cell.descriptionTextView.text = queue?.description
            }
            return cell
        } else if indexPath.row == 1 { // Queuer Interaction Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "QueuerCell") as! QueuerCell
            cell.queue = queue
            
            if queue?.role == .host {
               
                if queue?.live == true {
                    let count = queue?.queuers?.count ?? 0
                    cell.hostCountLabel.text = String(count)
                    
                    if count > 0 {
                        let queuer = queue?.queuers?[0]
                        cell.usernameLabel.text = queuer?.username
                        let firstName = queuer?["firstName"] as? String
                        let lastName = queuer?["lastName"] as? String
                        let name = firstName! + " " + lastName!
                        cell.fullNameLabel.text = name
                    }
                }
                
                cell.action = .checkin
                cell.actionButton.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.7921568627, blue: 0.6980392157, alpha: 1)
                cell.actionButton.setTitleColor(UIColor.white, for: .normal)
                
                // hide
                cell.guestCountView.isHidden = true
                cell.guestCountIcon.isHidden = true
                cell.guestCountLabel.isHidden = true
            } else if queue?.role == .queuer {
                cell.action = .leave
                cell.actionButton.setTitle("Leave", for: .normal)
                cell.actionButton.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
                cell.actionButton.setTitleColor(#colorLiteral(red: 0.7921568627, green: 0.1215686275, blue: 0.1215686275, alpha: 1), for: .normal)
                
                let count = queue?.queuers?.count ?? 0
                let position = queue?.getPosition() ?? 0
                cell.guestCountLabel.text = "\(position) of \(count)"
                
                cell.hostCountView.isHidden = true
                cell.hostCountLabel.isHidden = true
                
                let queuer = PFUser.current()
                cell.usernameLabel.text = queuer?.username
                let firstName = queuer?["firstName"] as? String
                let lastName = queuer?["lastName"] as? String
                let name = firstName! + " " + lastName!
                cell.fullNameLabel.text = name
            } else {
                cell.action = .join
                cell.actionButton.setTitle("Join", for: .normal)
                cell.actionButton.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.7921568627, blue: 0.6980392157, alpha: 1)
                cell.actionButton.setTitleColor(UIColor.white, for: .normal)
                
                let count = queue?.queuers?.count
                cell.guestCountLabel.text = String(count ?? 0)
                cell.hostCountView.isHidden = true
                cell.hostCountLabel.isHidden = true
                
                let queuer = PFUser.current()
                cell.usernameLabel.text = queuer?.username
                let firstName = queuer?["firstName"] as? String
                let lastName = queuer?["lastName"] as? String
                let name = firstName! + " " + lastName!
                cell.fullNameLabel.text = name
                
                if queue?.live == false {
                    cell.actionButton.isHidden = true
                }
            }
            
            return cell
        } else if indexPath.row == 2 { // Location
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
            cell.addressLabel.text = queue?.location
            return cell
        } else { // Description
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell") as! DescriptionCell
            cell.textView.text = queue?.description
            return cell
        }
        
       
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            if queue?.role == .host {
                return 65
            }
            return 93 
        } else if indexPath.row == 2 {
            return 205
        }
        return 140
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "seeAllSegue" {
            let nav = segue.destination as! UINavigationController
            let queuersViewController = nav.topViewController as! QueuersViewController
            queuersViewController.queuers = queue?.queuers ?? []
        }
         
    }



}
