//
//  StatsViewController.swift
//  On My Nerves
//
//  Created by Sara Ford on 9/4/15.
//  Copyright (c) 2015 Sara Ford. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var statsLabel: UILabel!
    @IBOutlet weak var monthPicker: UIPickerView!
    @IBOutlet weak var pieChart: PieChartView!
    
    var data = Dictionary<MonthYear, Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.monthPicker.delegate = self
        self.monthPicker.dataSource = self
        
        loadStatsFromDisk()
        
        monthPicker.selectRow(0, inComponent: 0, animated: false)
        updatePieChart(0)
        
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

        updatePieChart(row)
        
    }

    func updatePieChart(row: Int) {

        var key = (Array(data.keys)[row])
        var days = data[key]!

        // subtracting one because current day shouldn't count
        var totalPossibleDaysInMonthThusFar = key.daysInMonth - 1
        
        var percentageCompleted = Float(days) / Float(totalPossibleDaysInMonthThusFar)

        // update chart
        pieChart.completedPercentage = CGFloat(percentageCompleted)

        // update label        
        if (key.isCurrentMonthYear()) {

            // subtracting because the current day shouldn't count
            var today = getTodaysDay() - 1
            
            statsLabel.text = "So far in \(key.monthName), you have completed \(Int(days)) days out of \(today) days for a grade of \(ceil(percentageCompleted * 100))%"
            
        } else {
            
            statsLabel.text = "Completed \(Int(days)) days in \(key.monthName) for \(ceil(percentageCompleted * 100))%"
        }
        
    }
    
    func getTodaysDay() -> Int {

        var now = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd"
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let day = cal!.components(NSCalendarUnit.CalendarUnitDay, fromDate: now)
        
        return day.day
        
    }
    
    func loadStatsFromDisk() {
        
        // load data
        if NSUserDefaults.standardUserDefaults().objectForKey("fabricCompleted") != nil {
            
            fabricCompletedArray = NSUserDefaults.standardUserDefaults().objectForKey("fabricCompleted") as! [String]

            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            
            // display data
            for stat in fabricCompletedArray {
                
                var monthYear = MonthYear(stat: stat)
                
                if let countForMonth = data[monthYear] {
                    
                    var newCount = countForMonth + 1
                    
                    data.updateValue(newCount, forKey: monthYear)
                    
                } else {
                    
                    // didn't find monthYear, so add it
                    data[monthYear] = 1
                    
                }
                
            }
        
            
        }
        else {
            
           // statsTextField.text = "Sorry, nothing to display"
            
        }

    }
    
    func printStats() {
        
        println(data)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func CloseWindow(sender: AnyObject) {
        
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
