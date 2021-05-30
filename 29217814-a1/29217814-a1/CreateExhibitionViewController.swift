//
//  CreateExhibitionViewController.swift
//  29217814-a1
//
//  Created by Zoe on 18/9/20.
//  Copyright © 2020 Qixin HE. All rights reserved.
//

import UIKit
import MapKit

class CreateExhibitionViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate{
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
//    @IBOutlet weak var latTextField: UITextField!
//    @IBOutlet weak var longTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    weak var databaseController:DatabaseProtocol?
    var locationtapped:LocationAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.nameTextField.delegate = self
        self.descriptionTextField.delegate = self
//        self.latTextField.delegate = self
//        self.longTextField.delegate = self
        
        //week4 lab +
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        let location = LocationAnnotation(title: "The Garden", subtitle: "Best garden.", lat: -37.8299924, long: 144.9806000, img:nil)
        
        mapView.showsUserLocation = true
        //let userlocation = self.currentLocation
        //print(userlocation)
        focusOn(annotation: location)
        
        let singleTapRecognizer = UITapGestureRecognizer()
        singleTapRecognizer.delegate = self
        mapView.addGestureRecognizer(singleTapRecognizer)
        
    }
    
    func focusOn(annotation:MKAnnotation)
    {
        mapView.selectAnnotation(annotation, animated: true)
        
        let zoomRegion = MKCoordinateRegion(center:annotation.coordinate, latitudinalMeters: 700,longitudinalMeters:700)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
    }
    
    @IBAction func createExhibition(_ sender: Any) {
//        if nameTextField.text != "" && descriptionTextField.text != ""
//        && latTextField.text != "" && longTextField.text != ""{
//            let name = nameTextField.text!
//            let description = descriptionTextField.text!
//
//            guard let lat = Double(latTextField.text!)else {
//                return
//            }
//            guard let long = Double(longTextField.text!)else {
//                return
//            }
//
//
//            //week4 lab +
//            let _ = databaseController?.addExhibition(lat: lat, long: long, name: name, exhibitionDescription: description, img: nil, plants: nil)
//            //week4 lab -
//            //let _=superHeroDelegate?.addSuperHero(newHero: hero)
//
//            navigationController?.popViewController(animated: true )
//            return
//        }
//
//        var errorMsg = "Please ensure all fields are filled:\n"
//
//        if nameTextField.text == ""{
//            errorMsg += " - Must provide a name\n"
//        }
//        if descriptionTextField.text == ""{
//            errorMsg += "- Must provide an exhibition description\n"
//
//        }
//        displayMessage(title:"Not all fields filled", message:errorMsg)
        if nameTextField.text != "" && descriptionTextField.text != "" && locationtapped != nil
        {
            let name = nameTextField.text!
            let description = descriptionTextField.text!
            
            let lat = locationtapped!.coordinate.latitude
            let long = locationtapped!.coordinate.longitude
            
            
            //week4 lab +
            let _ = databaseController?.addExhibition(lat: lat, long: long, name: name, exhibitionDescription: description, img: nil, plants: nil)
            //week4 lab -
            //let _=superHeroDelegate?.addSuperHero(newHero: hero)
            let alertController = UIAlertController(title: "New exhibition added successfully!", message: "You can add plants to the new exhibition by edit it.", preferredStyle: UIAlertController.Style.alert)
            
            //https://stackoverflow.com/questions/38749312/why-doesnt-popviewcontroller-work-after-presentviewcontroller-on-alert
            let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action: UIAlertAction!) -> Void in
             self.navigationController!.popViewController(animated: true )
            }
            alertController.addAction(OKAction)
            
            self.present(alertController,animated: true, completion: nil)
            
            //navigationController?.popViewController(animated: true )
            
            return
        }
        
        var errorMsg = "Please complete all information fields\n"
        
        if nameTextField.text == ""{
            errorMsg += " - Must provide a name\n"
        }
        if descriptionTextField.text == ""{
            errorMsg += "- Must provide an exhibition description\n"
            
        }
        if locationtapped == nil{
            errorMsg += "- Please tap on the map to set a location\n"
        }
        displayMessage(title:"Not all information provided", message:errorMsg)
    }
    @IBAction func saveNewExhibition(_ sender: Any) {
//        let lat:Double?
//        let long:Double?
//        let name:String?
//        let description:String?
//        if nameTextField.text != "" && descriptionTextField.text != "" && locationtapped != nil
//        {
//            let name = nameTextField.text!
//            let description = descriptionTextField.text!
//
//            let lat = locationtapped!.coordinate.latitude
//            let long = locationtapped!.coordinate.longitude
//
//
//            //week4 lab +
//            let _ = databaseController?.addExhibition(lat: lat, long: long, name: name, exhibitionDescription: description, img: nil, plants: nil)
//            //week4 lab -
//            //let _=superHeroDelegate?.addSuperHero(newHero: hero)
//
//            navigationController?.popViewController(animated: true )
//            return
//        }
//
//        var errorMsg = "Please complete all information fields\n"
//
//        if nameTextField.text == ""{
//            errorMsg += " - Must provide a name\n"
//        }
//        if descriptionTextField.text == ""{
//            errorMsg += "- Must provide an exhibition description\n"
//
//        }
//        if locationtapped == nil{
//            errorMsg += "- Please tap on the map to set a location\n"
//        }
//        displayMessage(title:"Not all information provided", message:errorMsg)
        
//        if locationtapped != nil {
//            let lat = locationtapped!.coordinate.latitude
//            let long = locationtapped!.coordinate.longitude
//            }else{
//            displayMessage(title: "New exhibition location did not set", message: "Please tap on the map to set a location")
//        }
//        if nameTextField.text != "" {
//            let name = nameTextField.text!
//        }else{
//            displayMessage(title: "The name of the new exhibition have not set.", message: "Please enter a name.")
//        }
//
//        if descriptionTextField.text != "" {
//            let description = descriptionTextField.text!
//        }else{
//            displayMessage(title: "The description of the new exhibition have not set.", message: "Please enter a description.")
//        }
//
//        guard lat != nil && long != nil && name != nil && description != nil else{
//            return
//        }
//
//        let _ = databaseController?.addExhibition(lat: lat!, long: long!, name: name!, exhibitionDescription: description!, img: nil, plants: nil)
    }
    
