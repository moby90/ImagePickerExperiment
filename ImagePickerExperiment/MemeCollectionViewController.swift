//
//  MemeCollectionViewController.swift
//  ImagePickerExperiment
//
//  Created by Moritz Nossek on 22.12.15.
//  Copyright © 2015 moritz nossek. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController{
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet var collectionViewOutlet: UICollectionView!
    
    //Array of memes which come from the AppDelegate
    //NOT persistent!
    //Fills whenever the User saves a meme
    var memes: [Meme] {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the flowLayout for the collectionView
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
        //----Uncomment to fill the memesArray in AppDelegate----
        //--------------For Debug purpose only!!!----------------
/*
        for var i = 0; i < 10; ++i{
            debugPurpose()
        }
*/
    }

    
    //----Uncomment to fill the memesArray in AppDelegate----
    //--------------For Debug purpose only!!!----------------
    
/*
    private func debugPurpose(){
        
        let img = UIImage(named: "lechiffre")
        let meme = Meme(textTop: "TopText", textBottom: "BottomText", image: img!, memedImage: img!)
        
        // Add it to the memes array in the Application Delegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
*/
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh the collection
        collectionViewOutlet.reloadData()
    }
    
    //'+'-Button Action, presents the EditorView
    @IBAction func addMeme(sender: AnyObject) {
        
        let memeEditorController = storyboard!.instantiateViewControllerWithIdentifier("MemeMeEditor") as! MemeEditorViewController
        
        self.presentViewController(memeEditorController, animated: true, completion: nil)
    }
    
    //Necessary function for collectionView: Returns the numberOfItemsInSection
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    //Appearance in the collectionView:
    //Visible:
    // - Memed Image
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        
        //Get the right Meme
        let meme = self.memes[indexPath.row]
        
        // Set the image
        cell.memeImage?.image = meme.memedImage
        
        return cell
    }
    
    //When an item is selected, the new DetailView appears
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let memeDetailVC = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        memeDetailVC.meme = memes[indexPath.item]
        
        navigationController!.pushViewController(memeDetailVC, animated: true)
        
    }
    
    
    
}