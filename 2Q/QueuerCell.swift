//
//  QueuerCell.swift
//  2Q
//
//  Created by Sterling Gamble on 11/21/20.
//

import UIKit
import Parse

class QueuerCell: UITableViewCell {
    @IBOutlet weak var seeAllButton: UIButton!
    @IBOutlet weak var hostCountView: UIView!
    @IBOutlet weak var hostCountLabel: UILabel!
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var defaultPhotoView: UIView!
    
    @IBOutlet weak var queuerView: UIView!
    @IBOutlet weak var guestCountView: UIView!
    @IBOutlet weak var guestCountLabel: UILabel!
    @IBOutlet weak var guestCountIcon: UIImageView!
    
    var queue: Queue?
    var action: QueueCellAction?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        hostCountView.layer.cornerRadius = 8
        queuerView.layer.cornerRadius = 10
        actionButton.layer.cornerRadius = 5
        defaultPhotoView.layer.cornerRadius = defaultPhotoView.bounds.width / 2
        guestCountView.layer.cornerRadius = 8
        
        // Live Data Timer
//        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { (timer) in
////            DispatchQueue.global(qos: .userInteractive).async {
//                let query = PFQuery(className: "Queuer")
//                query.whereKey("queue", equalTo: self.queue)
////                let queuers: [PFObject]?
//
//                query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
//                    if objects != nil {
//                        print(objects?.count)
//                        self.countLabel.text = String(objects?.count ?? 0)
//                    }
//                }
//
////            }
//        }
        // fetch queuers
    }

    @IBAction func onAction(_ sender: Any) {
        if action == .checkin {
            let object = (queue?.queue)!
            var queuer = (queue?.fetchQueuers(queue: object).first)!
            queue?.checkIn(user: queuer)
            queuer = queue?.fetchQueuers(queue: object).first ?? PFUser()
            // if error is return "user no longer in queue"
            // if success update queuer full name, user name, and profile picture
            let firstName = queuer["firstName"] as? String
            let lastName = queuer["lastName"] as? String
            let name = firstName! + " " + lastName!
            fullNameLabel.text = name
            usernameLabel.text = queuer.username
            
        } else if action == .leave {
            queue?.leave()
            // update button
            actionButton.setTitle("Join", for: .normal)
            actionButton.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.7921568627, blue: 0.6980392157, alpha: 1)
            actionButton.setTitleColor(UIColor.white, for: .normal)
            action = .join
        } else {
            queue?.join()
            // update button if successful
            actionButton.setTitle("Leave", for: .normal)
            actionButton.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
            actionButton.setTitleColor(#colorLiteral(red: 0.7921568627, green: 0.1215686275, blue: 0.1215686275, alpha: 1), for: .normal)
            action = .leave
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

enum QueueCellAction {
    case checkin
    case join
    case leave
}
