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
    var memes: [Meme] {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        //return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
        
        for var i = 0; i < 10; ++i{
            debugPurpose()
        }
    }
    
    private func debugPurpose(){
        
        let img = UIImage(named: "lechiffre")
        let meme = Meme(textTop: "TopText", textBottom: "BottomText", image: img!, memedImage: img!)
        
        // Add it to the memes array in the Application Delegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh the local memes reference
        //memes = MemeManager.sharedInstance.memes
        // Refresh the collection
        collectionViewOutlet.reloadData()
    }
    
    @IBAction func addMeme(sender: AnyObject) {
        
        let memeEditorController = storyboard!.instantiateViewControllerWithIdentifier("MemeMeEditor") as! MemeEditorViewController
        
        self.presentViewController(memeEditorController, animated: true, completion: nil)
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        
        
        let meme = self.memes[indexPath.row]
        
        // Set the image
        cell.memeImage?.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // Get the detailViewController from storyboard
        let object: AnyObject = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")
        let memeDetailVC = object as! MemeDetailViewController
        
        //Setup the View Controller with selected meme
        memeDetailVC.meme = memes[indexPath.item]
        memeDetailVC.hidesBottomBarWhenPushed = true    //Turn off tab bar
        
        //Present the view controller
        navigationController!.pushViewController(memeDetailVC, animated: true)
        
    }
    
    
    
}