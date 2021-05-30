//
//  ExhibitionDetailDelegate.swift
//  29217814-a1
//
//  Created by Zoe on 20/9/20.
//  Copyright © 2020 Qixin HE. All rights reserved.
//

import Foundation
protocol EditExhibitionDetailDelegate:AnyObject {
        func updateExhibition(exhibition: Exhibition) -> Bool
}
