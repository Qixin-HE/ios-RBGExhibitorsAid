////
////  LocationAnnotationView.swift
////  29217814-a1
////
////  Created by Zoe on 22/9/20.
////  Copyright © 2020 Qixin HE. All rights reserved.
////
//
//import Foundation
import MapKit
//
class LocationAnnotationView: MKAnnotationView{
//
//    //var classImage:UIImage?
    static let reuseIdentifier = Bundle.main.bundleIdentifier! + ".customAnnotationView"

        private weak var task: URLSessionTask?
        private let size = CGSize(width:40, height: 40)

        override var annotation: MKAnnotation? {
            didSet {
//                if annotation === oldValue { return }
//
//                task?.cancel()
                image = UIImage(named: "No_image_avaliable.png")?.resized(to: size)
                updateImage(for: annotation)
            }
        }

        override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
            super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

            canShowCallout = true
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            image = UIImage(named: "No_image_avaliable.png")?.resized(to: size)
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func updateImage(for annotation: MKAnnotation?) {
            
            guard let annotation = annotation as? LocationAnnotation, let imageURL = URL(string: (annotation.img!)) else { return }

            let task = URLSession.shared.dataTask(with: imageURL) { data, _, error in
                guard let data = data,
                    let image = UIImage(data: data)?.resized(to: self.size),
                    error == nil else {
                        print(error ?? "Unknown error")
                        return
                }

                DispatchQueue.main.async {
                    UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: {
                        self.image = image
                    }, completion: nil)
                }
            }
            task.resume()
            self.task = task
        }
    }
