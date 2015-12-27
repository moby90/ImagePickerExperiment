//
//  Meme.swift
//  ImagePickerExperiment
//
//  Created by Moritz Nossek on 18.11.15.
//  Copyright © 2015 moritz nossek. All rights reserved.
//

import UIKit

//The Meme struct which contains:
// - Original Image
// - Top Text
// - Bottom Text
// - All in One: Memed Image
struct Meme {
    let textTop: String
    let textBottom: String
    let image: UIImage
    let memedImage: UIImage
}
