//
//  TimerPickerViewController.swift
//  MyTimer
//
//  Created by Sara Ford on 7/11/15.
//  Copyright (c) 2015 Sara Ford. All rights reserved.
//

import UIKit

protocol SecondsPickedDelegate {
    func updateTime(data: String)
}

class SecondsPickerViewController: UIViewController, UIPickerViewDelegate {
    
    var prevSelectedTime:String!
    var delegate: SecondsPickedDelegate?
    
    @IBOutlet weak var lightboxView: UIView!
    @IBOutlet weak var timePicker: UIPickerView!
    
    // must always be an even number to start in hot and end in cold - must *always* end in cold
    var secondsToPickFrom = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize the seconds
        if (secondsToPickFrom.count == 0) {
            createSecondsArray()
        }
        
        lightboxView.layer.cornerRadius = 10.0
        lightboxView.layer.masksToBounds = true
        
        // already select based on previous, if one exists
        if (prevSelectedTime != nil) {

            var index = find(secondsToPickFrom, prevSelectedTime)!
            timePicker.selectRow(index, inComponent: 0, animated: true)
            
        }
        
    }
    
    func createSecondsArray() {
        
        for (var i = 4; i<59; i++) {
            
            secondsToPickFrom.append("\(i+1)")
        }
        
    }
    
    
    @IBAction func CloseWindow(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // returns the number of 'columns' to display
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return secondsToPickFrom.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return secondsToPickFrom[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        var timeSelected = secondsToPickFrom[row]
        self.delegate?.updateTime(timeSelected)
        
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




