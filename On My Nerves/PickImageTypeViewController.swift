//
//  PickImageTypeViewController.swift
//  On My Nerves
//
//  Created by Sara Ford on 8/21/15.
//  Copyright (c) 2015 Sara Ford. All rights reserved.
//

import UIKit

enum PickImageType {
    case PickImage
    case UseColor
    case TakePhoto
    case UsePhoto
}

protocol ImageTypePickedDelegate {
    func imageTypePicked(data: PickImageType)
}

class PickImageTypeViewController: UIViewController {

    var delegate: ImageTypePickedDelegate?
    var optionsArray:[String] = ["Select an image", "Pick a color", "Choose from photos", "Take a photo"]
    
    @IBOutlet weak var lightboxView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize the seconds

        
        lightboxView.layer.cornerRadius = 10.0
        lightboxView.layer.masksToBounds = true
        
        
    }
    
    
    @IBAction func CloseWindow(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    

    @IBAction func pickImage(sender: UIButton) {
    
        self.delegate?.imageTypePicked(PickImageType.PickImage)
        
        var colorPickerVC = self.storyboard?.instantiateViewControllerWithIdentifier("myColorPicker") as! ColorPickerViewController
        
        // all this stuff needed to get the lightbox control effect
        colorPickerVC.providesPresentationContextTransitionStyle = true
        colorPickerVC.definesPresentationContext = true
        colorPickerVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        // tell the picker what the previously-selected value is, if any.

        //STARTHERE - how to get the AddEditFabricsVC to pass here as the "Self" here
        
        
        //        colorPickerVC.delegate = self
//        colorPickerVC.prevSelectedColor = desiredColor
        
        self.presentViewController(colorPickerVC, animated: false, completion: nil)

//                self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func useColor(sender: UIButton) {

        self.delegate?.imageTypePicked(PickImageType.UseColor)
        
    }
    
    @IBAction func takePhoto(sender: UIButton) {

        self.delegate?.imageTypePicked(PickImageType.TakePhoto)
        
    }
    
    @IBAction func usePhoto(sender: UIButton) {
        
        self.delegate?.imageTypePicked(PickImageType.UsePhoto)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    
}