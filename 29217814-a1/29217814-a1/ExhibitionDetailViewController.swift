//
//  ExhibitionDetailViewController.swift
//  29217814-a1
//
//  Created by Zoe on 19/9/20.
//  Copyright © 2020 Qixin HE. All rights reserved.
//

import UIKit
import MapKit

class ExhibitionDetailViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, DatabaseListener,AddExhibitionDelegate,EditExhibitionDetailDelegate{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBOutlet weak var plantTableView: UITableView!
    

    
    let SECTION_PLANT = 0
    let CELL_PLANT = "plantCell"
    
    var allPlants:[Plant] = []
    //var filteredPlants:[Plant] = []
    weak var plantDelegate: AddPlantDelegate?
    
    weak var databaseController : DatabaseProtocol?
    var listenerType: ListenerType = .all
    
    var exhibition:Exhibition?
    var plants:NSSet?
    
//    var documentsUrl: URL {
//        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//    }
    
    var location = LocationAnnotation(title: "The Garden", subtitle: "Best garden.", lat: -37.8299924, long: 144.9806000,img:nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        nameLabel.text = exhibition?.name
        descriptionLabel.text = exhibition?.exhibitionDescription
//        latLabel.text = "Lat: " + "\(String(describing: exhibition?.lat))"
//        longLabel.text = "Long: " + "\(String(describing: exhibition?.long))"
        
        //filteredPlants = allPlants
        plants = exhibition?.plants
        for plant:Plant in plants!.allObjects as! [Plant]{
            //print("\(plant.name)")
            allPlants.append(plant)
        }
        //allPlants = plants?.allObjects as! [Plant]
        
        //plantTableView.register(PlantTableViewCell.self, forCellReuseIdentifier: CELL_PLANT) // using code.
        plantTableView.delegate = self
        plantTableView.dataSource = self
        
        
        
        focusOn(annotation: location)
        
        
        location = LocationAnnotation(title: exhibition!.name!, subtitle: exhibition!.exhibitionDescription!, lat: exhibition!.lat, long: exhibition!.long,img:nil)
        mapView.addAnnotation(location)
        mapView.showsUserLocation = true
        
    }
    func focusOn(annotation:MKAnnotation)
    {
        mapView.selectAnnotation(annotation, animated: true)
        
        let zoomRegion = MKCoordinateRegion(center:annotation.coordinate, latitudinalMeters: 700,longitudinalMeters:700)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //databaseController?.addListener(listener: self, name:exhibition!.name!)
        
        
        self.plantTableView.reloadData()
        
        nameLabel.text = exhibition?.name
        descriptionLabel.text = exhibition?.exhibitionDescription
        databaseController?.addListener(listener: self)
    }

    override func viewWillDisappear(_ animated:Bool){
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
        // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allPlants.count == 0 {
            return 1
        }
        return allPlants.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let plantCell = plantTableView.dequeueReusableCell(withIdentifier: CELL_PLANT, for: indexPath) as! PlantTableViewCell
        if allPlants.count == 0 {
            plantCell.nameLabel!.text = "No plant information about this exhibition yet"
             plantCell.descriptionLabel!.text = "You can add plants to this exhibition if you know it by editing this exhibition!"
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if allPlants.count != 0 {
       let plant = allPlants[indexPath.row]
       performSegue(withIdentifier: "plantDetailSegue", sender: plant)
        }
        tableView.deselectRow(at: indexPath, animated: false)
        return
    }
    
func onExhibitionChange(change: DatabaseChange, exhibitions: [Exhibition]) {
    //do nothing
//    if exhibition == nil {
//        exhibition = exhibitions.last
//        nameLabel.text = exhibition?.name
//        descriptionLabel.text = exhibition?.exhibitionDescription
//    }
    if exhibition?.plants != nil {
        print("in exhibitionDetail onExChange" + "\(exhibition?.name)")
    allPlants = exhibition?.plants?.allObjects as! [Plant]
    }
    
    plantTableView.reloadData()
    mapView.removeAnnotation(location)
    location = LocationAnnotation(title: exhibition!.name!, subtitle: exhibition!.exhibitionDescription!, lat: exhibition!.lat, long: exhibition!.long,img:nil)
    
    
    mapView.addAnnotation(location)
}

func onPlantListChange(change: DatabaseChange, plants: [Plant]) {
    //allPlants = plants.filter{$0.exhibition == self.exhibition}
    //plantTableView.reloadData()
}
//    func onExhibitionPlantsChange(change: DatabaseChange, plants: [Plant]) {
//        allPlants = plants
//        plantTableView.reloadData()
//    }
    
    @IBAction func editExhibition(_ sender: Any) {
        performSegue(withIdentifier: "editExhibitionSegue", sender: exhibition)
    }
    
    func updateExhibition(exhibition: Exhibition) -> Bool {
        allPlants.removeAll()
        self.exhibition = exhibition
        plants = exhibition.plants
        for plant:Plant in plants!.allObjects as! [Plant]{
            //print("\(plant.name)")
            allPlants.append(plant)
        }
        return true
    }
    
    func addExhibition(newExhibition: Exhibition) -> Bool {
        exhibition = newExhibition
        return true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "plantDetailSegue" {
            let controller = segue.destination as! PlantDetailViewController
            controller.plant = sender as! Plant
        }
        if segue.identifier == "editExhibitionSegue" {
            let controller = segue.destination as! EditExhibitionViewController
            controller.exhibitionDetailDelegate = self
            controller.exhibition = exhibition
        }
        
    }
//    private func load(fileName: String) -> UIImage? {
//        let fileURL = documentsUrl.appendingPathComponent(fileName)
//        do {
//            let imageData = try Data(contentsOf: fileURL)
//            return UIImage(data: imageData)
//        } catch {
//            print("Error loading image : \(error)")
//        }
//        return nil
//    }
    

}


