//
//  SentMemesTableViewController.swift
//  ImagePickerExperiment
//
//  Created by Moritz Nossek on 13.12.15.
//  Copyright © 2015 moritz nossek. All rights reserved.
//

import UIKit

//TODO: ANPASSEN!!!!

class SentMemesTableViewController: UIViewController, UITableViewDataSource {
    
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell") as! SentMemesTableViewCell
        
        let meme = memes[indexPath.row]
        
        cell.memeImageView.image = meme.memedImage
        cell.memeLabel.text = buildMemeTextSummary(meme)
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            removeMemeAtIndexPath(indexPath)
        default:
            return
        }
    }
    
    // Correclty removes the meme from the model and the table
    func removeMemeAtIndexPath(indexPath: NSIndexPath) {
        // remove the deleted item from the model
        MemeManager.sharedInstance.deleteMemeAtIndex(indexPath.row)
        memes = MemeManager.sharedInstance.memes
        // remove the deleted item from the `UITableView`
        UITableView.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    // Creates a string to display as the meme summary in a cell
    func buildMemeTextSummary(meme: Meme) -> String {
        
        let topSubstring = meme.textTop
        let bottomSubstring = meme.textBottom
        
        return "\(topSubstring). \(bottomSubstring)"
    }
}

