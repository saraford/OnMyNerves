//
//  ColorPickerViewController.swift
//  On My Nerves
//
//  Created by Sara Ford on 8/16/15.
//  Copyright (c) 2015 Sara Ford. All rights reserved.
//

import UIKit

protocol ColorPickedDelegate {
    
    func updateData(data: String)
}

class ColorPickerViewController: UIViewController, UITableViewDelegate {
    
    var prevSelectedColor:String!
    var delegate: ColorPickedDelegate?
    var colorSelected:String!
    
    @IBOutlet weak var lightboxView: UIView!
    @IBOutlet weak var colorPickerTable: UITableView!

    let colorsToPickFrom = [
       "Blue", "Green", "Red", "Sandpaper", "Black", "White"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        lightboxView.layer.cornerRadius = 10.0
        lightboxView.layer.masksToBounds = true
        
        // already select based on previous, if one exists
        if (prevSelectedColor != nil) {
            
            var row = find(colorsToPickFrom, prevSelectedColor)!
            var index = NSIndexPath(forRow: row, inSection: 0)
            
            colorPickerTable.selectRowAtIndexPath(index, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
            
        }
        
        
   }
    
    
    @IBAction func CancelWindow(sender: AnyObject) {
        
        colorSelected = nil
        self.dismissViewControllerAnimated(false, completion: nil)
        
    }
    
    @IBAction func CloseWindow(sender: UIButton) {

        // commit only when user is done selecting a color
        if (colorSelected != nil) {
            self.delegate?.updateData(colorSelected)
        }
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colorsToPickFrom.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = colorPickerTable.dequeueReusableCellWithIdentifier("colorCell") as! UITableViewCell
        
        var colorTitle = colorsToPickFrom[indexPath.row]
        
        var image = CreateColors.createImageFromColor(colorTitle)
        
        (cell.contentView.viewWithTag(1) as! UIImageView).image = image
        (cell.contentView.viewWithTag(2) as! UILabel).text = colorTitle
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        colorSelected = colorsToPickFrom[indexPath.row]
        
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

