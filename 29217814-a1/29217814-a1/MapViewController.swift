//
//  MapViewController.swift
//  29217814-week5
//
//  Created by Zoe on 3/9/20.
//  Copyright © 2020 Qixin HE. All rights reserved.
//
//reference:https://stackoverflow.com/questions/41469459/can-i-assign-different-images-to-every-pin-in-the-map
//thought not working...

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
    //var mapView:MKMapViewDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //week4 lab +
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        //let exhibitions = databaseController.fetchAllExhibition()
        
        mapView.delegate = self
        mapView.register(LocationAnnotationView.self, forAnnotationViewWithReuseIdentifier: LocationAnnotationView.reuseIdentifier)
        mapView.register(LocationAnnotationSetImageView.self, forAnnotationViewWithReuseIdentifier: LocationAnnotationSetImageView.reuseIdentifier)
        
        let location = LocationAnnotation(title: "The Garden", subtitle: "Best garden.", lat: -37.8299924, long: 144.9806000,img:nil)
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
        
        mapView.showsUserLocation = true
        
    }
    func onExhibitionChange(change: DatabaseChange, exhibitions : [Exhibition])  {
        if locationList.count != 0 {
            mapView.removeAnnotations(locationList)
            locationList.removeAll()
        }
        
        for oneExibition:Exhibition in exhibitions
        {
            let lat = oneExibition.lat
            let long = oneExibition.long
            let title = oneExibition.name!
            let subtitle = oneExibition.exhibitionDescription!
            if let imgurl = oneExibition.img {
                let location = LocationAnnotation(title: title , subtitle: subtitle, lat: lat, long: long,img:imgurl)
                locationList.append(location)
                mapView.addAnnotation(location)
            }
                else {
                let location = LocationAnnotation(title: title , subtitle: subtitle, lat: lat, long: long,img:nil)
                locationList.append(location)
                mapView.addAnnotation(location)
            }
            
            
            
            
            
            
            
            
            //            if oneExibition.img != nil {
            //                           let imageURL = URL(string: (oneExibition.img!))
            //                           let imageTask = URLSession.shared.dataTask(with:imageURL!){
            //                               (data,response, error)in
            //                            if error != nil{
            //                                   return
            //                               }
            //
            //                               DispatchQueue.main.async{
            //                                   location.image = UIImage(data: data!)
            //                                //self.mapView.addAnnotation(location)
            //                                let annotationView = MKAnnotationView.init(annotation: location, reuseIdentifier: "imagedAnnotation")
            //                                           if location.image != nil {
            //                                            annotationView.image = location.image
            //                                            self.mapView.register(nil, forAnnotationViewWithReuseIdentifier: "imagedAnnotation")
            //                                }
            //
            //                               }
            //                           }
            //                           imageTask.resume()
            //
            //            }else{
            //                mapView.addAnnotation(location)
            //            }
            
            
            //            let annotationView = mapView.view(for: location)
            //            if location.image != nil {
            //                annotationView?.image = location.image}
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
        mapView.showsUserLocation = true
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

extension MapViewController:MKMapViewDelegate{
//

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
               let identifier: String

               switch annotation {
               case is LocationAnnotationView:   identifier = LocationAnnotationView.reuseIdentifier
               case is LocationAnnotationSetImageView: identifier = LocationAnnotationSetImageView.reuseIdentifier
               default:                  return nil
               }

               return mapView.dequeueReusableAnnotationView(withIdentifier: identifier, for: annotation)
           }
    
}
extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

