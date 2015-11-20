//
//  ViewController.swift
//  ImagePickerExperiment
//
//  Created by Moritz Nossek on 01.11.15.
//  Copyright © 2015 moritz nossek. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    
    //Dictionary for Text Field Attributes
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -6.5
    ]
    
    //Text Field Delegate in seperate .swift
    let textFieldDelegate = TextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set Text Field Attributes and Alignment of Text Field
        setupTextField(self.topTextField)
        setupTextField(self.bottomTextField)
        
        //On Startscreen disable Text Fields and hiding them
        self.topTextField.text = ""
        self.topTextField.enabled = false
        self.bottomTextField.text = ""
        self.bottomTextField.enabled = false
        
        //Disable the Share and Cancel Button, because there is no use of them in the beginning.
        self.shareButton.enabled = false
        self.cancelButton.enabled = false
        
        //Set Text Field Delegates
        self.topTextField.delegate = textFieldDelegate
        self.bottomTextField.delegate = textFieldDelegate

    }
    
    private func setupTextField(textField: UITextField){
        
        //Use the dictionary initialized when starting the app
        textField.defaultTextAttributes = memeTextAttributes
        
        //Text Alignment shall be centered
        textField.textAlignment = NSTextAlignment.Center
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Cut off left and right side :-(
        //But this way it is easier to handle Text Fields.
        imagePickerView.contentMode = .ScaleAspectFill
        
        //Enable Camera Button if there is camera available.
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        //Subscription to Keyboard Notifications
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.unsubscribeFromKeyboardNotifications()
    }

    //Album Button Action:
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        
        //Create ImagePickerController to select from
        let imagePicker = UIImagePickerController()
        //Choose Photo Library when pressing the Album Button
        imagePicker.sourceType = .PhotoLibrary
        
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    //Camera Button Action:
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        
        //Create ImagePickerController to select from
        let imagePicker = UIImagePickerController()
        //Choose Camera when pressing the Camera Button
        imagePicker.sourceType = .Camera
        
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    
        //Enable Text Fields and show default text
        if firstScreen{
            firstScreen = false
            self.topTextField.enabled = true
            self.topTextField.text = "TOP"
            
            self.bottomTextField.enabled = true
            self.bottomTextField.text = "BOTTOM"
            
        }
        
        //In order to get access to an image
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.imagePickerView.image = image
            dismissViewControllerAnimated(true, completion: nil)
            
            //Enable Cancel Button and Share Button
            self.cancelButton.enabled = true
            self.shareButton.enabled = true
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //Closing Picker with Cancelation
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func keyboardWillShow(notification: NSNotification){
        
        //Only shift view, when editing bottom Text Field
        if bottomTextField.editing{
        self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        
        //Only shift view, when editing top Text Field
        if bottomTextField.editing{
        self.view.frame.origin.y += getKeyboardHeight(notification)
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
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
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
        self.firstScreen = true
        
        //Disable TextFields
        self.topTextField.enabled = false
        self.bottomTextField.enabled = false
        //Hiding TextFields
        self.topTextField.text = ""
        self.bottomTextField.text = ""
        
        //Clear image
        self.imagePickerView.image = nil
        
        //After disabling and hiding and clearing there is no use for the Cancel Button
        //Disable Cancel Button
        self.cancelButton.enabled = false
        
    }
    
    func generateMemedImage() -> UIImage {
        
        //Hide toolbar and navbar
        self.toolbar.hidden = true
        self.navigationbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show toolbar and navbar
        self.toolbar.hidden = false
        self.navigationbar.hidden = false
        
        return memedImage
    }
}

