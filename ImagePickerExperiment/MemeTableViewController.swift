//
//  MemeTableViewController.swift
//  ImagePickerExperiment
//
//  Created by Moritz Nossek on 22.12.15.
//  Copyright © 2015 moritz nossek. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController{
    
    @IBOutlet var tableViewOutlet: UITableView!
    
    var memes: [Meme] {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableViewOutlet.reloadData()
        
        
    }
    
    @IBAction func addMeme(sender: AnyObject) {
        let memeEditorController = storyboard!.instantiateViewControllerWithIdentifier("MemeMeEditor") as! MemeEditorViewController
        
        self.presentViewController(memeEditorController, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCell", forIndexPath: indexPath)
        let meme = memes[indexPath.item]
        //cell.imageView!.image = meme.memedImage
        cell.textLabel?.text = meme.textTop + "...." + meme.textBottom
        
        return cell
    }
    
    override func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let memeDetailVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        memeDetailVC.meme = memes[indexPath.item]
        
        memeDetailVC.hidesBottomBarWhenPushed = true        //Turn off tab bar
        
        navigationController!.pushViewController(memeDetailVC, animated: true)
        
    }
}
