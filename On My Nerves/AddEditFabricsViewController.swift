//
//  AddEditFabricsViewController.swift
//  On My Nerves
//
//  Created by Sara Ford on 8/1/15.
//  Copyright (c) 2015 Sara Ford. All rights reserved.
//

import UIKit


class AddEditFabricsViewController: UIViewController, UITextFieldDelegate,  UINavigationControllerDelegate {

    @IBOutlet weak var fabricName: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var fabricTime: UITextField!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var errorMessage: UILabel!
    
    var passedValue: Int!
    
    @IBAction func saveUpdate(sender: UIButton) {

        if (passedValue == nil) {
            
            // newly created fabric
            var index: Int = 0
            if (fabrics.count > 0) {
                index = fabrics.count - 1
            }
            
            // create a new fabric
            var newFabric = Fabric()
            
            newFabric.fabricName = fabricName.text
            newFabric.fabricTime = fabricTime.text.toInt()!
            
            fabrics.append(newFabric)
            
            // add data to the arrays to save to disk
            fabricNamesArray.append(fabricName.text)
            fabricTimesArray.append(fabricTime.text.toInt()!)
            
            
        } else {
            
            // save the info the user entered into the fields
            fabrics[passedValue].fabricName = fabricName.text
            fabrics[passedValue].fabricTime = fabricTime.text.toInt()!

            // update data to the arrays to save to disk
            fabricNamesArray[passedValue] = fabricName.text
            fabricTimesArray[passedValue] = fabricTime.text.toInt()!
            
            passedValue = nil
        }
        
        // and now update
        NSUserDefaults.standardUserDefaults().setObject(fabricNamesArray, forKey: "fabricNames")
        NSUserDefaults.standardUserDefaults().setObject(fabricTimesArray, forKey: "fabricTimes")
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func cancelUpdate(sender: AnyObject) {
    
        self.dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    func resetUI() {
    
        // populate it with the current Fabric
        fabricName.text = "Drew"
        fabricTime.text = "5"
    }
    
    // this isn't called from the add (+), only from the edit
    override func viewWillAppear(animated: Bool) {

        // am I being called?
        println("viewWillAppear")
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        println("viewDidLoad: the valuePassed is \(passedValue)")
  
        if (passedValue == nil) {
            
            // set UI as new fabric
            self.navBar.title = "Add new fabric"
            doneButton.setTitle("Add", forState: UIControlState.Normal)
            
        } else {
            
            // Just making an edit
            self.navBar.title = "Edit fabric info"
            doneButton.setTitle("Save", forState: UIControlState.Normal)
            
        }
        
        // set the UI 
        // if there's content, then it came from a tap
        if (passedValue != nil) {
            
            // populate it with the current Fabric
            fabricName.text = fabrics[passedValue].fabricName
            fabricTime.text = "\(fabrics[passedValue].fabricTime)"

        } else {
            
            resetUI()
        }
        
        // needed for the keyboard
        self.fabricName.delegate = self
        self.fabricTime.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // for handling the return key when it is clicked from the keyboard
    // requires UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        checkErrorMessage()
        
        textField.resignFirstResponder()
        return true;
    }
    
    // if the user taps outside the keyboard to add the item
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
        
        checkErrorMessage()
    }
    
    // only allow numbers
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        errorMessage.hidden = true
        
        // the seconds tag == 2
        if (textField.tag != 2) {
            return true
        }
       
        let newLength = count(textField.text.utf16) + count(string.utf16) - range.length
        
        return newLength <= 3
        
    }
    
    func checkErrorMessage() {
        
        var errors = false
        
        if fabricName.text.isEmpty {
            
            errors = true
            errorMessage.hidden = false
            errorMessage.text = "Sorry, fabric name is required"
            
        } else if fabricTime.text.isEmpty {
            
            errors = true
            errorMessage.hidden = false
            errorMessage.text = "Sorry, number of seconds is required"
            
        } else if fabricTime.text == "0" {
            
            errors = true
            errorMessage.hidden = false
            errorMessage.text = "Please use seconds in the set of counting numbers :) "
            
        }
        else {
         
            errors = false
            errorMessage.hidden = true
            
        }
        
        if (errors) {
            doneButton.enabled = false
        } else {
            doneButton.enabled = true
        }
        
    }
    
}
