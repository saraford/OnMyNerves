//
//  AddEditFabricsViewController.swift
//  On My Nerves
//
//  Created by Sara Ford on 8/1/15.
//  Copyright (c) 2015 Sara Ford. All rights reserved.
//

import UIKit

class AddEditFabricsViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var fabricName: UITextField!
    @IBOutlet weak var fabricImage: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var fabricTime: UITextField!

    @IBAction func saveUpdate(sender: UIButton) {
        
        fabricNameList.append(fabricName.text)
        fabricTimeList.append(fabricTime.text.toInt()!)
        
        SaveImage.storeImage(fabricImage.image!, name: fabricName.text)
        NSUserDefaults.standardUserDefaults().setObject(fabricNameList, forKey: "fabricNameList")
        NSUserDefaults.standardUserDefaults().setObject(fabricTimeList, forKey: "fabricTimeList")
        
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
    
    @IBAction func choosePhoto(sender: AnyObject) {
        // creates a view controller that goes out of the app to the photo library or camera
        var image = UIImagePickerController()
        image.delegate = self
        
        // change this to camera for the actual camera on the phone
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        // shows this view controller
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    // once an image has been chosen, this is called
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        fabricImage.image = image;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        textField.resignFirstResponder()
        return true;
    }
    
    // if the user taps outside the keyboard to add the item
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    // only allow numbers
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // the seconds tag == 2
        if (textField.tag != 2) {
            return true
        }
        
        let invalidCharacters = NSCharacterSet(charactersInString: "0123456789").invertedSet
        if let range = string.rangeOfCharacterFromSet(invalidCharacters, options: nil, range:Range<String.Index>(start: string.startIndex, end: string.endIndex)) {
            return false
        }
        
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
