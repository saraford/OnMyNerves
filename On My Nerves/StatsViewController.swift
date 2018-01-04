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
    func changeMonth(_ row: Int) {
        // NSLog("getting data from TimePickerDelegate")
        
        self.lastSelectedMonthIndex = row
        
        let key = (Array(data.keys)[row])
        self.monthButton.setTitle("\(key.monthName) \(key.year)", for: UIControlState())
        
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
  
        //TODO: STATS: Here's where to load stats
//        let dataExists = loadStatsFromDisk()
        let dataExists = false
        
        if (dataExists) {

            let key = (Array(data.keys)[lastSelectedMonthIndex])
            
            self.monthButton.setTitle("\(key.monthName) \(key.year)", for: UIControlState())
            self.monthButton.setTitleColor(defaultBlue, for: UIControlState())
            self.monthButton.isEnabled = true

            updatePieChart(lastSelectedMonthIndex)

        } else {
        
            // there's no data. first run state
            self.monthButton.setTitle("No Usage Found", for: UIControlState())
            self.monthButton.setTitleColor(UIColor.darkGray, for: UIControlState())
            self.monthButton.isEnabled = false

            statsLabel.text = "Usage is recorded after finishing the last fabric in queue."

        }
        
    }
    
    @IBAction func showMonthPicker(_ sender: AnyObject) {
        
        let monthPickerVC = self.storyboard?.instantiateViewController(withIdentifier: "myMonthPicker") as! MonthPickerViewController
        
        // all this stuff needed to get the lightbox control effect
        monthPickerVC.providesPresentationContextTransitionStyle = true
        monthPickerVC.definesPresentationContext = true
        monthPickerVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        // tell the picker what the previously-selected value is, if any.
        monthPickerVC.delegate = self
        monthPickerVC.prevSelectedMonthIndex = lastSelectedMonthIndex
        
        // give the data to the monthPicker
        monthPickerVC.data = data
        
        self.present(monthPickerVC, animated: false, completion: nil)

    }
    
    func updatePieChart(_ row: Int) {

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

        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let day = (cal as NSCalendar).components(NSCalendar.Unit.day, from: now)
        
        return day.day!
        
    }
    
    // TODO: STATS: Replace using Core Data
    func loadStatsFromDisk() -> Bool {
        
        return false
        
//        // load data
//        if NSUserDefaults.standardUserDefaults().objectForKey("fabricCompleted") != nil {
//            
//            fabricCompletedArray = NSUserDefaults.standardUserDefaults().objectForKey("fabricCompleted") as! [String]
//
//            let dateFormatter = NSDateFormatter()
//            dateFormatter.dateFormat = "MM/dd/yyyy"
//            
//            // display data
//            for stat in fabricCompletedArray {
//                
//                let monthYear = MonthYear(stat: stat)
//                
//                if let countForMonth = data[monthYear] {
//                    
//                    let newCount = countForMonth + 1
//                    
//                    data.updateValue(newCount, forKey: monthYear)
//                    
//                } else {
//                    
//                    // didn't find monthYear, so add it
//                    data[monthYear] = 1
//                    
//                }
//                
//            }
//        
//            return true
//            
//        }
//        else {
//            
//            return false
//        }

    }
    
    func printStats() {
        
        print(data)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func CloseWindow(_ sender: AnyObject) {
        
        self.dismiss(animated: false, completion: nil)
        
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
