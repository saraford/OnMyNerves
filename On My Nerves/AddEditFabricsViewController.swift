//
//  AddEditFabricsViewController.swift
//  On My Nerves
//
//  Created by Sara Ford on 8/1/15.
//  Copyright (c) 2015 Sara Ford. All rights reserved.
//

import UIKit

// Needed for the ColorPicker Lightbox view controller to send
// the color picked back to this main view controller
extension AddEditFabricsViewController: ColorPickedDelegate {
    func updateData(data: String) {
        
        self.desiredColor = data
        
        fabricColor.backgroundColor = CreateColors.createColor(desiredColor)
    }
}

extension AddEditFabricsViewController: SecondsPickedDelegate {
    func updateTime(data: String) {
        
        self.desiredTime = data

        self.fabricTime.setTitle(desiredTime, forState: UIControlState.Normal)
    }
}

class AddEditFabricsViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var fabricName: UITextField!
    @IBOutlet weak var fabricColor: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var fabricTime: UIButton!
    @IBOutlet weak var navBar: UINavigationItem!
    
    // we only persist the color while this VC is still open. I'm not saving this to disk. Blah.
    var desiredColor:String = "Red"
    var desiredTime:String!
    
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
            newFabric.fabricTime = fabricTime.titleLabel!.text!.toInt()!
            newFabric.fabricColor = desiredColor
            
            fabrics.append(newFabric)
            
            // add data to the arrays to save to disk
            fabricNamesArray.append(fabricName.text)
            fabricTimesArray.append(fabricTime.titleLabel!.text!.toInt()!)
            fabricColorsArray.append(newFabric.fabricColor)
            
            
        } else {
            
            // save the info the user entered into the fields
            fabrics[passedValue].fabricName = fabricName.text
            fabrics[passedValue].fabricTime = fabricTime.titleLabel!.text!.toInt()!
            fabrics[passedValue].fabricColor = desiredColor

            // update data to the arrays to save to disk
            fabricNamesArray[passedValue] = fabricName.text
            fabricTimesArray[passedValue] = fabricTime.titleLabel!.text!.toInt()!
            fabricColorsArray[passedValue] = fabrics[passedValue].fabricColor
            
            passedValue = nil
        }
        
        // and now update
        NSUserDefaults.standardUserDefaults().setObject(fabricNamesArray, forKey: "fabricNames")
        NSUserDefaults.standardUserDefaults().setObject(fabricTimesArray, forKey: "fabricTimes")
        NSUserDefaults.standardUserDefaults().setObject(fabricColorsArray, forKey: "fabricColors")
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func textChange(sender: AnyObject) {
        if (fabricName.text == "") {
            
            doneButton.enabled = false
            
        } else {
            
            doneButton.enabled = true
        }
    }
    
    @IBAction func cancelUpdate(sender: AnyObject) {
    
        self.dismissViewControllerAnimated(true, completion: nil)
    
    }

    
    @IBAction func showTimePicker(sender: AnyObject) {
        
        var timePickerVC = self.storyboard?.instantiateViewControllerWithIdentifier("myTimePicker") as! SecondsPickerViewController
        
        // all this stuff needed to get the lightbox control effect
        timePickerVC.providesPresentationContextTransitionStyle = true
        timePickerVC.definesPresentationContext = true
        timePickerVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        // tell the picker what the previously-selected value is, if any.
        timePickerVC.delegate = self
        timePickerVC.prevSelectedTime = fabricTime.titleLabel!.text!
        
        self.presentViewController(timePickerVC, animated: false, completion: nil)

        
    }
    
    @IBAction func choosePhoto(sender: AnyObject) {
        // creates a view controller that goes out of the app to the photo library or camera
        
        var image = UIImagePickerController()
        image.delegate = self
        
        if (sender.tag == 5) {
            image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        } else {
            image.sourceType = UIImagePickerControllerSourceType.Camera
        }
        image.allowsEditing = false
        
        // shows this view controller
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func resetUI() {
    
        // populate it with the current Fabric
        fabricName.text = "Drew"
        fabricTime.setTitle("5", forState: .Normal)
        fabricColor.backgroundColor = CreateColors.createColor("Red")

    }
    
    // this isn't called from the add (+), only from the edit
    override func viewWillAppear(animated: Bool) {

        // am I being called?
        println("viewWillAppear")
        
    }
    

    @IBAction func showColorPicker(sender: AnyObject) {
        
        var colorPickerVC = self.storyboard?.instantiateViewControllerWithIdentifier("myColorPicker") as! ColorPickerViewController
        
        // all this stuff needed to get the lightbox control effect
        colorPickerVC.providesPresentationContextTransitionStyle = true
        colorPickerVC.definesPresentationContext = true
        colorPickerVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        // tell the picker what the previously-selected value is, if any.
        colorPickerVC.delegate = self
        colorPickerVC.prevSelectedColor = desiredColor
        
        self.presentViewController(colorPickerVC, animated: false, completion: nil)

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
            fabricTime.setTitle("\(fabrics[passedValue].fabricTime)", forState: .Normal)
            fabricColor.backgroundColor = CreateColors.createColor(fabrics[passedValue].fabricColor)

        } else {
            
            resetUI()
        }
        
        // needed for the keyboard
        self.fabricName.delegate = self
//        self.fabricTime.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // for handling the return key when it is clicked from the keyboard
    // requires UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true;
    }
    
    // if the user taps outside the keyboard to add the item
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
//    // only allow numbers
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        
//        // the seconds tag == 2
//        if (textField.tag != 2) {
//            return true
//        }
//        
//        let invalidCharacters = NSCharacterSet(charactersInString: "0123456789").invertedSet
//        if let range = string.rangeOfCharacterFromSet(invalidCharacters, options: nil, range:Range<String.Index>(start: string.startIndex, end: string.endIndex)) {
//            return false
//        }
//        
//        return true
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
