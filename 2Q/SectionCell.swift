//
//  SectionCell.swift
//  2Q
//
//  Created by Sterling Gamble on 11/23/20.
//

import UIKit
import Parse
import AlamofireImage

class SectionCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sectionLabel: UILabel!
    
    var queues = [PFObject]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 27
        layout.itemSize = CGSize(width: 209, height: 221)
        
        
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
    
    
    
}

enum SectionType {
    case mine
    case saved
    case followed
    case local
}
