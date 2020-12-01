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
        loadQueues()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        self.present(UINavigationController(rootViewController: SearchViewController()), animated: true, completion: nil)
        self.performSegue(withIdentifier: "SearchSegue", sender: nil)
    }
    
    func loadQueues() {
        DispatchQueue.global(qos: .userInteractive).async {
            var results = [String: [PFObject]]()
            
            // load live hosting
            var query = PFQuery(className: "Queue")
            query.whereKey("host", equalTo: PFUser.current()!)
            query.whereKey("live", equalTo: true)
            query.includeKey("host")
            
            do {
                let objects = try query.findObjects()
                results["Hosting"] = objects
            } catch {
                print(error)
            }
            
            // load queuing
            query = PFQuery(className: "Queuer")
            query.whereKey("user", equalTo: PFUser.current()!)
            query.includeKeys(["queue", "queue.host"])
            query.selectKeys(["queue"])
            
            do {
                let objects = try query.findObjects()
                if !objects.isEmpty {
                    results["Queuing"] = []
                    for object in objects {
                        let queue = object["queue"] as? PFObject
                        results["Queuing"]?.append(queue!)
                    }
                }
            } catch {
                print(error)
            }
            
            // load live saved
            query = PFQuery(className: "Saved")
            query.whereKey("user", equalTo: PFUser.current()!)
            query.includeKeys(["queue", "queue.host"])
            query.selectKeys(["queue"])
            do {
                let objects = try query.findObjects()
                if !objects.isEmpty {
                    results["Saved"] = []
                    for object in objects {
                        let queue = object["queue"] as? PFObject
                        let live = queue?["live"] as? Bool
                        if live == true {
                            results["Saved"]?.append(queue!)
                        }
                    }
                }
            } catch {
                print(error)
            }
            
            DispatchQueue.main.async {
                self.sections = results
                self.collectionView.reloadData()
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


