//
//  StatsViewController.swift
//  On My Nerves
//
//  Created by Sara Ford on 9/4/15.
//  Copyright (c) 2015 Sara Ford. All rights reserved.
//

import UIKit


// Needed for the MonthPicker Lightbox view controller to send
// the selected Month picked back to this Stats view controller
extension StatsViewController: MonthPickedDelegate {
    func changeMonth(row: Int) {
        // NSLog("getting data from TimePickerDelegate")
        
        self.lastSelectedMonthIndex = row
        
        var key = (Array(data.keys)[row])
        self.monthButton.setTitle("\(key.monthName) \(key.year)", forState: UIControlState.Normal)
        
        updatePieChart(row)
    }
}

class StatsViewController: UIViewController {
    
    @IBOutlet weak var statsLabel: UILabel!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var monthButton: UIButton!
    
    var lastSelectedMonthIndex:Int = 0
    var data = Dictionary<MonthYear, Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var dataExists = loadStatsFromDisk()

        if (dataExists) {

            var key = (Array(data.keys)[lastSelectedMonthIndex])
            
            self.monthButton.setTitle("\(key.monthName) \(key.year)", forState: UIControlState.Normal)
            self.monthButton.enabled = true

            updatePieChart(lastSelectedMonthIndex)

        } else {
        
            // there's no data. first run state
            self.monthButton.setTitle("No Usage Found", forState: UIControlState.Normal)
            self.monthButton.enabled = false

            statsLabel.text = "Usage is recorded after finishing the last fabric in queue."

        }
        
    }
    
    @IBAction func showMonthPicker(sender: AnyObject) {
        
        var monthPickerVC = self.storyboard?.instantiateViewControllerWithIdentifier("myMonthPicker") as! MonthPickerViewController
        
        // all this stuff needed to get the lightbox control effect
        monthPickerVC.providesPresentationContextTransitionStyle = true
        monthPickerVC.definesPresentationContext = true
        monthPickerVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        // tell the picker what the previously-selected value is, if any.
        monthPickerVC.delegate = self
        monthPickerVC.prevSelectedMonthIndex = lastSelectedMonthIndex
        
        // give the data to the monthPicker
        monthPickerVC.data = data
        
        self.presentViewController(monthPickerVC, animated: false, completion: nil)

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
            
            statsLabel.text = "So far in \(key.monthName), you have completed \(Int(days)) days out of \(today) days for a score of \(ceil(percentageCompleted * 100))%"
            
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
    
    func loadStatsFromDisk() -> Bool {
        
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
        
            return true
            
        }
        else {
            
            return false
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
