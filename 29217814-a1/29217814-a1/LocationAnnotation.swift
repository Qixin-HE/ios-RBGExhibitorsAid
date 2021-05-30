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
    var img:String?
    
    
    
    var imagename:String?{return "No_image_available"}
    
    init(title:String, subtitle:String, lat:Double, long:Double,img:String?) {
        self.title = title
        self.subtitle = subtitle
        coordinate = CLLocationCoordinate2D(latitude:lat,longitude: long)
        //self.img = img
        if img != nil{
            self.img = img

        }
        //added when implement image annotation
        super.init()
    }
}
