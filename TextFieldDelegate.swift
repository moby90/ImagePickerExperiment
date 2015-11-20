//
//  TextFieldDelegate.swift
//  ImagePickerExperiment
//
//  Created by Moritz Nossek on 03.11.15.
//  Copyright © 2015 moritz nossek. All rights reserved.
//

import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate{
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //Implement clear default text
        textField.text = ""
    }
    
    //Hide Keyboard after pressing "Return"
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //If unintenionally left blank on textfield, there will be written "TEXT" instead.
    //To intentionally blank a textfield, you have to use a blank space ( _ )
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField.text == "" {
            textField.text = "TEXT"
        }
    }
    
}
