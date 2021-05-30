//
//  EditExhibitionViewController.swift
//  29217814-a1
//
//  Created by Zoe on 19/9/20.
//  Copyright © 2020 Qixin HE. All rights reserved.
//

import UIKit
import MapKit

class EditExhibitionViewController: UIViewController, UITextFieldDelegate,UITableViewDataSource, UITableViewDelegate, DatabaseListener, EditExhibitionDelegate{
    
    
    
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var plantTableView: UITableView!
    
    var exhibition:Exhibition?
    
    var allPlants:[Plant] = []
    
    weak var plantDelegate: AddPlantDelegate?
    weak var exhibitionDetailDelegate: EditExhibitionDetailDelegate?
    
    weak var databaseController : DatabaseProtocol?
    var listenerType: ListenerType = .all
    
    var plants:NSSet?
    
    var locationtapped:LocationAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.delegate = self
        self.descriptionTextField.delegate = self
        //        self.latTextField.delegate = self
        //        self.longTextField.delegate = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        nameTextField.text = exhibition?.name!
        descriptionTextField.text = exhibition?.exhibitionDescription!
        //        let lat = NumberFormatter.localizedString(from: exhibition?.lat as! NSNumber, number: .decimal)
        //        let long = NumberFormatter.localizedString(from: exhibition?.long as! NSNumber, number: .decimal)
        //let long:String = String(exhibition?.long)
        //        latTextField.text = lat
        //        longTextField.text = long
        
        plants = exhibition?.plants
        for plant:Plant in plants!.allObjects as! [Plant]{
            //print("\(plant.name)")
            allPlants.append(plant)
        }
        
        
        
        plantTableView.delegate = self
        plantTableView.dataSource = self
        
        let location = LocationAnnotation(title: "The Garden", subtitle: "Best garden.", lat: -37.8299924, long: 144.9806000,img:nil)
        
        focusOn(annotation: location)
        
