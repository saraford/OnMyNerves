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
    
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
     //   SaveImage.moveImages(fabricImageList, fromIndexPath.row, toIndexPath.row)
        
        var nameToMove = fabricNameList[fromIndexPath.row]
        fabricNameList.removeAtIndex(fromIndexPath.row)
        fabricNameList.insert(nameToMove, atIndex: toIndexPath.row)

        var timeToMove = fabricNameList[fromIndexPath.row]
        fabricNameList.removeAtIndex(fromIndexPath.row)
        fabricNameList.insert(timeToMove, atIndex: toIndexPath.row)

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fabricNameList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = fabricsTable.dequeueReusableCellWithIdentifier("fabricCell") as! UITableViewCell

        var imageFilename = SaveImage.imageDirPath() + fabricNameList[indexPath.row] + ".jpg"

        (cell.contentView.viewWithTag(1) as! UIImageView).image = UIImage(named: imageFilename)
        (cell.contentView.viewWithTag(2) as! UILabel).text = fabricNameList[indexPath.row]
        (cell.contentView.viewWithTag(3) as! UILabel).text = "\(fabricTimeList[indexPath.row])"
        
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {

    }
    
    override func viewWillAppear(animated: Bool) {
        
        if (fabricNameList.count == 0) {
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

            //TODO need a way to delete
            
            NSUserDefaults.standardUserDefaults().setObject(fabricNameList, forKey: "fabricNameList")
            NSUserDefaults.standardUserDefaults().setObject(fabricTimeList, forKey: "fabricTimeList")

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
