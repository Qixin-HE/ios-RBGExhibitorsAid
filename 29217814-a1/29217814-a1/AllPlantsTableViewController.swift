//
//  AllPlantsTableViewController.swift
//  29217814-a1
//
//  Created by Zoe on 19/9/20.
//  Copyright © 2020 Qixin HE. All rights reserved.
//

import UIKit

class AllPlantsTableViewController: UITableViewController,UISearchResultsUpdating, DatabaseListener {

    
    
    //let SECTION_Plants = 0
    //let SECTION_INFO = 1
    //let CELL_Plant = "PlantCell"
    //let CELL_INFO = "totalPlantsCell"
    
    var allPlants:[Plant] = []
    var filteredPlants:[Plant] = []
    weak var PlantDelegate: AddPlantDelegate?
    weak var editExhibitionDelegate: EditExhibitionDelegate?
    
    //week4 lab +
    weak var databaseController : DatabaseProtocol?
    var listenerType: ListenerType = .all
    var exhibition:Exhibition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        filteredPlants = allPlants
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Plants"
        navigationItem.searchController = searchController
        
        //this view controller decides how the search controller is presented
        definesPresentationContext=true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //databaseController?.addListener(listener: self, name:"???")
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated:Bool){
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener:self)
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredPlants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // if indexPath.section == SECTION_EXHIBITIONS{
        let plantCell = tableView.dequeueReusableCell(withIdentifier: "plantCell", for: indexPath) as! PlantTableViewCell
        let plant = filteredPlants[indexPath.row]
        if let name = plant.name{
            plantCell.nameLabel.text = name
        }
        if let description = plant.plantDescription{
            plantCell.descriptionLabel.text = description
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
        //plantCell.nameLabel.text = plant.name
        
        
        return plantCell
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased()else{
            return
        }
        
        if searchText.count > 0
        {
            filteredPlants = allPlants.filter({(plant:Plant) -> Bool in
                //week4 lab +
                guard let name = plant.name else{
                    return false
                }
                //week4 lab -
                //return exhibition.name.lowercased().contains(searchText)
                //week4 lab +
                return name.lowercased().contains(searchText)
            })
        }else{
            filteredPlants = allPlants
        }
        
        tableView.reloadData()
    }
    
    func onExhibitionChange(change: DatabaseChange, exhibitions: [Exhibition]) {
        //allExhibitions = exhibition
        
    }
    
    func onPlantListChange(change: DatabaseChange, plants: [Plant]) {
        allPlants = plants
        updateSearchResults(for: navigationItem.searchController!)
    }
    
    func displayMessage(title:String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController,animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath) {
//        let plant = allPlants[indexPath.row]
//        let _ = databaseController?.addPlantToExhibition(plant: plant, exhibition: exhibition!)
        //let exhibitionCopy:Exhibition = exhibition!
//        let _ = databaseController?.deleteExhibition(exhibition: exhibition!)
        //let _ = databaseController?.addExhibition(exhibition: exhibitionCopy)
        //let _ = databaseController?.deleteExhibition(exhibition: exhibitionCopy)
        let selectedPlant = filteredPlants[indexPath.row]
        let plants = exhibition?.plants?.allObjects as! [Plant]
        if plants.contains(selectedPlant){
            let alertController = UIAlertController(title: "This plant is already in the exhibition", message: "You don't have to add it again.", preferredStyle: UIAlertController.Style.alert)
            
            //https://stackoverflow.com/questions/38749312/why-doesnt-popviewcontroller-work-after-presentviewcontroller-on-alert
            let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            //{ (action: UIAlertAction!) -> Void in
//             self.navigationController!.popViewController(animated: true )
           // }
            alertController.addAction(OKAction)
            
            self.present(alertController,animated: true, completion: nil)
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        if editExhibitionDelegate?.addPlantToList(newPlant: filteredPlants[indexPath.row]) ?? false{
            navigationController?.popViewController(animated: false)
            return
        }
        
       let alertController = UIAlertController(title: "A plant added!", message: "", preferredStyle: UIAlertController.Style.alert) //https://stackoverflow.com/questions/38749312/why-doesnt-popviewcontroller-work-after-presentviewcontroller-on-alert
        let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action: UIAlertAction!) -> Void in
         self.navigationController!.popViewController(animated: true )
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController,animated: true, completion: nil)
        return
        
        
        //navigationController?.popViewController(animated: true)
//        guard let vc = navigationController?.topViewController as? EditExhibitionViewController else { return }
        //vc.exhibition = exhibitionCopy
        //databaseController?.cleanup()
//        let lastView = navigationController?.delegate as! EditExhibitionViewController
//        lastView.exhibition = self.exhibition
        
//        let lastView = navigationController?.viewControllers[3] as! EditExhibitionViewController

//        //lastView.exhibition = self.exhibition
//        lastView.exhibition = self.exhibition
//        navigationController?.popToViewController(lastView as! UIViewController, animated: true)
        
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     
    
}
