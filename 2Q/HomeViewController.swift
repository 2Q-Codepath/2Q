//
//  HomeViewController.swift
//  2Q
//
//  Created by Xavier Loera Flores on 11/12/20.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    let searchBar = UISearchBar()
    
    var myQueues = [PFObject]()
    var savedQueues: [PFObject]?
    var followedQueues: [PFObject]?
    var sections = [String: [PFObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumInteritemSpacing = 15
        layout.itemSize = CGSize(width: 346, height: 310)
        
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Search queues or users"
        navigationItem.titleView = searchBar
                
        // Do any additional setup after loading the view.
        loadHosting()
        loadQueuing()
        loadSaved()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        self.present(UINavigationController(rootViewController: SearchViewController()), animated: true, completion: nil)
        self.performSegue(withIdentifier: "SearchSegue", sender: nil)
    }
    
    func loadHosting() {
        let query = PFQuery(className: "Queue")
        query.whereKey("host", equalTo: PFUser.current()!)
        query.whereKey("live", equalTo: true)
        query.includeKey("host")
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if objects != nil {
                self.sections["Hosting"] = objects
                self.collectionView.reloadData()
                print(self.sections)
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    
    func loadQueuing() {
        let query = PFQuery(className: "Queuer")
        query.whereKey("user", equalTo: PFUser.current()!)
        query.includeKeys(["queue", "queue.host"])
        query.selectKeys(["queue"])
        query.findObjectsInBackground { (objects: [PFObject]?, error) in
            if objects!.count > 0 {
                var queues = [PFObject]()
                for object in objects! {
                    let queue = object["queue"] as? PFObject
                    queues.append(queue!)
                }
                self.sections["Queuing"] = queues
                self.collectionView.reloadData()
            } else {
                print("No Queuer Queues")
                print(error?.localizedDescription)
            }
        }
    }
    
    func loadSaved() {
        let query = PFQuery(className: "Saved")
        query.whereKey("user", equalTo: PFUser.current()!)
        query.includeKeys(["queue", "queue.host"])
        query.selectKeys(["queue"])
        query.findObjectsInBackground { (objects: [PFObject]?, error) in
            if objects!.count > 0 {
                var queues = [PFObject]()
                for object in objects! {
                    let queue = object["queue"] as? PFObject
                    queues.append(queue!)
                }
                self.sections["Saved"] = queues
                self.collectionView.reloadData()
            } else {
                print("No Queuer Queues")
                print(error?.localizedDescription)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionCell", for: indexPath) as! SectionCell
        
        cell.layer.cornerRadius = 10
        cell.layer.shadowColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.16)
        cell.layer.shadowOpacity = 0.16
        cell.layer.shadowRadius = 6
        
        let key = Array(sections.keys)[indexPath.row]
        cell.sectionLabel.text = key
        cell.queues = sections[key]!
        
        return cell
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


