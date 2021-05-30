//
//  VolumnData.swift
//  29217814-a1
//
//  Created by Zoe on 19/9/20.
//  Copyright © 2020 Qixin HE. All rights reserved.
//

import UIKit

class VolumeData: NSObject, Decodable {
    
    var plants: [PlantData]?
    
    private enum CodingKeys: String, CodingKey {
    case plants = "data"
    }

}
