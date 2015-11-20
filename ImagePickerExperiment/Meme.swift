//
//  Meme.swift
//  ImagePickerExperiment
//
//  Created by Moritz Nossek on 18.11.15.
//  Copyright © 2015 moritz nossek. All rights reserved.
//

import UIKit

struct Meme {
    let textTop: String
    let textBottom: String
    let image: UIImage
    let memedImage: UIImage
    
    init(textTop: String, textBottom: String, image: UIImage, memedImage: UIImage){
        self.textTop = textTop
        self.textBottom = textBottom
        self.image = image
        self.memedImage = memedImage
    }
}
