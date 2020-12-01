//
//  QueueCollectionViewCell.swift
//  2Q
//
//  Created by Sterling Gamble on 11/23/20.
//

import UIKit

class QueueCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var noImageView: UIView!
    @IBOutlet weak var photoVIew: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var hostView: UIView!
    @IBOutlet weak var defaultProfileImage: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var queue: Queue?
    var action: Action?
    
//    override class func awakeFromNib() {
//        super.awakeFromNib()
//
//
//    }
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
            countLabel.text = String(queue?.queuers?.count ?? 0)
        } else { // join
            queue?.join()
            actionButton.setTitle("Leave", for: .normal)
            actionButton.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
            actionButton.setTitleColor(#colorLiteral(red: 0.7921568627, green: 0.1215686275, blue: 0.1215686275, alpha: 1), for: .normal)
            action = .leave
            let count = queue?.queuers?.count
            let position = queue?.getPosition()
            countLabel.text = "\(position) of \(count)"
        }
    }
    
    
}
