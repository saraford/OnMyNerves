//
//  FabricListViewController.swift
//  On My Nerves
//
//  Created by Sara Ford on 8/1/15.
//  Copyright (c) 2015 Sara Ford. All rights reserved.
//

import UIKit

class FabricListViewController: UIViewController, UITableViewDelegate {

    @IBOutlet var fabricsTable: UITableView!
    @IBOutlet weak var newFabricButton: UIButton!
    @IBOutlet weak var reorderButton: UIButton!
    
    var fabricName: UILabel?
    
    @IBAction func startEditing(sender: AnyObject) {
        fabricsTable.editing = !fabricsTable.editing
        newFabricButton.enabled = !fabricsTable.editing
        
        if (fabricsTable.editing) {
            reorderButton.setTitle("Done", forState: UIControlState.Normal)
        } else {
            reorderButton.setTitle("Reorder", forState: UIControlState.Normal)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    var valueToPass:Int!
    var fromTableView:Bool = false
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        valueToPass = indexPath.row
        fromTableView = true
        performSegueWithIdentifier("fabricSegue", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        // keep getting an error when trying to have two segues
        // so going to do this less elegant solution approach
        if (segue.identifier == "fabricSegue") {

            var viewController = segue.destinationViewController as! AddEditFabricsViewController
            
            if (fromTableView) {
               
//                println("you clicked a cell!")
                viewController.passedValue = valueToPass
                
            } else {

//                println("you clicked the + button!")
                viewController.passedValue = nil
                
            }

           fromTableView = false

        }
    }
    
    
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

        // need to move the objects first
        var fabricToMove = fabrics[fromIndexPath.row]
        fabrics.removeAtIndex(fromIndexPath.row)
        fabrics.insert(fabricToMove, atIndex: toIndexPath.row)
        
        // now the arrays for the data we're saving to disk
        var nameToMove = fabricNamesArray[fromIndexPath.row]
        fabricNamesArray.removeAtIndex(fromIndexPath.row)
        fabricNamesArray.insert(nameToMove, atIndex: toIndexPath.row)

        var timeToMove = fabricTimesArray[fromIndexPath.row]
        fabricTimesArray.removeAtIndex(fromIndexPath.row)
        fabricTimesArray.insert(timeToMove, atIndex: toIndexPath.row)

        var imageToMove = fabricImagenamesArray[fromIndexPath.row]
        fabricImagenamesArray.removeAtIndex(fromIndexPath.row)
        fabricImagenamesArray.insert(imageToMove, atIndex: toIndexPath.row)
        
        // resave everything
        NSUserDefaults.standardUserDefaults().setObject(fabricNamesArray, forKey: "fabricNames")
        NSUserDefaults.standardUserDefaults().setObject(fabricTimesArray, forKey: "fabricTimes")
        NSUserDefaults.standardUserDefaults().setObject(fabricImagenamesArray, forKey: "fabricImagenames")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fabrics.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = fabricsTable.dequeueReusableCellWithIdentifier("fabricCell") as! UITableViewCell
        
        var imageFilename = fabrics[indexPath.row].fabricImageName
        var image = fabrics[indexPath.row].retrieveImage()
        
        (cell.contentView.viewWithTag(1) as! UIImageView).image = image
        (cell.contentView.viewWithTag(2) as! UILabel).text = fabrics[indexPath.row].fabricName
        (cell.contentView.viewWithTag(3) as! UILabel).text = "\(fabrics[indexPath.row].fabricTime)"
        
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {

    }
    
    override func viewWillAppear(animated: Bool) {
        
        if (fabrics.count == 0) {
            reorderButton.enabled = false
        } else {
            reorderButton.enabled = true
        }
        
        fabricsTable.reloadData()
    }
    
    // swipe to left is considered editing
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // swipe to the left
        if (editingStyle == UITableViewCellEditingStyle.Delete) {

            var index = indexPath.row

            // delete the image
            fabrics[index].deleteImage()
            
            // delete the object
            fabrics.removeAtIndex(index)
            
            // delete stuff on the array to be saved to disk
            fabricNamesArray.removeAtIndex(index)
            fabricTimesArray.removeAtIndex(index)
            fabricImagenamesArray.removeAtIndex(index)

            // resave everything
            NSUserDefaults.standardUserDefaults().setObject(fabricNamesArray, forKey: "fabricNames")
            NSUserDefaults.standardUserDefaults().setObject(fabricTimesArray, forKey: "fabricTimes")
            NSUserDefaults.standardUserDefaults().setObject(fabricImagenamesArray, forKey: "fabricImagenames")
            
            fabricsTable.reloadData()
        }
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
