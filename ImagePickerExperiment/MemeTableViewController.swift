//
//  MemeTableViewController.swift
//  ImagePickerExperiment
//
//  Created by Moritz Nossek on 22.12.15.
//  Copyright © 2015 moritz nossek. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController{
    
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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //refreseh the table
        tableView.reloadData()
    }
    
    //'+'-Button Action, presents the EditorView
    @IBAction func addMeme(sender: AnyObject) {
        let memeEditorController = storyboard!.instantiateViewControllerWithIdentifier("MemeMeEditor") as! MemeEditorViewController
        
        self.presentViewController(memeEditorController, animated: true, completion: nil)
    }
    
    //Appearance in the tableView:
    //Visible:
    // - Memed Image
    // - TOPTEXT .... BOTTOMTEXT
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell", forIndexPath: indexPath) as! MemeTableViewCell
        let meme = memes[indexPath.item]
        cell.memeImageView?.image = meme.memedImage
        cell.memeLabel.text = meme.textTop + "...." + meme.textBottom
        
        return cell
    }
    
    //Necessary function for tableView: Returns the numberOfRowsInSection
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    //When a row is selected, the new DetailView appears
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let memeDetailVC = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        
        memeDetailVC.meme = memes[indexPath.item]
        
        navigationController!.pushViewController(memeDetailVC, animated: true)
        
    }
}
