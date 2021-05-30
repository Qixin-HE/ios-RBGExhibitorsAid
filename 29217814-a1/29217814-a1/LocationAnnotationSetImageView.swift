//
//  LocationAnnotationSetImageView.swift
//  29217814-a1
//
//  Created by Zoe on 22/9/20.
//  Copyright © 2020 Qixin HE. All rights reserved.
//

import MapKit
class LocationAnnotationSetImageView: MKAnnotationView {
    static let reuseIdentifier = Bundle.main.bundleIdentifier! + ".customUserAnnotationView"
    private let size = CGSize(width: 17, height: 17)

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        image = UIImage(named: "No_image_available")?.resized(to: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
