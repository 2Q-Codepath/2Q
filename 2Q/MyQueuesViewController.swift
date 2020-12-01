//
//  MyQueuesViewController.swift
//  2Q
//
//  Created by Sterling Gamble on 11/16/20.
//

import UIKit
import Parse
import AlamofireImage

class MyQueuesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var queues = [PFObject]() // all queues
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let index = segmentedControl.selectedSegmentIndex
        if index == 0 {
            loadMine()
        } else {
            loadSaved()
        }
        
    }
    @IBAction func indexChange(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                loadMine()
            case 1:
                loadSaved()
            default:
                break
        }
    }
    
    func loadMine() {
        DispatchQueue.global(qos: .userInteractive).async {
            var results = [PFObject]()
            
            var query = PFQuery(className: "Queue")
            query.whereKey("host", equalTo: PFUser.current()!)
            query.includeKey("host")
            
            do {
                let objects = try query.findObjects()
                results.append(contentsOf: objects)
            } catch {
                print(error)
            }
            
            query = PFQuery(className: "Queuer")
            query.whereKey("user", equalTo: PFUser.current()!)
            query.includeKeys(["queue", "queue.host"])
            query.selectKeys(["queue"])
            
            do {
                let objects = try query.findObjects()
                for object in objects {
                    let queue = object["queue"] as? PFObject
                    results.append(queue!)
                }
            } catch {
                print(error)
            }
            
            print(results)
            
            DispatchQueue.main.async {
                self.queues = results
                self.tableView.reloadData()
            }
 
        }
    
    }
    
    func loadSaved() {
        var saved = [PFObject]()
        let query = PFQuery(className: "Saved")
        query.whereKey("user", equalTo: PFUser.current()!)
        query.includeKeys(["queue", "queue.host"])
        query.selectKeys(["queue"])
        query.findObjectsInBackground { (objects: [PFObject]?, error) in
            if objects!.count > 0 {
                for object in objects! {
                    let queue = object["queue"] as? PFObject
                    saved.append(queue!)
                }
                self.queues = saved
            } else {
                print("No Queuer Queues")
                print(error?.localizedDescription)
            }
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queues.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let queue = Queue(queue: queues[indexPath.row])
        let cell = tableView.dequeueReusableCell(withIdentifier: "QueueTableViewCell") as! QueueTableViewCell
        
        // set up
        cell.queue = queue
        cell.nameLabel.text = queue.name
        cell.locationLabel.text = queue.location
        cell.usernameLabel.text = queue.host?.username
        cell.photoView.af.setImage(withURL: queue.imageURL!) // might cause crash if queue has no image
        
        let role = queue.role
        if role == .host && queue.live == true {
            cell.action = .end
            cell.actionButton.setTitle("End", for: .normal)
            cell.statusLabel.text = "Open"
            cell.statusLabel.textColor = #colorLiteral(red: 0.1215686275, green: 0.7921568627, blue: 0.6980392157, alpha: 1)
            cell.countLabel.text = String(queue.queuers!.count)
            cell.actionButton.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
            cell.actionButton.setTitleColor(#colorLiteral(red: 0.7921568627, green: 0.1215686275, blue: 0.1215686275, alpha: 1), for: .normal)
        } else if role == .host && queue.live == false {
            cell.action = .start
            cell.actionButton.setTitle("Start", for: .normal)
            cell.statusLabel.text = "Closed"
            cell.statusLabel.textColor = #colorLiteral(red: 0.7921568627, green: 0.1215686275, blue: 0.1215686275, alpha: 1)
            cell.countLabel.text = "0"
            cell.actionButton.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.7921568627, blue: 0.6980392157, alpha: 1)
            cell.actionButton.setTitleColor(UIColor.white, for: .normal)
        } else if role == .queuer {
            cell.action = .leave
            cell.actionButton.setTitle("Leave", for: .normal)
            cell.statusLabel.text = "Open"
            let count = queue.queuers?.count
            let position = queue.getPosition()
            cell.statusLabel.textColor = #colorLiteral(red: 0.1215686275, green: 0.7921568627, blue: 0.6980392157, alpha: 1)
            cell.countLabel.text = "\(position) of \(count)" 
        } else if role == .guest && queue.live == true {
            cell.action = .join
            cell.actionButton.setTitle("Join", for: .normal)
            cell.statusLabel.text = "Open"
            cell.statusLabel.textColor = #colorLiteral(red: 0.1215686275, green: 0.7921568627, blue: 0.6980392157, alpha: 1)
            cell.countLabel.text = String(queue.queuers!.count)
            cell.actionButton.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.7921568627, blue: 0.6980392157, alpha: 1)
            cell.actionButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            cell.action = Action.none
            cell.actionButton.isHidden = true
            cell.statusLabel.text = "Closed"
            cell.statusLabel.textColor = #colorLiteral(red: 0.7921568627, green: 0.1215686275, blue: 0.1215686275, alpha: 1)
            cell.countLabel.text = "0"
        }
        
        return cell
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        
        let cell = sender as! UITableViewCell
        let indexpath = tableView.indexPath(for: cell)!
        let queue = queues[indexpath.row]
        
        let queueViewController = segue.destination as! QueueViewController
        queueViewController.queue = Queue(queue: queue)
        
        tableView.deselectRow(at: indexpath, animated: true)
                    
        
        
    }
    

}
