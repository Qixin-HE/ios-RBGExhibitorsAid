//
//  PlantData.swift
//  29217814-a1
//
//  Created by Zoe on 19/9/20.
//  Copyright © 2020 Qixin HE. All rights reserved.
//

import UIKit

class PlantData: NSObject, Decodable {
    var img: String?
    var name: String?
    var plantDescription: String?
    var scientificName: String?
    var year: String?
    var family: String?
    
    private enum RootKeys: String, CodingKey {
        case name = "common_name"
        case plantDescription = "slug"
        case image = "image_url"
        case year
        case scientificName = "scientific_name"
        case family
    }
//    private struct ImageURIs: Decodable {
//        var png: String? }
    
    required init(from decoder: Decoder) throws {
        let plantContainer = try decoder.container(keyedBy: RootKeys.self)
       
        name = try plantContainer.decode(String.self, forKey: .name)
        plantDescription = try plantContainer.decode(String.self, forKey: .plantDescription)
        scientificName = try plantContainer.decode(String.self, forKey: .scientificName)
        year = try? "\(plantContainer.decode(Int.self, forKey: .year))"
        family = try? plantContainer.decode(String.self, forKey: .family)
        
//        let imageURIs = try? plantContainer.decode(ImageURIs.self, forKey: .image)
//        print(imageURIs)
        img = try? plantContainer.decode(String.self, forKey: .image) }

}
