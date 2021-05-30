//
//  LocationAnnotation.swift
//  29217814-week5
//
//  Created by Zoe on 3/9/20.
//  Copyright © 2020 Qixin HE. All rights reserved.
//

import UIKit
import MapKit

class LocationAnnotation: NSObject, MKAnnotation {

    var coordinate:CLLocationCoordinate2D
    var title:String?
    var subtitle:String?
    
    init(title:String, subtitle:String, lat:Double, long:Double) {
        self.title = title
        self.subtitle = subtitle
        coordinate = CLLocationCoordinate2D(latitude:lat,longitude: long)
    }
}
