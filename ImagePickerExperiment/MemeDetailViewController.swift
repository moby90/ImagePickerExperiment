//
//  MemeDetailViewController.swift
//  ImagePickerExperiment
//
//  Created by Moritz Nossek on 22.12.15.
//  Copyright © 2015 moritz nossek. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
 
    // Image view that will contain the memed image
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        imageView.image = meme.memedImage
    }
    
    @IBAction func deleteMeme(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.memes.removeAtIndex(index)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func editMeme(){
        let memeEditorController = storyboard!.instantiateViewControllerWithIdentifier("MemeMeEditor") as! MemeEditorViewController
        
        presentViewController(memeEditorController, animated: true, completion: nil)
        
        memeEditorController.editMeme(meme, index: index)
        
        //When returning to DetailView, the User will be directed to Table or CollectionView
        navigationController!.popViewControllerAnimated(true)
    }
}
