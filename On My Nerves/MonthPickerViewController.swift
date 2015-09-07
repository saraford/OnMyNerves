//
//  MonthPickerViewController.swift
//  On My Nerves
//
//  Created by Sara Ford on 9/6/15.
//  Copyright (c) 2015 Sara Ford. All rights reserved.
//

import UIKit

protocol MonthPickedDelegate {
    func changeMonth(row: Int)
}

class MonthPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var prevSelectedMonthIndex:Int!
    var currentSelectedMonthIndex:Int = 0
    var delegate: MonthPickedDelegate?
    var data = Dictionary<MonthYear, Int>()
    
    @IBOutlet weak var lightboxView: UIView!
    @IBOutlet weak var monthPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        lightboxView.layer.cornerRadius = 10.0
        lightboxView.layer.masksToBounds = true

        self.monthPicker.delegate = self
        self.monthPicker.dataSource = self
        
        monthPicker.selectRow(prevSelectedMonthIndex, inComponent: 0, animated: true)
    }
    
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var monthYear = Array(data.keys)[row]
        var displayString = "\(monthYear.monthName) \(monthYear.year)"
        
        return "\(displayString)"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
  
        currentSelectedMonthIndex = row
        
    }
    
    @IBAction func closeWindow(sender: AnyObject) {
        
        self.delegate?.changeMonth(currentSelectedMonthIndex)
        
        self.dismissViewControllerAnimated(false, completion: nil)
    
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




