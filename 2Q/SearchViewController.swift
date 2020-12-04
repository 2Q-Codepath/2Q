//
//  SearchViewController.swift
//  2Q
//
//  Created by Sterling Gamble on 11/27/20.
//

import UIKit
import Parse

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    let searchBar = UISearchBar()
    var results = [PFObject]()
    var queues = [PFObject]()
    var users = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.backgroundColor = .white
        
        searchBar.delegate = self
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let index = segmentedControl.selectedSegmentIndex
        
        if index == 0 {
            let query = PFQuery(className: "Queue")
            query.whereKey("name", matchesText: searchBar.text!)
            query.includeKey("host")
            query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                if objects != nil {
                    self.queues = objects!
                    self.tableView.rowHeight = 123
                    self.tableView.reloadData()
                } else {
                    print(error?.localizedDescription ?? "No matching queues")
                }
            }
        } else {
            let query = PFUser.query()
            query?.whereKey("username", equalTo: searchBar.text!)
            query?.findObjectsInBackground(block: { (objects, error) in
                if objects != nil {
                    self.users = objects!
                    self.tableView.rowHeight = 93
                    self.tableView.reloadData()
                } else {
                    print(error?.localizedDescription ?? "No matching users")
                }
            })
        }
        
    }
    @IBAction func indexChange(_ sender: Any) {
        let index = segmentedControl.selectedSegmentIndex
        if index == 0 {
            self.tableView.rowHeight = 123
        } else {
            self.tableView.rowHeight = 93
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let index = segmentedControl.selectedSegmentIndex
        if index == 0 {
            return queues.count
        }
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = segmentedControl.selectedSegmentIndex
        
        if index == 0 {
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
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
            
            let user = users[indexPath.row]
            let firstName = user["firstName"] as? String
            let lastName = user["lastName"] as? String
            let name = firstName! + " " + lastName!
            cell.nameLabel.text = name
            cell.usernameLabel.text = user["username"] as? String
//            cell.user = user
            
            return cell
            
        }
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let index = segmentedControl.selectedSegmentIndex
        if index == 0 {
            let cell = sender as! UITableViewCell
            let indexpath = tableView.indexPath(for: cell)!
            let queue = queues[indexpath.row]
            
            let queueViewController = segue.destination as! QueueViewController
            queueViewController.queue = Queue(queue: queue)
            
            tableView.deselectRow(at: indexpath, animated: true)
        }
        
        else {
            let cell = sender as! UITableViewCell
            let indexpath = tableView.indexPath(for: cell)!
            let user = users[indexpath.row]
            let profileViewController = segue.destination as! ProfileViewController
            profileViewController.user = user as? PFUser
            
            tableView.deselectRow(at: indexpath, animated: true)
        }
        
    }
    

}
