//
//  PlantDetailViewController.swift
//  29217814-a1
//
//  Created by Zoe on 19/9/20.
//  Copyright © 2020 Qixin HE. All rights reserved.
//

import UIKit

class PlantDetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scientificNameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var familyLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    var plant:Plant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = plant?.name
        let year = plant?.year
        let scientificName = plant?.scientificName
        let family = plant?.family
        nameLabel.text = name!
        scientificNameLabel.text = scientificName!
        yearLabel.text = year!
        familyLabel.text = family!
        
        if plant!.img == nil {
            let pic = UIImage(named:"No_image_available")
            //            plant.img = pic?.pngData()
            imgView.image = pic
        }else{
            let imageURL = URL(string: (plant!.img!))
            let imageTask = URLSession.shared.dataTask(with:imageURL!){
                (data,response, error)in
                if let error = error{
                    return
                }
                
                DispatchQueue.main.async{
                    self.imgView.image = UIImage(data: data!)
                }
            }
            imageTask.resume()
        }
        
    }
    

    @IBAction func editPlant(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
