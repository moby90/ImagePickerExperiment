//
//  TextFieldDelegate.swift
//  ImagePickerExperiment
//
//  Created by Moritz Nossek on 03.11.15.
//  Copyright © 2015 moritz nossek. All rights reserved.
//

import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate{
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
        //Implement
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //Implement clear default text
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField.text == "" {
            textField.text = "TEXT"
        }
    }
    
}
