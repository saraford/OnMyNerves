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
    
    @IBAction func saveUpdate(_ sender: UIButton) {

        if (passedValue == nil) {
            
            // newly created fabric
//            var index: Int = 0
//            if (fabrics.count > 0) {
//                index = fabrics.count - 1
//            }
            
            // create a new fabric
            let newFabric = Fabric()
            
            newFabric.fabricName = fabricName.text!
            newFabric.fabricTime = Int(fabricTime.text!)!
            
            fabrics.append(newFabric)
            
            // add data to the arrays to save to disk
            fabricNamesArray.append(fabricName.text!)
            fabricTimesArray.append(Int(fabricTime.text!)!)
            
            
        } else {
            
            // save the info the user entered into the fields
            fabrics[passedValue].fabricName = fabricName.text!
            fabrics[passedValue].fabricTime = Int(fabricTime.text!)!

            // update data to the arrays to save to disk
            fabricNamesArray[passedValue] = fabricName.text!
            fabricTimesArray[passedValue] = Int(fabricTime.text!)!
            
            passedValue = nil
        }
        
        // and now update
        UserDefaults.standard.set(fabricNamesArray, forKey: "fabricNames")
        UserDefaults.standard.set(fabricTimesArray, forKey: "fabricTimes")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancelUpdate(_ sender: AnyObject) {
    
        self.dismiss(animated: true, completion: nil)
    
    }
    
    func resetUI() {
    
        // populate it with the current Fabric
        fabricName.text = ""
        fabricTime.text = "59"
    }
    
    // this isn't called from the add (+), only from the edit
    override func viewWillAppear(_ animated: Bool) {

        // am I being called?
      // println("viewWillAppear")
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        println("viewDidLoad: the valuePassed is \(passedValue)")
  
        if (passedValue == nil) {
            
            // set UI as new fabric
            self.navBar.title = "Add new fabric"
            doneButton.setTitle("Add", for: UIControlState())
            
            doneButton.isEnabled = false
            
        } else {
            
            // Just making an edit
            self.navBar.title = "Edit fabric info"
            doneButton.setTitle("Save", for: UIControlState())
            
            doneButton.isEnabled = false
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        checkErrorMessage()
        
        textField.resignFirstResponder()
        return true;
    }
    
    // if the user taps outside the keyboard to add the item
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
        checkErrorMessage()
    }
    
    // only allow numbers
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        errorMessage.isHidden = true
        
        // the seconds tag == 2
        if (textField.tag != 2) {
            return true
        }
       
        let newLength = textField.text!.utf16.count + string.utf16.count - range.length
        
        return newLength <= 3
        
    }
    
    func checkErrorMessage() {
        
        var errors = false
        
        if fabricName.text!.isEmpty {
            
            errors = true
            errorMessage.isHidden = false
            errorMessage.text = "Sorry, fabric name is required"
            
        } else if fabricTime.text!.isEmpty {
            
            errors = true
            errorMessage.isHidden = false
            errorMessage.text = "Sorry, number of seconds is required"
            
        } else if fabricTime.text == "0" {
            
            errors = true
            errorMessage.isHidden = false
            errorMessage.text = "Please specify seconds in the set of counting numbers :) "
            
        }
        else {
         
            errors = false
            errorMessage.isHidden = true
            
        }
        
        if (errors) {
            doneButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
        }
        
        if fabricTime.text!.isEmpty && fabricName.text!.isEmpty {
            doneButton.isEnabled = false
        }
        
    }
    
}
