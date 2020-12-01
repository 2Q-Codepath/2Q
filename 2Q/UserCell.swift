//
//  UserCell.swift
//  2Q
//
//  Created by Sterling Gamble on 11/28/20.
//

import UIKit
import Parse

class UserCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var defaultImageView: UIView!
    @IBOutlet weak var photoView: UIImageView!
    
    var user: PFUser?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        defaultImageView.layer.cornerRadius = defaultImageView.bounds.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
