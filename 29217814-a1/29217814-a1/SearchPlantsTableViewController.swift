//
//  SearchPlantsTableViewController.swift
//  29217814-a1
//
//  Created by Zoe on 19/9/20.
//  Copyright © 2020 Qixin HE. All rights reserved.
//

import UIKit

class SearchPlantsTableViewController: UITableViewController,UISearchBarDelegate {

    let CELL_PLANT = "plantCell"
       let REQUEST_STRING = "https://trefle.io/api/v1/plants?token=xLbpMH8gmWimQ3iIZaHK474SluKZtZ-drE-v9F7PDaU&q="
       
       //added
       let MAX_REQUESTS = 10
       var currentRequestPage: Int = 1
       
       var indicator = UIActivityIndicatorView()
       var newPlants = [PlantData]()
       weak var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for card"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.tableView.center
        self.view.addSubview(indicator)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newPlants.count
    }

   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CELL_PLANT, for: indexPath) as! PlantTableViewCell
    
    let plant = newPlants[indexPath.row]
    cell.nameLabel?.text = plant.name
    cell.descriptionLabel?.text = plant.plantDescription
       
       
       //from tutorial
    if plant.img != nil {
    let imageURL = URL(string: (plant.img!))
                  let imageTask = URLSession.shared.dataTask(with:imageURL!){
                      (data,response, error)in
                      if let error = error{
                          return
                      }
                      
                      DispatchQueue.main.async{
                       cell.imgView!.image = UIImage(data: data!)
                      }
                  }
                  imageTask.resume()
    }else{
        cell.imgView.image = UIImage(named:"No_image_available")
    }
       
       
       cell.sizeToFit()
   
       return cell
   }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath) {
        let plant = newPlants[indexPath.row]
        
        let _ = databaseController?.addPlant(name: plant.name!, plantDescription: plant.plantDescription!, img: plant.img, scientificName: plant.scientificName!, year: plant.year, family: plant.family!, exhibitions: nil)
        navigationController?.popViewController(animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // If there is no text end immediately
        guard let searchText = searchBar.text, searchText.count > 0 else {
            return; }
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.clear
        newPlants.removeAll()
        tableView.reloadData()
        
        //added
        URLSession.shared.invalidateAndCancel()
        currentRequestPage = 0;
            
        requestPlants(plantName: searchText)
    }
    
    func requestPlants(plantName: String) {
    //        let searchString = REQUEST_STRING + cardName
    //        let jsonURL =
    //            URL(string: searchString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            
        //https://trefle.io/api/v1/plants?token=xLbpMH8gmWimQ3iIZaHK474SluKZtZ-drE-v9F7PDaU&q=
        
            //added
            var searchURLComponents = URLComponents()
            searchURLComponents.scheme = "https"
            searchURLComponents.host = "trefle.io"
            searchURLComponents.path = "/api/v1/plants/search"
        //searchURLComponents.
            searchURLComponents.queryItems = [
            URLQueryItem(name: "token", value: "xLbpMH8gmWimQ3iIZaHK474SluKZtZ-drE-v9F7PDaU"),
              URLQueryItem(name: "q", value: plantName)
             ]
            let jsonURL = searchURLComponents.url
            
            let task = URLSession.shared.dataTask(with: jsonURL!) { (data, response, error) in
                // Regardless of response end the loading icon from the main thread
                DispatchQueue.main.async { self.indicator.stopAnimating()
                    self.indicator.hidesWhenStopped = true }
                if let error = error { print(error)
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let volumeData = try decoder.decode(VolumeData.self, from: data!)
                    if let plants = volumeData.plants {
                        self.newPlants.append(contentsOf: plants)
                        DispatchQueue.main.async {
                            self.tableView.reloadData() }
                    }
                } catch let err {
                    print(err) }
            }
            task.resume() }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


