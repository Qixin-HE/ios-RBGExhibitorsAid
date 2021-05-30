//
//  MapViewController.swift
//  29217814-week5
//
//  Created by Zoe on 3/9/20.
//  Copyright © 2020 Qixin HE. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, DatabaseListener, CLLocationManagerDelegate {
    
    var locationList = [LocationAnnotation]()
    //for geofence
    var geofence:CLCircularRegion?
    var locationManager: CLLocationManager = CLLocationManager()
    
    //for database
    weak var databaseController : DatabaseProtocol?
    var listenerType: ListenerType = .all
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //week4 lab +
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        //let exhibitions = databaseController.fetchAllExhibition()
        
        
        
        let location = LocationAnnotation(title: "The Garden", subtitle: "Best garden.", lat: -37.8299924, long: 144.9806000)
//        locationList.append(location)
//        mapView.addAnnotation(location)
//
//        location = LocationAnnotation(title: "Rose Pavilion", subtitle: "Is known for its expansive pink and white rose gardens.", lat: -37.8292136, long: 144.9792864)
//        locationList.append(location)
//        mapView.addAnnotation(location)
//
//        location = LocationAnnotation(title: "Bamboo Collection", subtitle: "Melbourne Gardens exhibits a broad range of Bamboo from different regions of the world across the entire site.", lat: -37.8304778, long: 144.9803291)
//        locationList.append(location)
//        mapView.addAnnotation(location)
//
//        location = LocationAnnotation(title: "Herb Garden", subtitle: "A wide range of herbs from well known leafy annuals.", lat: -37.8314259, long: 144.9793927)
//        locationList.append(location)
//        mapView.addAnnotation(location)
//
//        location = LocationAnnotation(title: "Viburnum Collection", subtitle: "Viburnums are shrubs with four seasons of interest.", lat: -37.8303428, long: 144.9828852)
//        locationList.append(location)
//        mapView.addAnnotation(location)
        
        
        //geofence
        geofence = CLCircularRegion(center: location.coordinate, radius: 450, identifier: "geofence")
        geofence?.notifyOnExit = true
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoring(for: geofence!)
        
        focusOn(annotation: location)
        
        
        
    }
    func onExhibitionChange(change: DatabaseChange, exhibition: [Exhibition]) {
        
        mapView.removeAnnotations(locationList)
            
        for oneExibition:Exhibition in exhibition
        {
            let lat = oneExibition.lat
            let long = oneExibition.long
            let title = oneExibition.name!
            let subtitle = oneExibition.exhibitionDescription!
            let location = LocationAnnotation(title: title , subtitle: subtitle, lat: lat, long: long)
            locationList.append(location)
            mapView.addAnnotation(location)
            
        }
    }
    
    func onPlantListChange(change: DatabaseChange, plants: [Plant]) {
        //do noting
    }
    func onExhibitionPlantsChange(change: DatabaseChange, plants: [Plant]) {
        //
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //databaseController?.addListener(listener: self,name:"???")
        databaseController?.addListener(listener: self)
    }
    
    //week4 lab +
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    func focusOn(annotation:MKAnnotation)
    {
        mapView.selectAnnotation(annotation, animated: true)
        
        let zoomRegion = MKCoordinateRegion(center:annotation.coordinate, latitudinalMeters: 700,longitudinalMeters:700)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
    }
    

    @IBAction func allexhibitionsView(_ sender: Any) {
        performSegue(withIdentifier: "allExhibitionsSegue", sender: editButton)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "allExhibitionsSegue"{
//            let destination = segue.destination as! AllExhibitionsTableViewController
//
//        }
//    }
    

}