//    //https://stackoverflow.com/questions/34768303/how-to-perform-action-when-user-taps-on-map-using-mapkit-swift
//    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
//
//        let annotationTap = UITapGestureRecognizer(target: self, action: "tapRecognized")
//        annotationTap.numberOfTapsRequired = 1
//        view.addGestureRecognizer(annotationTap)
//
//        let selectedAnnotations = mapView.selectedAnnotations
//
//        for annotationView in selectedAnnotations{
//            mapView.deselectAnnotation(annotationView, animated: true)
//        }
//    }
//
//    func tapRecognized(gesture:UITapGestureRecognizer){
//
//        let selectedAnnotations = mapView.selectedAnnotations
//
//        for annotationView in selectedAnnotations{
//            mapView.deselectAnnotation(annotationView, animated: true)
//        }
//    }

    //https://stackoverflow.com/questions/6449949/getting-current-location-of-map-on-touch-in-iphone-mkmapview
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if locationtapped != nil { mapView.removeAnnotation(locationtapped!)}
        for touch in touches {
            let touchPoint = touch.location(in: mapView)
            let location = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            //print ("\(location.latitude), \(location.longitude)")
            locationtapped = LocationAnnotation(title: "New Exhibtion Location", subtitle: "", lat: location.latitude, long: location.longitude,img:nil)
            mapView.addAnnotation(locationtapped!)
        }
    }
    
    
    
    func displayMessage(title:String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController,animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { textField.resignFirstResponder()
    return true
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
extension CreateExhibitionViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return !(touch.view is MKPinAnnotationView)
  }
}
