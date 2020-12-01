//
//  QueueNameCell.swift
//  2Q
//
//  Created by Sterling Gamble on 11/21/20.
//

import UIKit

class QueueNameCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var actionButton: UIButton!
    
    var action: Action?
    var queue: Queue?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        actionButton.layer.cornerRadius = 5
    }

    @IBAction func onAction(_ sender: Any) {
        if action == .start {
            queue?.start()
            actionButton.setTitle("End", for: .normal)
            actionButton.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
            actionButton.setTitleColor(#colorLiteral(red: 0.7921568627, green: 0.1215686275, blue: 0.1215686275, alpha: 1), for: .normal)
            action = .end
        } else if action == .end {
            queue?.end()
            actionButton.setTitle("Start", for: .normal)
            actionButton.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.7921568627, blue: 0.6980392157, alpha: 1)
            actionButton.setTitleColor(UIColor.white, for: .normal)
            action = .start
        }
    }
    
    @IBAction func onSave(_ sender: Any) {
        queue?.save()
        saveButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}