        let exibitionAnnotation = LocationAnnotation(title: "Current Location Set", subtitle: "", lat: exhibition!.lat, long: exhibition!.long,img:nil)
        mapView.addAnnotation(exibitionAnnotation)
        mapView.showsUserLocation = true
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if allPlants.count != 0 {
            let plant = allPlants[indexPath.row]
            performSegue(withIdentifier: "plantDetailSegue", sender: plant)
        }
        tableView.deselectRow(at: indexPath, animated: false)
        return
    }
    
    func focusOn(annotation:MKAnnotation)
    {
        mapView.selectAnnotation(annotation, animated: true)
        
        let zoomRegion = MKCoordinateRegion(center:annotation.coordinate, latitudinalMeters: 700,longitudinalMeters:700)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if locationtapped != nil { mapView.removeAnnotation(locationtapped!)}
        for touch in touches {
            let touchPoint = touch.location(in: mapView)
            let location = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            //print ("\(location.latitude), \(location.longitude)")
            //https://stackoverflow.com/questions/6449949/getting-current-location-of-map-on-touch-in-iphone-mkmapview
            locationtapped = LocationAnnotation(title: "New Exhibtion Location", subtitle: "", lat: location.latitude, long: location.longitude,img:nil)
            mapView.addAnnotation(locationtapped!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //databaseController?.addListener(listener: self,name:exhibition!.name!)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated:Bool){
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allPlants.count == 0 {
            return 1
        }
        return allPlants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let plantCell = plantTableView.dequeueReusableCell(withIdentifier: "plantCell", for: indexPath) as! PlantTableViewCell
        if allPlants.count == 0 {
            plantCell.nameLabel!.text = "No plant information about this exhibition yet"
            plantCell.descriptionLabel!.text = "Want to add one? ↓"
            return plantCell
        }
        let plant = allPlants[indexPath.row]
        if let plantName:String = plant.name{
            plantCell.nameLabel!.text = plantName
        }
        else{
            plantCell.nameLabel.text! = "???"
        }
        
        if let plantDescription:String = plant.plantDescription{
            plantCell.descriptionLabel.text = plantDescription
        }
        else{
            plantCell.descriptionLabel.text = "???"
        }
        if plant.img == nil {
            //            let pic = UIImage(named:"No_image_available")
            //            plant.img = pic?.pngData()
            plantCell.imgView.image = UIImage(named:"No_image_available")
        }else{
            let imageURL = URL(string: (plant.img!))
            let imageTask = URLSession.shared.dataTask(with:imageURL!){
                (data,response, error)in
                if let error = error{
                    return
                }
                
                DispatchQueue.main.async{
                    plantCell.imgView.image = UIImage(data: data!)
                }
            }
            imageTask.resume()
        }
        
        //plantCell.descriptionLabel.text = plant.plantDescription!
        
        return plantCell
    }
    func displayMessage(title:String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController,animated: true, completion: nil)
    }
    @IBAction func saveEdit(_ sender: Any) {
//        let exibitionAnnotation = LocationAnnotation(title: "Current Location Set", subtitle: "", lat: exhibition!.lat, long: exhibition!.long)
        
        if nameTextField.text != "" && descriptionTextField.text != "" && locationtapped == nil
        {
            
            
            //             let lat = locationtapped!.coordinate.latitude
            //             let long = locationtapped!.coordinate.longitude
            if nameTextField.text == "" || descriptionTextField.text == ""{
                
                var errorMsg = "Please complete all information fields or nothing has changed\n"
                
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
                return
            }
        }
            
            
            
            
            if nameTextField.text != exhibition!.name || descriptionTextField.text != exhibition!.exhibitionDescription || locationtapped != nil{
//                let formerExhibition = Exhibition()
//                formerExhibition.name = exhibition.name
//                exhibition!.exhibitionDescription = description
//                exhibition!.plants = formerExhibition?.plants
//                exhibition!.img = formerExhibition?.img
//                var lat = exhibition!.lat
//
//                var long =  exhibition!.long
                
                if locationtapped != nil {
                    let lat = locationtapped!.coordinate.latitude
                    let long = locationtapped!.coordinate.longitude
                    exhibition!.lat = lat
                    exhibition!.long = long
                }
                let name = nameTextField.text!
                let description = descriptionTextField.text!
                
                //week4 lab +
                exhibition!.name = name
                exhibition!.exhibitionDescription = description
//                exhibition!.plants = formerExhibition?.plants
//                exhibition!.img = formerExhibition?.img
                
//                let _ = databaseController?.deleteExhibition(exhibition: formerExhibition!)
//                let _ = databaseController?.addExhibition(exhibition: exhibition!)
                //                var context: NSManagedObjectContext = appDel.managedObjectContext!
                //
                //                var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LoginData")
                //                fetchRequest.predicate = NSPredicate(format: "userName = %@", userName)
                //
                //                if let fetchResults = appDel.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [NSManagedObject] {
                //                    if fetchResults.count != 0{
                //
                //                        var managedObject = fetchResults[0]
                //                        managedObject.setValue(accessToken, forKey: "accessToken")
                //
                //                        context.save(nil)
                //                    }
                //                }
                //exhibitionDetailDelegate?.updateExhibition(exhibition: exhibition!)
                //week4 lab -
                //let _=superHeroDelegate?.addSuperHero(newHero: hero)
                let alertController = UIAlertController(title: "Exhibition edited successfully!", message: "", preferredStyle: UIAlertController.Style.alert)
                
                //https://stackoverflow.com/questions/38749312/why-doesnt-popviewcontroller-work-after-presentviewcontroller-on-alert
                let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action: UIAlertAction!) -> Void in
                    self.navigationController!.popViewController(animated: true )
                }
                alertController.addAction(OKAction)
                
                self.present(alertController,animated: true, completion: nil)
                
                //navigationController?.popViewController(animated: true )
                
                return
            }
            
            if nameTextField.text == exhibition!.name && descriptionTextField.text == exhibition!.exhibitionDescription && locationtapped == nil{
                //            var errorMsg = ""
                //
                //
                //            displayMessage(title:"Nothing has changed\n", message:errorMsg)
                let alertController = UIAlertController(title: "Nothing has changed\n", message: "Will back to the Exhibition Detail", preferredStyle: UIAlertController.Style.alert)
                
                //https://stackoverflow.com/questions/38749312/why-doesnt-popviewcontroller-work-after-presentviewcontroller-on-alert
                let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action: UIAlertAction!) -> Void in
                    self.navigationController!.popViewController(animated: true )
                }
                alertController.addAction(OKAction)
                
                self.present(alertController,animated: true, completion: nil)
                
                return //navigationController?.popViewController(animated: true )
            }
        
        
        
        
    }
    
    func onExhibitionChange(change: DatabaseChange, exhibitions: [Exhibition]) {
        //        for oneExhibition in exhibition{
        //            case let name == oneExhibition.name{
        //
        //        }
        //commented when changing db structure
        //        let name = self.exhibition!.name
        //        self.exhibition = exhibition.first{$0.name == name}
        if exhibition == nil {
            exhibition = exhibitions.last
        }
        if exhibition?.plants != nil {
        allPlants = exhibition?.plants?.allObjects as! [Plant]
        }
        plantTableView.reloadData()
        
        
    }
    
    func onPlantListChange(change: DatabaseChange, plants: [Plant]) {
        //allPlants = plants.filter{$0.exhibition == self.exhibition}
        //allPlants = plants
        
        //let pets = animals.filter { $0 != "chimps" }
        //        for plant in allPlants{
        //            if plant.exhibition != self.exhibition{
        //                allPlants.remove(plant)
        //            }
        //        }
        //        if exhibitionDetailDelegate?.updateExhibition(exhibition: self.exhibition!) ?? false{
        //
        //                   return
        //               }
        
        //plantTableView.reloadData()
    }
    //    func onExhibitionPlantsChange(change: DatabaseChange, plants: [Plant]) {
    //        allPlants = plants
    //        plantTableView.reloadData()
    //    }
    
    //    func onExhibitionPlantsChange(change: DatabaseChange, teamHeroes: [SuperHero]) {
    //        currentParty = teamHeroes
    //        tableView.reloadData()
    //    }
    
    @IBAction func addAPlantToThisExhibition(_ sender: Any) {
        //performSegue(withIdentifier: "allPlantsSegue", sender: exhibition)
        
    }
    func addPlantToList(newPlant: Plant) -> Bool {
        //        print(newPlant)
        //        print(exhibition)
        return (databaseController?.addPlantToExhibition(plant: newPlant, exhibition: exhibition!))!
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "allPlantsSegue" {
            let controller = segue.destination as! AllPlantsTableViewController
            controller.editExhibitionDelegate = self
            controller.exhibition = exhibition!
            
        }
        
        if segue.identifier == "plantDetailSegue" {
            let controller = segue.destination as! PlantDetailViewController
            controller.plant = sender as! Plant
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { textField.resignFirstResponder()
        return true
    }
    
    
}
