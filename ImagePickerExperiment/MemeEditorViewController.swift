//
//  ViewController.swift
//  ImagePickerExperiment
//
//  Created by Moritz Nossek on 01.11.15.
//  Copyright © 2015 moritz nossek. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navigationbar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    //Use this variable to set a default status and been able to come back to this status
    var firstScreen = true
    
    //Text Field Delegate in seperate .swift
    let textFieldDelegate = TextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Prepare Text Fields
        prepareTextField(topTextField, defaultText:"")
        prepareTextField(bottomTextField, defaultText:"")
        
        //Disable the Share and Cancel Button, because there is no use of them in the beginning.
        shareButton.enabled = false
        cancelButton.enabled = false
    }
    
    func prepareTextField(textField: UITextField, defaultText: String) {
        super.viewDidLoad()
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!,
            NSStrokeWidthAttributeName : -2.0
        ]
        
        //Set Delegate
        textField.delegate = textFieldDelegate
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = defaultText
        textField.autocapitalizationType = .AllCharacters
        textField.textAlignment = .Center
        
        //Disable Text Field
        textField.enabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Cut off left and right side :-(
        //But this way it is easier to handle Text Fields.
        //imagePickerView.contentMode = .ScaleAspectFill
        
        //Enable Camera Button if there is camera available.
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        //Subscription to Keyboard Notifications
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }

    //Album Button Action:
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        
        //Create ImagePickerController to select from
        let imagePicker = UIImagePickerController()
        //Choose Photo Library when pressing the Album Button
        imagePicker.sourceType = .PhotoLibrary
        
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    //Camera Button Action:
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        
        //Create ImagePickerController to select from
        let imagePicker = UIImagePickerController()
        //Choose Camera when pressing the Camera Button
        imagePicker.sourceType = .Camera
        
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    
        //Enable Text Fields and show default text
        if firstScreen{
            firstScreen = false
            topTextField.enabled = true
            topTextField.text = "TOP"
            
            bottomTextField.enabled = true
            bottomTextField.text = "BOTTOM"
            
        }
        
        //In order to get access to an image
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imagePickerView.image = image
            dismissViewControllerAnimated(true, completion: nil)
            
            //Enable Cancel Button and Share Button
            cancelButton.enabled = true
            shareButton.enabled = true
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //Closing Picker with Cancelation
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func keyboardWillShow(notification: NSNotification){
        
        //Only shift view, when editing bottom Text Field
        if bottomTextField.editing{
        view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        
        //Only shift view, when editing top Text Field
        if bottomTextField.editing{
            view.frame.origin.y  = 0
        }
    }
    
    //Calculate keyboard's height in order to shift the view
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }

    //Add Observer when keyboard will show and when keyboard will hide.
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:" as Selector, name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:" as Selector, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //Remove Observers when  view will disappear
    func unsubscribeFromKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //Share Button Action:
    @IBAction func share(sender: AnyObject) {
        
        //Generate Memed Image
        let memedImage = generateMemedImage()
        
        //Set activity view controller with memedImage as Object to share
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        //Present Activity View
        presentViewController(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = {
            
            (activity, success, items, error) in
            if success {
                // Save the activity-passed Meme into the SharedDataContainer inside the AppDelegate using the following funciton
                self.save(memedImage)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    //Save Function
    func save(memedImage: UIImage){
        
        //Save:
        //Top Text Field Text
        //Bottom Text Field Text
        //Original Image
        //Memed Image
        let meme = Meme(textTop: self.topTextField.text!, textBottom: self.bottomTextField.text!, image: self.imagePickerView.image!, memedImage: memedImage)
    }
    
    //Cancel Button Action:
    @IBAction func cancelAction(sender: AnyObject) {
        
        //Pressing "Cancel" means default status now:
        firstScreen = true
        
        //Disable TextFields
        topTextField.enabled = false
        bottomTextField.enabled = false
        //Hiding TextFields
        topTextField.text = ""
        bottomTextField.text = ""
        
        //Clear image
        imagePickerView.image = nil
        
        //After disabling and hiding and clearing there is no use for the Cancel Button
        //Disable Cancel Button
        cancelButton.enabled = false
        shareButton.enabled = false        
    }
    
    func generateMemedImage() -> UIImage {
        
        //Hide toolbar and navbar
        toolbar.hidden = true
        navigationbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show toolbar and navbar
        toolbar.hidden = false
        navigationbar.hidden = false
        
        return memedImage
    }
}

