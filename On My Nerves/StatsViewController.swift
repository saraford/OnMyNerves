//
//  StatsViewController.swift
//  On My Nerves
//
//  Created by Sara Ford on 9/4/15.
//  Copyright (c) 2015 Sara Ford. All rights reserved.
//

import UIKit
import CoreData

// Needed for the MonthPicker Lightbox view controller to send
// the selected Month picked back to this Stats view controller
extension StatsViewController: MonthPickedDelegate {
    func changeMonth(row: Int) {
        // NSLog("getting data from TimePickerDelegate")
        
        self.lastSelectedMonthIndex = row
        
        let key = (Array(data.keys)[row])
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
    var defaultBlue = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        let dataExists = loadStatsFromDisk()
        
        if (dataExists) {

            let key = (Array(data.keys)[lastSelectedMonthIndex])
            
            self.monthButton.setTitle("\(key.monthName) \(key.year)", forState: UIControlState.Normal)
            self.monthButton.setTitleColor(defaultBlue, forState: .Normal)
            self.monthButton.enabled = true

            updatePieChart(lastSelectedMonthIndex)

        } else {
        
            // there's no data. first run state
            self.monthButton.setTitle("No Usage Found", forState: UIControlState.Normal)
            self.monthButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
            self.monthButton.enabled = false

            statsLabel.text = "Usage is recorded after finishing the last fabric in queue."

        }
        
    }
    
    @IBAction func showMonthPicker(sender: AnyObject) {
        
        let monthPickerVC = self.storyboard?.instantiateViewControllerWithIdentifier("myMonthPicker") as! MonthPickerViewController
        
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

        let key = (Array(data.keys)[row])
        let days = data[key]!

        // subtracting one because current day shouldn't count
        let totalPossibleDaysInMonthThusFar = key.daysInMonth - 1
        
        let percentageCompleted = Float(days) / Float(totalPossibleDaysInMonthThusFar)

        // update chart
        pieChart.completedPercentage = CGFloat(percentageCompleted)

        // update label        
        if (key.isCurrentMonthYear()) {

            // subtracting because the current day shouldn't count
            let today = getTodaysDay() - 1
            
            statsLabel.text = "So far in \(key.monthName), you have completed \(Int(days)) days out of \(today) days for a score of \(ceil(percentageCompleted * 100))%"
            
        } else {
            
            statsLabel.text = "Completed \(Int(days)) days in \(key.monthName) for \(ceil(percentageCompleted * 100))%"
        }
        
    }
    
    func getTodaysDay() -> Int {

        let now = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd"
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let day = cal!.components(NSCalendarUnit.Day, fromDate: now)
        
        return day.day
        
    }
    
    func loadStatsFromDisk() -> Bool {
        
        let request = NSFetchRequest(entityName: "Usages")
        request.returnsObjectsAsFaults = false
        
        do {
            
            let results = try context.executeFetchRequest(request)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    
                    if let timestamp = result.valueForKey("timestamp") as? NSDate {
                       
                        let monthYear = MonthYear(date: timestamp)
                        
                        if let countForMonth = data[monthYear] {
                            
                            let newCount = countForMonth + 1
                            
                            data.updateValue(newCount, forKey: monthYear)
                            
                        } else {
                            
                            // didn't find monthYear, so add it ???
                            data[monthYear] = 1
                            
                        }
                        
                    }
                    
                }
                
            }
            
        } catch {
            
            print("Fetch failed" + String(error))
            return false
        }

        return true
    }
    
    func printStats() {
        
        print(data)
        
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
