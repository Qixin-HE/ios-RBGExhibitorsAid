//
//  File.swift
//  29217814-week3
//
//  Created by Zoe on 27/8/20.
//  Copyright © 2020 Qixin HE. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataController: NSObject,DatabaseProtocol,NSFetchedResultsControllerDelegate {
    

    
    
    
    
    
    let DEFAULT_EXHIBITION_NAME = "Default Exhibition"
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer : NSPersistentContainer
    
    //Fetched Results Controllers
    var allExhibitionFetchedResultsController:NSFetchedResultsController<Exhibition>?
    //var exhibitionPlantsFetchedResultsController:NSFetchedResultsController<Plant>?
    var allPlantFetchedResultsController:NSFetchedResultsController<Plant>?
    
    override init() {
        //Load the Core Data Stack
        persistentContainer = NSPersistentContainer(name:"Exhibitions")
        persistentContainer.loadPersistentStores(){
            (description, error) in
            if let error = error{
                fatalError("Failed to load Core Data stack:\(error)")
            }
        }
        
        super.init()
        
        //if no plants in the databse we assume this is the first time the app runs
        // Create a default Exhibition and initial super plants in this case
        if fetchAllExhibition().count == 0 {
            createDefaultEntries()
        }
    }
    
    //MARK: - Lazy Initization of Default Exhibition
    lazy var defaultExhibition: Exhibition = {
        var exhibitions = [Exhibition]()
        
        let request: NSFetchRequest<Exhibition> = Exhibition.fetchRequest()
        let predicate = NSPredicate(format:"name = %@", DEFAULT_EXHIBITION_NAME)
        request.predicate = predicate
        
        do{
            try exhibitions = persistentContainer.viewContext.fetch(request)
        }catch{
            print("Fetch Request Failed:\(error)")
        }
        
        if exhibitions.count == 0{
            return addExhibition(lat: -37.8299924, long: 144.9793839, name: "???",exhibitionDescription: "???",img: nil, plants: nil)
        }
        return exhibitions.first!
    }()
    
    func saveContext(){
        if persistentContainer.viewContext.hasChanges{
            do{
                try persistentContainer.viewContext.save()
            }catch{
                fatalError("Failed to save to CoreData:\(error)")
            }
        }
    }
    
    //MARK: - Database Protocol Functions
    func cleanup(){
        saveContext()
    }
    func addPlant(name:String, plantDescription: String, img: String?,scientificName: String?, year: String?,family: String?, exhibitions: NSSet?)->Plant{
        let plant = NSEntityDescription.insertNewObject(forEntityName: "Plant", into: persistentContainer.viewContext) as! Plant
        plant.name = name
        plant.plantDescription = plantDescription
        if scientificName != nil {
            plant.scientificName = scientificName
        }
        if year != nil {
            plant.year = year
        }
        if family != nil {
            plant.family = family
        }
        if img != nil {
            plant.img = img
        }
        if exhibitions != nil {
//            for exhibition in exhibitions! {
//                plant.exhibitions?.adding(exhibition)
//
//            }
             plant.exhibitions = exhibitions
//            plant.exhibition = exhibition
        }
        return plant
    }
    
    func addExhibition(lat: Double, long: Double, name: String, exhibitionDescription: String, img: String?, plants: NSSet?) -> Exhibition {
        let exhibition = NSEntityDescription.insertNewObject(forEntityName: "Exhibition", into: persistentContainer.viewContext) as! Exhibition
        exhibition.lat = lat
        exhibition.long = long
        exhibition.name = name
        exhibition.exhibitionDescription = exhibitionDescription
        if img != nil {
            exhibition.img = img
        }
        if plants != nil {
            exhibition.plants = plants
        }
        
        
        return exhibition
    }
    func addExhibition(exhibition:Exhibition) -> Exhibition {
        
        return exhibition
    }
    
    func addPlantToExhibition(plant:Plant, exhibition:Exhibition) -> Bool{
        //        guard let plants = Exhibition.plants, plants.contains(plant) == false,
        //            plants.count < 6 else {
        //                return false
        //        }
        
        exhibition.addToPlants(plant)
        return true
    }
    
    
    func addExhibitionToPlant(exhibition: Exhibition, plant: Plant) -> Bool {
        plant.addToExhibitions(exhibition)
        return true
    }
    
    
    func deletePlant(plant:Plant)
    {
        persistentContainer.viewContext.delete(plant)
    }
    
    func deleteExhibition(exhibition:Exhibition){
        persistentContainer.viewContext.delete(exhibition)
    }
    
    func removePlantFromExhibition(plant: Plant, exhibition:Exhibition){
        exhibition.removeFromPlants(plant)
    }
    
    func addListener(listener: DatabaseListener)
    {
        listeners.addDelegate(listener)
        
        if listener.listenerType == .exhibition || listener.listenerType == .all {
            listener .onExhibitionChange(change: .update, exhibitions: fetchAllExhibition())
        }
        if listener.listenerType == .plant || listener.listenerType == .all{
            listener.onPlantListChange(change: .update, plants: fetchAllPlants())
        }
        //        if listener.listenerType == .plants || listener.listenerType == .all{
        //            listener.onplantListChange(change: .update, plants: fetchAllPlants())
        //        }
    }
    
    func removeListener(listener: DatabaseListener){
        listeners.removeDelegate(listener)
    }
    
    //MARK: - Fetched Results Controller Protocol Functions
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == allExhibitionFetchedResultsController{
            listeners.invoke{(listener) in
                if listener.listenerType == .exhibition || listener.listenerType == .all{
                    listener.onExhibitionChange(change: .update, exhibitions: fetchAllExhibition())
                }
            }
        }
        else if controller == allPlantFetchedResultsController {
            listeners.invoke{(listener) in
                if listener.listenerType == .plant || listener.listenerType == .all{
                    listener.onPlantListChange(change: .update, plants: fetchAllPlants())
                    
                }
            }
        }
        //        else if controller == ExhibitionPlantsFetchedResultsController {
        //    listeners.invoke{(listener) in
        //        if listener.listenerType == .Exhibition || listener.listenerType == .all{
        //    listener.onExhibitionChange(change:.update, Exhibitionplants:fetchExhibitionPlants())
        //    }
        //    }
        //        }
    }
    
    //MARK: -Core Data Fetch Requests
    func fetchAllExhibition() -> [Exhibition]
    {
        //if results controller not currently initialized
        if allExhibitionFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest <Exhibition> = Exhibition.fetchRequest()
            // Sort by name
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            //Initialize Results Controller
            allExhibitionFetchedResultsController = NSFetchedResultsController<Exhibition>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            //Set this class to be the results delegate
            allExhibitionFetchedResultsController?.delegate = self
            
            do{
                try allExhibitionFetchedResultsController?.performFetch()
                
            }catch{
                print("Fetch Request Failed:\(error)")
            }
        }
        var exhibitions = [Exhibition]()
        if allExhibitionFetchedResultsController?.fetchedObjects != nil{
            exhibitions = (allExhibitionFetchedResultsController?.fetchedObjects)!
            
        }
        return exhibitions
    }
    func fetchAllPlants() -> [Plant]
    {
        if allPlantFetchedResultsController == nil{
            let fetchRequest:NSFetchRequest<Plant> = Plant.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            //Initialize Results Controller
            allPlantFetchedResultsController = NSFetchedResultsController<Plant>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            //Set this class to be the results delegate
            allPlantFetchedResultsController?.delegate = self
            
            do{
                try allPlantFetchedResultsController?.performFetch()
                
            }catch{
                print("Fetch Request Failed:\(error)")
            }
        }
        var plants = [Plant]()
        if allPlantFetchedResultsController?.fetchedObjects != nil{
            plants = (allPlantFetchedResultsController?.fetchedObjects)!
            
        }
        
        return plants
    }
    //func fetchExhibitionPlants() -> [Plant]
    //{
    //    if ExhibitionplantsFetchedResultsController == nil{
    //        let fetchRequest:NSFetchRequest<Plant> = Plant.fetchRequest()
    //        let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
    //        let predicate = NSPredicate(format: "ANY Exhibitions.name == %@", DEFAULT_EXHIBITION_NAME)
    //        fetchRequest.sortDescriptors = [nameSortDescriptor]
    //        fetchRequest.predicate = predicate
    //
    //        ExhibitionplantsFetchedResultsController = NSFetchedResultsController<Plant>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    //        ExhibitionplantsFetchedResultsController = NSFetchedResultsController <Plant>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    //        ExhibitionplantsFetchedResultsController?.delegate = self
    //
    //        do{
    //            try ExhibitionplantsFetchedResultsController?.performFetch()
    //        }catch{
    //            print("Fetch Result Failed:\(error)")
    //        }
    //    }
    //    var plants = [Plant]()
    //        if ExhibitionplantsFetchedResultsController?.fetchedObjects != nil{
    //            plants = (ExhibitionplantsFetchedResultsController?.fetchedObjects)!
    //    }
    //    return plants
    //}
    
    
    //MARK: - Default Entry Generation
    func createDefaultEntries(){
        let ex1 =  addExhibition(lat: -37.8299924, long: 144.9793839, name: "Princes Lawn",exhibitionDescription: "Is ideal for a garden ceremony.",img: "https://bs.floristic.org/image/o/1a03948baf0300da25558c2448f086d39b41ca30", plants: nil)
        let p1_1 = addPlant(name:"Pointleaf manzanita", plantDescription: "Shrub, burgundy trunk, pink flowers, attracts birds, edible berries. Mostly grown for vibrant colours and shapes of the trunk.", img: nil, scientificName: "Arctostaphylos pungens Manzanita" , year: "1887", family: "Ericaceae", exhibitions: nil)
        //let _ = addPlantToExhibition(plant: firstPlant, exhibition: princesLawn)
        let p1_2 = addPlant(name:"Chalk dudleya", plantDescription: "Rosette clump, pink flowers, fleshy succulent, great for rockeries. Endangered in most natural habitats. Plant on a slight angle to prevent crown rot.", img: nil, scientificName: "Dudleya pulverulenta", year: "1903", family: "Crassulaceae", exhibitions: nil)
        let p1_3 = addPlant(name:"Fendler's ceanothus", plantDescription: "Shrub, blue-white flowers, dark green foliage, attracts butterflies. Most common Californian native species in cultivation.", img: nil, scientificName: "Ceanothus fendleri", year: "1849", family: "Rhamnaceae", exhibitions: nil)
        
        let _ = addPlantToExhibition(plant: p1_1, exhibition: ex1)
        let _ = addPlantToExhibition(plant: p1_2, exhibition: ex1)
        let _ = addPlantToExhibition(plant: p1_3, exhibition: ex1)
        
    
        
        let ex2 =  addExhibition(lat: -37.8292136, long: 144.9792864, name: "Rose Pavilion",exhibitionDescription: "Is known for its expansive pink and white rose gardens.",img: "https://bs.floristic.org/image/o/fe957b1a87df808443782ad72c2c0ddec0729370", plants: nil)
        let p2_1 = addPlant(name: "Evergreen Oak", plantDescription: "quercus-rotundifolia", img: "https://bs.floristic.org/image/o/1a03948baf0300da25558c2448f086d39b41ca30", scientificName: "Quercus rotundifolia", year: "1785", family: "Fagaceae", exhibitions: nil)
        let p2_2 = addPlant(name: "stinging nettle", plantDescription: "urtica-dioica", img: "https://bs.floristic.org/image/o/85256a1c2c098e254fefe05040626a4df49ce248", scientificName: "Urtica dioica", year: "1753", family: "Urticaceae", exhibitions: nil)
        let p2_3 = addPlant(name: "narrowleaf plantain", plantDescription: "plantago-lanceolata", img: "https://bs.floristic.org/image/o/78a8374f009e6ed2dc71ca17d18e4271ea0a2a7b", scientificName: "Plantago lanceolata", year: "1753", family: "Plantain family", exhibitions: nil)
        let _ = addPlantToExhibition(plant: p2_1, exhibition: ex2)
        let _ = addPlantToExhibition(plant: p2_2, exhibition: ex2)
        let _ = addPlantToExhibition(plant: p2_3, exhibition: ex2)
        let ex3 =  addExhibition(lat: -37.8304778, long:144.9803291,  name: "Bamboo Collection",exhibitionDescription: "Melbourne Gardens exhibits a broad range of Bamboo from different regions of the world across the entire site.",img: "https://bs.floristic.org/image/o/85256a1c2c098e254fefe05040626a4df49ce248", plants: nil)
        let p3_1 = addPlant(name: "stinging nettle", plantDescription: "urtica-dioica", img: "https://bs.floristic.org/image/o/85256a1c2c098e254fefe05040626a4df49ce248", scientificName: "Urtica dioica", year: "1753", family: "Urticaceae", exhibitions: nil)
        let p3_2 = addPlant(name: "narrowleaf plantain", plantDescription: "plantago-lanceolata", img: "https://bs.floristic.org/image/o/78a8374f009e6ed2dc71ca17d18e4271ea0a2a7b", scientificName: "Plantago lanceolata", year: "1753", family: "Plantaginaceae", exhibitions: nil)
        let p3_3 = addPlant(name: "creeping buttercup", plantDescription: "ranunculus-repens", img: "https://bs.floristic.org/image/o/c6d9a5222b6ef0e3a7bdef3350278718d3097bce", scientificName: "Ranunculaceae", year: "1753", family: "Ranunculaceae", exhibitions: nil)
        let _ = addPlantToExhibition(plant: p3_1, exhibition: ex3)
        let _ = addPlantToExhibition(plant: p3_2, exhibition: ex3)
        let _ = addPlantToExhibition(plant: p3_3, exhibition: ex3)
        
        let ex4 =  addExhibition(lat:-37.8314259 , long:144.9793927,  name: "Herb Garden",exhibitionDescription: "A wide range of herbs from well known leafy annuals.",img: "https://bs.floristic.org/image/o/05c2f3cf28a921235daece7b31806741c7251784", plants: nil)
        let p4_1 = addPlant(name: "herb bennet", plantDescription: "geum-urbanum", img: "https://bs.floristic.org/image/o/8b5e42f0fcf7e2313430abc70292bf752b9dc9bd", scientificName: "Geum urbanum", year: "1753", family: "Rosaceae", exhibitions: nil)
        let p4_2 = addPlant(name: "Herb-Paris", plantDescription: "paris-quadrifolia", img: "https://bs.floristic.org/image/o/93d20eb325ba02728f2ee12f6607316d80d10237", scientificName: "Paris quadrifolia", year: "1753", family: "Melanthiaceae", exhibitions: nil)
        let p4_3 = addPlant(name: "herb sophia", plantDescription: "descurainia-sophia", img: "https://bs.floristic.org/image/o/2357b7f20cce34db2ed8e5a429ff45894df86931", scientificName: "Descurainia sophia", year: "1892", family: "Brassicaceae", exhibitions: nil)
        let _ = addPlantToExhibition(plant: p4_1, exhibition: ex4)
        let _ = addPlantToExhibition(plant: p4_2, exhibition: ex4)
        let _ = addPlantToExhibition(plant: p4_3, exhibition: ex4)
        
        let ex5 =  addExhibition(lat:-37.8303428 , long:144.9828852,  name: "Viburnum Collection",exhibitionDescription: "Viburnums are shrubs with four seasons of interest.",img: "https://bs.floristic.org/image/o/78a8374f009e6ed2dc71ca17d18e4271ea0a2a7b", plants: nil)
        let p5_1 = addPlant(name: "mapleleaf viburnum", plantDescription: "viburnum-acerifolium", img: "https://bs.floristic.org/image/o/2ef9492c18de22b310a7b81bffe06dced56ca403", scientificName: "Viburnum acerifolium", year: "1753", family: "Viburnaceae", exhibitions: nil)
        let p5_2 = addPlant(name: "Sargent's Viburnum", plantDescription: "viburnum-sargentii", img: "https://bs.floristic.org/image/o/06bc5f0e8719c0ca877b384d6655f758ca46cf14", scientificName: "Viburnum sargentii", year: "1899", family: "Viburnaceae", exhibitions: nil)
        let p5_3 = addPlant(name: "tea viburnum", plantDescription: "viburnum-setigerum", img: "http://d2seqvvyy3b8p2.cloudfront.net/8cbdbee932a61bc257a20140434d9b4c.jpg", scientificName: "Viburnum setigerum", year: "1882", family: "Viburnaceae", exhibitions: nil)
        let _ = addPlantToExhibition(plant: p5_1, exhibition: ex5)
        let _ = addPlantToExhibition(plant: p5_2, exhibition: ex5)
        let _ = addPlantToExhibition(plant: p5_3, exhibition: ex5)
    }
    
    func createOnePlant(_ name:String,_ description:String)->NSManagedObject{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        //        let entity = NSEntityDescription.entity(
        //let newPlant = NSManagedObject
        
        let newPlant = NSEntityDescription.insertNewObject(forEntityName: "Plant", into: context) as! Plant
        newPlant.setValue(name, forKey: "name")
        newPlant.setValue(description, forKey: "plantDescription")
        
        return newPlant
    }
}

