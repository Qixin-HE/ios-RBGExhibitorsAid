//
//  AllExhibitionsTableViewController.swift
//  29217814-a1
//
//  Created by Zoe on 10/9/20.
//  Copyright © 2020 Qixin HE. All rights reserved.
//

import UIKit

class AllExhibitionsTableViewController: UITableViewController,UISearchResultsUpdating, DatabaseListener{
    func onExhibitionPlantsChange(change: DatabaseChange, plants: [Plant]) {
        //
    }
    

    
//from here
        let SECTION_EXHIBITIONS = 0
        //let SECTION_INFO = 1
        let CELL_EXHIBITION = "plantCell"
        //let CELL_INFO = "totalExhibitionsCell"
        
        var allExhibitions:[Exhibition] = []
        var filteredExhibitions:[Exhibition] = []
        weak var ExhibitionDelegate: AddExhibitionDelegate?
        
        //week4 lab +
        weak var databaseController : DatabaseProtocol?
        var listenerType: ListenerType = .exhibition
        
    
        

        override func viewDidLoad() {
            super.viewDidLoad()
            
            //week4 lab +
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            databaseController = appDelegate.databaseController

            //week4 lab -
           // createDefaultExhibitions()
            
            filteredExhibitions = allExhibitions
            
            let searchController = UISearchController(searchResultsController: nil)
            searchController.searchResultsUpdater = self
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "Search Exhibitions"
            navigationItem.searchController = searchController
            
            //this view controller decides how the search controller is presented
            definesPresentationContext=true
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            //databaseController?.addListener(listener: self,name: "???")
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
            
            if section == SECTION_EXHIBITIONS{
                return filteredExhibitions.count
            }
            return 1
        }

        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           // if indexPath.section == SECTION_EXHIBITIONS{
            let exhibitionCell = tableView.dequeueReusableCell(withIdentifier: CELL_EXHIBITION, for: indexPath) as! PlantTableViewCell
            let exhibition = filteredExhibitions[indexPath.row]
            
                exhibitionCell.nameLabel.text = exhibition.name
            exhibitionCell.descriptionLabel.text = exhibition.exhibitionDescription
            if exhibition.img == nil {
                //            let pic = UIImage(named:"No_image_available")
                //            plant.img = pic?.pngData()
                exhibitionCell.imgView.image = UIImage(named:"No_image_available")
            }else{
                let imageURL = URL(string: (exhibition.img!))
                let imageTask = URLSession.shared.dataTask(with:imageURL!){
                    (data,response, error)in
                    if let error = error{
                        return
                    }
                    
                    DispatchQueue.main.async{
                    exhibitionCell.imgView.image = UIImage(data: data!)
                    }
                }
                imageTask.resume()
            }
                
                return exhibitionCell
          //  }

//            let cell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for: indexPath)
//            cell.textLabel?.text = "\(filteredExhibitions.count) Exhibitions in the database"
//            cell.textLabel?.textColor = .secondaryLabel
//            cell.selectionStyle = .none
//            return cell
        }
        
    
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let exhibition = filteredExhibitions[indexPath.row]
           performSegue(withIdentifier: "exhibitionDetailSegue", sender: exhibition)
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

        
        // MARK: - Navigation

        //week4 lab -"
        // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "createexhibitionSegue"
    //        {
    //            let destination = segue.destination as! CreateExhibitionViewController
    //            destination.ExhibitionDelegate = self
    //        }
    //    }
        //"week4 lab -
      
        
        func updateSearchResults(for searchController: UISearchController) {
            //guard let searchText = searchController.searchBar.text?.lowercased()else{
                guard let searchText = searchController.searchBar.text else{
                return
            }
            
            if searchText.count > 0
            {
                filteredExhibitions = allExhibitions.filter({(exhibition:Exhibition) -> Bool in
                    //week4 lab +
                    guard let name = exhibition.name else{
                        return false
                    }
                    //week4 lab -
                    //return exhibition.name.lowercased().contains(searchText)
                    //week4 lab +
                    //return name.lowercased().contains(searchText)
                    
                    //case sensitive
                    return name.contains(searchText)
                })
            }else{
                filteredExhibitions = allExhibitions
            }
            
            tableView.reloadData()
        }
        
        //week4 lab -
        //MARK - AddExhibition Delegate
    //    func addExhibition(newexhibition: Exhibition) -> Bool {
    //        allExhibitions.append(newexhibition)
    //        filteredExhibitions.append(newexhibition)
    //        tableView.beginUpdates()
    //        tableView.insertRows(at: [IndexPath(row:filteredExhibitions.count - 1,section:0)], with: .automatic)
    //        tableView.endUpdates()
    //        tableView.reloadSections([SECTION_INFO], with: .automatic)
    //        return true
    //    }
        
        //week4 lab +
        //MARK: - Database Listener
//        func onExhibitionListChange(change: DatabaseChange, Exhibitions: [Exhibition]) {
//            allExhibitions = Exhibitions
//            updateSearchResults(for: navigationItem.searchController!)
//        }
        
//        //week4 lab +
//        func onPlantChange(change: DatabaseChange, teamExhibitions: [Exhibition]) {
//            //Do nothing not called
//        }
    func onExhibitionChange(change: DatabaseChange, exhibitions: [Exhibition]) {
        allExhibitions = exhibitions
        updateSearchResults(for: navigationItem.searchController!)
    }
    
    func onPlantListChange(change: DatabaseChange, plants: [Plant]) {
        //Do nothing not called
    }
        
        //week4 lab -
        //MARK: - Create Defaults
    //    func createDefaultExhibitions()   {
    //        allExhibitions.append(Exhibition(name: "Bruce Wayne",description: "Money"))
    //        allExhibitions.append(Exhibition(name: "Superman",description: "Super Powered Alien"))
    //        allExhibitions.append(Exhibition(name: "The Flash",description: "Speed"))
    //        allExhibitions.append(Exhibition(name: "Green Lantern",description: "Power Ring"))
    //        allExhibitions.append(Exhibition(name: "Cyborg",description: "Robot Beep Beep"))
    //        allExhibitions.append(Exhibition(name: "Aquaman",description: "Atlantian"))
    //
    //    }
        
        func displayMessage(title:String, message: String){
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController,animated: true, completion: nil)
        }
    //to here

    // MARK: - Table view data source


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            self.databaseController?.deleteExhibition(exhibition: filteredExhibitions[indexPath.row])
            
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "exhibitionDetailSegue" {
            let controller = segue.destination as! ExhibitionDetailViewController
            controller.exhibition = sender as! Exhibition
        }
    }
    

}
