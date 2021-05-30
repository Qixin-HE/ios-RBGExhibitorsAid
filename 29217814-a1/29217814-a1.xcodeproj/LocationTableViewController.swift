//
//  LocationTableViewController.swift
//  29217814-week5
//
//  Created by Zoe on 3/9/20.
//  Copyright © 2020 Qixin HE. All rights reserved.
//

import UIKit
import MapKit

class LocationTableViewController: UITableViewController, NewLocationDelegate, CLLocationManagerDelegate {
    
    weak var mapViewController: MapViewController?
    var locationList = [LocationAnnotation]()
    //for geofence
    var geofence:CLCircularRegion?
    var locationManager: CLLocationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        var location = LocationAnnotation(title: "Princes Lawn", subtitle: "Is ideal for a garden ceremony.", lat: -37.8299924, long: 144.9793839)
        locationList.append(location)
        mapViewController?.mapView.addAnnotation(location)
        
        location = LocationAnnotation(title: "Rose Pavilion", subtitle: "Is known for its expansive pink and white rose gardens.", lat: -37.8292136, long: 144.9792864)
        locationList.append(location)
        mapViewController?.mapView.addAnnotation(location)
        
        location = LocationAnnotation(title: "Bamboo Collection", subtitle: "Melbourne Gardens exhibits a broad range of Bamboo from different regions of the world across the entire site.", lat: -37.8304778, long: 144.9803291)
        locationList.append(location)
        mapViewController?.mapView.addAnnotation(location)
        
        location = LocationAnnotation(title: "Herb Garden", subtitle: "A wide range of herbs from well known leafy annuals.", lat: -37.8314259, long: 144.9793927)
        locationList.append(location)
        mapViewController?.mapView.addAnnotation(location)
        
        location = LocationAnnotation(title: "Viburnum Collection", subtitle: "Viburnums are shrubs with four seasons of interest.", lat: -37.8303428, long: 144.9828852)
        locationList.append(location)
        mapViewController?.mapView.addAnnotation(location)
        
        //geofence
        geofence = CLCircularRegion(center: location.coordinate, radius: 500, identifier: "geofence")
        geofence?.notifyOnExit = true
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoring(for: geofence!)
        
        mapViewController?.focusOn(annotation: self.locationList[0])
    }
    
    //geofence
    override func viewWillAppear(_ animated:Bool){
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    

    /*
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exhibitionCell", for: indexPath)

        let annotation = self.locationList[indexPath.row]
        
        cell.textLabel?.text = annotation.title
        cell.detailTextLabel?.text = "Lat:\(annotation.coordinate.latitude)Long:\(annotation.coordinate.longitude)"
        

        return cell
    }
    
    override func tableView(_ tableView:UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath:IndexPath){
        if editingStyle == .delete{
            locationList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
  

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mapViewController?.focusOn(annotation: self.locationList[indexPath.row])
        if let mapVC = mapViewController{
            splitViewController?.showDetailViewController(mapVC, sender: nil)
        }
    }
    
    //geofence
    func locationManager(_ manager:CLLocationManager, didExitRegion region:CLRegion)
    {
        let alert = UIAlertController(title: "Movement Detected!", message: "you have left Manash Caulfield", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title:"OK",style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
*/
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "allExhibitionSegue" {
            let controller = segue.destination as! NewLocationViewController
            controller.delegate = self
        }
            
    }
    
    // MARK: - New Location Delegate
    func locationAnnotationAdded(annotation:LocationAnnotation){
        locationList.append(annotation)
        tableView.insertRows(at: [IndexPath(row:locationList.count - 1, section:0)], with: .automatic)
        mapViewController?.mapView.addAnnotation(annotation)
    }
 
    

}
