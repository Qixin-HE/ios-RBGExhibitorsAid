//
//  File.swift
//  29217814-week3
//
//  Created by Zoe on 27/8/20.
//  Copyright © 2020 Qixin HE. All rights reserved.
//

import Foundation

enum DatabaseChange{
    case add
    case remove
    case update
}

enum ListenerType{
    case exhibition
    case plant
    case all
    case exhibitionPlants
}

protocol DatabaseListener:AnyObject{
    var listenerType:ListenerType{get set}
    //all exhibitions
    func onExhibitionChange(change:DatabaseChange, exhibitions:[Exhibition])
    //for one exhibition
    //func onExhibitionPlantsChange(change:DatabaseChange, plants:[Plant])
    //all plants
    func onPlantListChange(change:DatabaseChange, plants:[Plant])
    
    
}

protocol DatabaseProtocol:AnyObject{
    var defaultExhibition:Exhibition{get set}
    
    func cleanup()
    func addPlant(name:String, plantDescription: String, img: String?,scientificName: String?, year: String?,family: String?, exhibitions: NSSet?)->Plant
    func addExhibition(lat: Double, long: Double, name: String, exhibitionDescription: String, img: String?, plants: NSSet?)-> Exhibition
    func addExhibition(exhibition:Exhibition) -> Exhibition
    func addPlantToExhibition(plant:Plant, exhibition:Exhibition) -> Bool
    func addExhibitionToPlant(exhibition:Exhibition,plant:Plant ) -> Bool
    func deletePlant(plant:Plant)
    func deleteExhibition(exhibition:Exhibition)
    func removePlantFromExhibition(plant:Plant,exhibition:Exhibition)
    //func addListener(listener:DatabaseListener,name:String)
    func addListener(listener:DatabaseListener)
    func removeListener(listener:DatabaseListener)
    
}
