//
//  QueueTableViewCell.swift
//  2Q
//
//  Created by Sterling Gamble on 11/21/20.
//

import UIKit

class QueueTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var hostView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var hostPhotoView: UIImageView!
    @IBOutlet weak var defaultProfileImage: UIView!
    
    var queue: Queue?
    var action: Action?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        photoView.layer.cornerRadius = 13
        countView.layer.cornerRadius = 10
        hostView.layer.cornerRadius = 6
        actionButton.layer.cornerRadius = 5
        defaultProfileImage.layer.cornerRadius = defaultProfileImage.bounds.width / 2
    }

    @IBAction func onAction(_ sender: Any) {
        if action == .start {
            queue?.start()
            actionButton.setTitle("End", for: .normal)
            actionButton.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
            actionButton.setTitleColor(#colorLiteral(red: 0.7921568627, green: 0.1215686275, blue: 0.1215686275, alpha: 1), for: .normal)
            statusLabel.text = "Open"
            statusLabel.textColor = #colorLiteral(red: 0.1215686275, green: 0.7921568627, blue: 0.6980392157, alpha: 1)
            action = .end
        } else if action == .end {
            queue?.end()
            actionButton.setTitle("Start", for: .normal)
            actionButton.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.7921568627, blue: 0.6980392157, alpha: 1)
            actionButton.setTitleColor(UIColor.white, for: .normal)
            action = .start
        } else if action == .leave {
            queue?.leave()
            actionButton.setTitle("Join", for: .normal)
            actionButton.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.7921568627, blue: 0.6980392157, alpha: 1)
            actionButton.setTitleColor(UIColor.white, for: .normal)
            action = .join
        } else { // join
            queue?.join()
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

enum Action {
    case start
    case end
    case join
    case leave
    case none
}
