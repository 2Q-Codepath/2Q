//
//  ExploreViewController.swift
//  2Q
//
//  Created by Joel Sejas on 11/19/20.
//
import UIKit
import MapKit
import Parse
import AlamofireImage

class ExploreViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate{

    @IBOutlet weak var ExploreMap: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var queue = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        
        //fix layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
               //layout.minimumLineSpacing = 5
               layout.minimumInteritemSpacing = 50

              // let width = (view.frame.size.width - layout.minimumInteritemSpacing*1)/2
             //  layout.itemSize = CGSize(width: width, height: width*1/2)

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, error) in
            
            if response == nil
            {
                print("search error")
            }
            else
            {
                //remove annotations
                let annotations = self.ExploreMap.annotations
                self.ExploreMap.removeAnnotations(annotations)
                //get data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                //add new annotation
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.ExploreMap.addAnnotation(annotation)
                //zoom-in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.ExploreMap.setRegion(region, animated: true)
                
            }
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let query = PFQuery(className:"Queue")

       //query.limit = 4        //synch with map

       query.findObjectsInBackground { (queue, error) in
            if queue != nil {
                self.queue = queue!
                self.collectionView.reloadData()
            }
        }
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return queue.count
     }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let queueInt = queue[indexPath.item]//move around
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExploreQueueCell", for: indexPath) as! ExploreQueueCell


        

        cell.nameLabel.text = (queueInt["name"] as! String)
        cell.locationLabel.text = (queueInt["location"] as! String)

        let imageFile = queueInt["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        print(url)
        cell.queueImg.af_setImage(withURL: url)
        
        return cell
     }
}
